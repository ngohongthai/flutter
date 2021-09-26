import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rtc/constant.dart';
import 'package:flutter_rtc/models/models.dart';

class UserNotFound implements Exception {}

class FirebaseStorage {
  final userCollection =
      FirebaseFirestore.instance.collection(FirebaseKey.users);

  Future<bool> _isUserExists(String userId) async {
    return await userCollection.doc(userId).get().then((value) => value.exists);
  }

  Future<void> register(User user) async {
    await _isUserExists(user.id).then((bool isExits) async {
      if (!isExits) {
        await userCollection.doc(user.id).set({
          FirebaseKey.userInfo: user.toJson(),
        });
      }
    });
  }

  Future<void> sendOfferTo(String toUserId, RTCSignalingInfo offer) async {
    await _isUserExists(toUserId).then((bool isExits) async {
      if (isExits) {
        await userCollection
            .doc(toUserId)
            .collection(FirebaseKey.offers)
            .add(offer.toJson());
      } else {
        throw UserNotFound();
      }
    });
  }

  Future<void> sendAnswerTo(String toUserId, RTCSignalingInfo answer) async {
    await _isUserExists(toUserId).then((bool isExits) async {
      if (isExits) {
        await userCollection
            .doc(toUserId)
            .collection(FirebaseKey.answers)
            .add(answer.toJson());
      } else {
        throw UserNotFound();
      }
    });
  }

  Future<void> updateCandidate(String userId, IceCandidate candidate) async {
    await _isUserExists(userId).then((bool isExits) async {
      if (isExits) {
        await userCollection
            .doc(userId)
            .collection(FirebaseKey.candidates)
            .add(candidate.toJson());
      } else {
        throw UserNotFound();
      }
    });
  }

  Future<List<IceCandidate>> getIceCandidateFrom(String userId) async {
    return userCollection
        .doc(userId)
        .collection(FirebaseKey.candidates)
        .get()
        .then((documentSnapshot) => documentSnapshot.docs
            .map((data) => IceCandidate.fromDocumentSnapshot(data))
            .toList());
  }

  Stream<QuerySnapshot> onAddedCandidate(String calleeId) {
    return userCollection
        .doc(calleeId)
        .collection(FirebaseKey.candidates)
        .snapshots();
  }

  Stream<QuerySnapshot> onAddedOffer(String userId) {
    return userCollection
        .doc(userId)
        .collection(FirebaseKey.offers)
        .snapshots();
  }

  Stream<QuerySnapshot> onAddedAnswer(String userId) {
    return userCollection
        .doc(userId)
        .collection(FirebaseKey.answers)
        .snapshots();
  }
}
