import 'package:chat_app/services/firestore_services.dart';

class FirestoreDatabase {
  final String uid;

  FirestoreDatabase({required this.uid});

  final _service = FirestoreService.instance;
}
