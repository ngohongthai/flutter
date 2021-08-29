import 'package:chat_app/config/constant.dart';
import 'package:chat_app/cubit/language/cubit/language_cubit.dart';
import 'package:chat_app/features/multi_language/app_localizations.dart';
import 'package:chat_app/features/multi_language/initial_language.dart';
import 'package:chat_app/ui/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

main() {
  LicenseRegistry.addLicense(() async* {
    final googleFontLicense =
        await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(
        ['assets/google_fonts'], googleFontLicense);
  });
  // this function makes application always run in portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    _initializeFirebase();
    runApp(MyApp());
  });
}

void _initializeFirebase() async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          // this bloc used for feature - change language
          BlocProvider(create: (context) => LanguageCubit()),
        ],
        child: InitialLanguage(child: BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, state) {
            return MaterialApp(
              title: APP_NAME,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  })),
              // below is used for language feature
              supportedLocales: [Locale('en', 'US'), Locale('vi', 'VN')],
              // These delegates make sure that the localization data for the proper language is loaded
              localizationsDelegates: [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              // Returns a locale which will be used by the app
              locale: (state is ChangeLanguageSuccess)
                  ? state.locale
                  : Locale('en', 'US'),
              home: SplashScreen(),
            );
          },
        )));
  }
}
