import 'package:chat_app/app/chat/chat_screen.dart';
import 'package:chat_app/app/onboarding/onboarding_screen.dart';
import 'package:chat_app/app/onboarding/onboarding_view_model.dart';
import 'package:chat_app/routing/app_router.dart';
import 'package:chat_app/routing/custom_route.dart';
import 'package:chat_app/services/shared_preference_services.dart';
import 'package:chat_app/services/top_level_provider.dart';
import 'package:chat_app/widgets/auth/auth_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/authentication/auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    child: MyApp(),
    overrides: [
      sharedPreferencesServiceProvider
          .overrideWithValue(SharedPreferencesService(sharedPreferences))
    ],
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseAuth = context.read(firebaseAuthProvider);
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink,
          accentColor: Colors.deepPurple,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                  textStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)))),
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder()
          })),
      debugShowCheckedModeBanner: false,
      home: AuthWidget(
        nonSignedInBuilder: (_) => Consumer(builder: (context, watch, child) {
          final didCompleteOnboarding = watch(onboardingViewModelProvider);
          return didCompleteOnboarding ? AuthScreen() : OnboardingView();
        }),
        signedInBuilder: (_) => ChatScreen(),
      ),
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(settings, firebaseAuth),
    );
  }
}

/*
class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong!!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Flutter Chat',
              theme: ThemeData(
                  primarySwatch: Colors.pink,
                  backgroundColor: Colors.pink,
                  accentColor: Colors.deepPurple,
                  accentColorBrightness: Brightness.dark,
                  buttonTheme: ButtonTheme.of(context).copyWith(
                      buttonColor: Colors.pink,
                      textTheme: ButtonTextTheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.pink,
                          textStyle: TextStyle(color: Colors.white),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)))),
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder()
                  })),
              home: AuthScreen(),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
*/