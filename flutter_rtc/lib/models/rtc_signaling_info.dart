import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rtc/constant.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum MediaType { Data, Video }

extension MediaTypeExtension on MediaType {
  String get rawValue {
    switch (this) {
      case MediaType.Data:
        return 'data';
      case MediaType.Video:
        return 'video';
    }
  }
}

class RTCSignalingInfo {
  final String _fromUserId;
  final String _sdp;
  final String _type;
  final String _mediaType;
  final String _sessionId;

  RTCSignalingInfo(this._fromUserId, this._sdp, this._type, this._mediaType,
      this._sessionId);

  MediaType get mediaType =>
      _mediaType == "data" ? MediaType.Data : MediaType.Video;

  String get fromUserId => _fromUserId;

  String get sdp => _sdp;

  String get type => _type;

  String get sessionId => _sessionId;

  RTCSessionDescription get rtcDescription =>
      RTCSessionDescription(_sdp, _type);

  factory RTCSignalingInfo.fromMap(Map<String, dynamic> data) {
    return RTCSignalingInfo(data[MapKey.fromUserId], data[MapKey.sdp],
        data[MapKey.type], data[MapKey.mediaType], data[MapKey.sessionId]);
  }

  factory RTCSignalingInfo.fromDocumentSnapshot(DocumentSnapshot data) {
    return RTCSignalingInfo(data[MapKey.fromUserId], data[MapKey.sdp],
        data[MapKey.type], data[MapKey.mediaType], data[MapKey.sessionId]);
  }

  Map<String, dynamic> toJson() {
    return {
      MapKey.fromUserId: this._fromUserId,
      MapKey.sdp: this._sdp,
      MapKey.type: this._type,
      MapKey.mediaType: this._mediaType,
      MapKey.sessionId: this._sessionId,
    };
  }

  @override
  String toString() {
    return 'RTCSignalingInfo{_fromUserId: $_fromUserId, _sdp: $_sdp, _type: $_type, _mediaType: $_mediaType, _sessionId: $_sessionId}';
  }
}
