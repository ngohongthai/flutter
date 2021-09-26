import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../constant.dart';

class IceCandidate {
  final String sessionId;
  final String? sdpMid;
  final int? sdpMLineIndex;
  final String? candidate;

  IceCandidate(this.sessionId, this.sdpMid, this.sdpMLineIndex, this.candidate);

  Map<String, dynamic> toJson() {
    return {
      MapKey.sessionId: this.sessionId,
      MapKey.sdpMid: this.sdpMid,
      MapKey.sdpMLineIndex: this.sdpMLineIndex,
      MapKey.candidate: this.candidate
    };
  }

  factory IceCandidate.fromMap(Map<String, dynamic> data) {
    return IceCandidate(data[MapKey.sessionId], data[MapKey.sdpMid],
        data[MapKey.sdpMLineIndex], data[MapKey.candidate]);
  }

  factory IceCandidate.fromDocumentSnapshot(DocumentSnapshot data) {
    return IceCandidate(data[MapKey.sessionId], data[MapKey.sdpMid],
        data[MapKey.sdpMLineIndex], data[MapKey.candidate]);
  }

  RTCIceCandidate get iceCandidate => RTCIceCandidate(this.candidate, this.sdpMid, this.sdpMLineIndex);

  @override
  String toString() {
    return 'IceCandidate{sessionId: $sessionId, sdpMid: $sdpMid, sdpMLineIndex: $sdpMLineIndex, candidate: $candidate}';
  }
}
