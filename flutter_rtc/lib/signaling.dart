import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_rtc/models/models.dart';
import 'firebase_storages.dart';

enum SignalingState {
  Open,
  Closed,
  Error,
}

enum CallState {
  New,
  Ringing,
  Invite,
  Connected,
  Leave,
}

/// Mỗi session sẽ đại diện một kết nối đến 1 peer connection
/// remoteCallId là Id của người mà đang kết nối đến
class Session {
  Session({required this.sessionId, required this.remoteUserId});
  String remoteUserId;
  String sessionId;
  RTCPeerConnection? peerConnection;
  RTCDataChannel? dataChannel;
  List<RTCIceCandidate> remoteCandidates = [];
  StreamSubscription? candidateSubscription;

  Future<void> closeSession() async {
    await peerConnection?.close();
    await dataChannel?.close();
    candidateSubscription?.cancel();
    candidateSubscription = null;
  }
}

class MakeConnectionError implements Exception {}

class CreateOfferError implements Exception {}

class CreateAnswerError implements Exception {}

class Signaling {
  Signaling(this._user, this._firebaseStorage);
  final User _user;
  final FirebaseStorage _firebaseStorage;

  Map<String, Session> _session = {};
  MediaStream? _localStream;
  List<MediaStream> _remoteStreams = <MediaStream>[];

  StreamSubscription? _offersSubscription;
  StreamSubscription? _answersSubscription;

  String get sdpSemantics =>
      WebRTC.platformIsWindows ? 'plan-b' : 'unified-plan';

