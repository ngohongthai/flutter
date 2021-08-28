import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthenViewModel with ChangeNotifier {
  final FirebaseAuth auth;
  bool isLoading = false;
  dynamic error

}
