import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppRoutes {
  static const authPae = '/auth';
  static const chatPage = '/chat';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(
      RouteSettings settings, FirebaseAuth firebaseAuth) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.authPae:
        return MaterialPageRoute<dynamic>(
            builder: (_) => AuthScreen(),
            settings: settings,
            fullscreenDialog: true);
      case AppRoutes.chatPage:
        return MaterialPageRoute<dynamic>(
            builder: (_) => ChatScreen(),
            settings: settings,
            fullscreenDialog: true);
      default:
        // TODO: Throw error
        return null;
    }
  }
}
