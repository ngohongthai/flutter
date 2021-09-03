import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/app/app.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  final authenticationRepository = AuthenticationRepository();
  await Firebase.initializeApp();
  await authenticationRepository.user.first;
  runApp(App(authenticationRepository: authenticationRepository));
}