  Map<String, dynamic> _iceServers = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };

  final Map<String, dynamic> _dataChannelConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  Function(SignalingState state)? onSignalingStateChange;
  Function(Session session, CallState state)? onCallStateChange;
  Function(MediaStream stream)? onLocalStream;
  Function(Session session, MediaStream stream)? onAddRemoteStream;
  Function(Session session, MediaStream stream)? onRemoveRemoteStream;
  Function(dynamic event)? onPeersUpdate;
  Function(Session session, RTCDataChannel dc, RTCDataChannelMessage data)?
      onDataChannelMessage;
  Function(Session session, RTCDataChannel dc)? onDataChannel;

  // Connect to to Firebase
  Future<void> connect() async {
    await _firebaseStorage.register(_user);
    onSignalingStateChange?.call(SignalingState.Open);
    _offersSubscription?.cancel();
    _answersSubscription?.cancel();

    /// Offer listener
    _offersSubscription = _firebaseStorage
        .onAddedOffer(_user.id)
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((change) async {
        if (change.type == DocumentChangeType.added) {
          var data = change.doc.data();
          if (data == null) return;
          RTCSignalingInfo offer = RTCSignalingInfo.fromMap(data);
          Session newSession = await _createSession(
              offer.sessionId, offer.fromUserId, offer.mediaType, false);
          _session[newSession.sessionId] = newSession;
          await newSession.peerConnection
              ?.setRemoteDescription(offer.rtcDescription);
          await _createAnswer(newSession, offer.mediaType);
          onCallStateChange?.call(newSession, CallState.New);
        }
      });
    });

    _answersSubscription = _firebaseStorage
        .onAddedAnswer(_user.id)
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((change) async {
        if (change.type == DocumentChangeType.added) {
          var data = change.doc.data();
          if (data == null) return;
          RTCSignalingInfo answer = RTCSignalingInfo.fromMap(data);
          Session? currentSession = _session[answer.sessionId];
          await currentSession?.peerConnection
              ?.setRemoteDescription(answer.rtcDescription);
        }
      });
    });
  }

  Future<void> callTo(
      String userId, MediaType type, bool isSharingScreen) async {
    String sessionId = _user.id + '-' + userId;
    Session session =
        await _createSession(sessionId, userId, type, isSharingScreen);
    _session[session.sessionId] = session;
    if (type == MediaType.Data) _createDataChannel(session);
    _createOffer(session, type);
    onCallStateChange?.call(session, CallState.New);
  }

  void disconnect() {
    //TODO: clear current user on firebase
    _offersSubscription?.cancel();
    _answersSubscription?.cancel();
    _offersSubscription = null;
    _answersSubscription = null;
  }

  Future<Session> _createSession(String sessionId, String remoteUserId,
      MediaType type, bool isSharingScreen) async {
    Session newSession =
        Session(sessionId: sessionId, remoteUserId: remoteUserId);
    if (type != MediaType.Data)
      _localStream = await _createLocalStream(isSharingScreen);
    RTCPeerConnection peerConnection = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': sdpSemantics}
    }, _config);
    if (type != MediaType.Data) {
      switch (sdpSemantics) {
        case 'plan-b':
          peerConnection.onAddStream = (MediaStream stream) {
            onAddRemoteStream?.call(newSession, stream);
            _remoteStreams.add(stream);
          };
          await peerConnection.addStream(_localStream!);
          break;
        case 'unified-plan':
          peerConnection.onTrack = (event) {
            if (event.track.kind == 'video') {
              onAddRemoteStream?.call(newSession, event.streams[0]);
            }
          };
          _localStream?.getTracks().forEach((track) {
            peerConnection.addTrack(track, _localStream!);
          });
          break;
      }
    }

    List<IceCandidate> currentCandidates =
        await _firebaseStorage.getIceCandidateFrom(remoteUserId);
    currentCandidates.forEach((element) {
      peerConnection.addCandidate(element.iceCandidate);
      newSession.remoteCandidates.add(element.iceCandidate);
    });

    peerConnection.onIceCandidate = (candidate) async {
      // This delay is needed to allow enough time to try an ICE candidate
      // before skipping to the next one. 1 second is just an heuristic value
      // and should be thoroughly tested in your own environment.
      await Future.delayed(const Duration(seconds: 1), () async {
        IceCandidate iceCandidate = IceCandidate(sessionId, candidate.sdpMid,
            candidate.sdpMlineIndex, candidate.candidate);
        await _firebaseStorage.updateCandidate(_user.id, iceCandidate);
      });
    };

    peerConnection.onIceConnectionState = (state) {};

    peerConnection.onRemoveStream = (stream) {
      onRemoveRemoteStream?.call(newSession, stream);
      _remoteStreams.removeWhere((element) => element.id == stream.id);
    };

    peerConnection.onDataChannel = (channel) {
      _addDataChannel(newSession, channel);
    };

    newSession.candidateSubscription = _firebaseStorage
        .onAddedCandidate(remoteUserId)
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          var data = change.doc.data();
          if (data == null) return;
          IceCandidate candidate = IceCandidate.fromMap(data);
          print(candidate.toString());
          newSession.peerConnection?.addCandidate(candidate.iceCandidate);
          newSession.remoteCandidates.add(candidate.iceCandidate);
        }
      });
    });

    newSession.peerConnection = peerConnection;

    return newSession;
  }

  Future<MediaStream> _createLocalStream(bool isSharingScreen) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': isSharingScreen ? false : true,
      'video': isSharingScreen
          ? true
          : {
              'mandatory': {
                'minWidth':
                    '640', // Provide your own width, height and frame rate here
                'minHeight': '480',
                'minFrameRate': '30',
              },
              'facingMode': 'user',
              'optional': [],
            }
    };

    MediaStream stream = isSharingScreen
        ? await navigator.mediaDevices.getDisplayMedia(mediaConstraints)
        : await navigator.mediaDevices.getUserMedia(mediaConstraints);
    print("TTTT: _createLocalStream success");
    onLocalStream?.call(stream);
    return stream;
  }

  Future<void> _createDataChannel(Session session) async {
    if (session.peerConnection == null) {
      print('session -> peer connection == null');
      throw MakeConnectionError();
    }
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit()
      ..maxRetransmits = 30;
    RTCDataChannel channel = await session.peerConnection!
        .createDataChannel('fileTransfer', dataChannelDict);
    _addDataChannel(session, channel);
  }

  void _addDataChannel(Session session, RTCDataChannel channel) {
    channel.onDataChannelState = (state) {};
    channel.onMessage = (RTCDataChannelMessage message) {
      onDataChannelMessage?.call(session, channel, message);
    };
    session.dataChannel = channel;
    onDataChannel?.call(session, channel);
  }

  Future<void> _createOffer(Session session, MediaType type) async {
    if (session.peerConnection == null) {
      print('session -> peer connection == null');
      throw CreateOfferError();
    }
    try {
      RTCSessionDescription sessionDescription = await session.peerConnection!
          .createOffer(type == MediaType.Data ? _dataChannelConstraints : {});
      await session.peerConnection!.setLocalDescription(sessionDescription);
      RTCSignalingInfo offer = RTCSignalingInfo(
          _user.id,
          sessionDescription.sdp ?? '',
          sessionDescription.type ?? '',
          type.rawValue,
          session.sessionId);
      print('create offer success' + offer.toString());
      await _firebaseStorage.sendOfferTo(session.remoteUserId, offer);
    } catch (e) {
      print(e.toString());
      throw CreateOfferError();
    }
  }

  Future<void> _createAnswer(Session session, MediaType type) async {
    if (session.peerConnection == null) {
      print('session -> peer connection == null');
      throw CreateAnswerError();
    }
    try {
      RTCSessionDescription sessionDescription = await session.peerConnection!
          .createAnswer(type == MediaType.Data ? _dataChannelConstraints : {});

      await session.peerConnection!.setLocalDescription(sessionDescription);
      RTCSignalingInfo answer = RTCSignalingInfo(
          _user.id,
          sessionDescription.sdp ?? '',
          sessionDescription.type ?? '',
          type.rawValue,
          session.sessionId);
      await _firebaseStorage.sendAnswerTo(session.remoteUserId, answer);
    } catch (e) {
      print(e.toString());
      throw CreateAnswerError();
    }
  }


}
