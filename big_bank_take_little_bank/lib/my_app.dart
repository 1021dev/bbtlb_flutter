import 'dart:async';
import 'dart:ui' as ui;
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/main/main_screen.dart';
import 'package:big_bank_take_little_bank/screens/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await AppleSignIn.isAvailable());
  }
}

Future<void> myMain() async {
  // await DefaultStore.instance.init();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  await FirebaseCrashlytics.instance.checkForUnsentReports();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  final appleSignInAvailable = await AppleSignInAvailable.check();
  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        var data = MediaQuery.of(context);
        var textScaleFactor = data.textScaleFactor;
        if (textScaleFactor > 1.25) {
          textScaleFactor = 1.25;
          data = data.copyWith(textScaleFactor: textScaleFactor);
        }
        if (textScaleFactor < 0.9) {
          textScaleFactor = 0.9;
          data = data.copyWith(textScaleFactor: textScaleFactor);
        }
        return MediaQuery(
          child: child,
          data: data,
        );
      },
      locale: Locale(ui.window.locale?.languageCode ?? ' en'),
      supportedLocales: [
        const Locale('en'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.yellow,
        primaryColor: Colors.white,
        accentColor: Color(0xFF0E3D47),
          fontFamily: 'Lucky',
        backgroundColor: Color(0xFF0E3D47),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, fontFamily: 'BackToSchool'),
          headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal, fontFamily: 'BackToSchool'),
          headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, fontFamily: 'BackToSchool'),
          headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, fontFamily: 'BackToSchool'),
          headline5: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, fontFamily: 'BackToSchool'),
          headline6: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, fontFamily: 'BackToSchool'),
          button: TextStyle(fontSize: 20.0, fontFamily: 'Lucky'),
          bodyText1: TextStyle(fontSize: 20.0, fontFamily: 'Lucky'),
          bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'Lucky'),
        )
      ),
      home: AppContent(),
    );
  }
}

class AppContent extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AppContentState();
  }
}

class AppContentState extends State<AppContent> {

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(milliseconds: 1000),
        () {
          checkAuth();
        }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkAuth() async {
    // await FirebaseAuth.instance.signOut();
    User currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Global.instance.userId = currentUser.uid;
    }
    print(currentUser);
    Navigator.pushReplacement(
      context,
      PageTransition(
        child: currentUser != null ? MainScreen(): SplashScreen(),
        type: PageTransitionType.fade,
        duration: Duration(microseconds: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.height,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff0e5073),
                  Color(0xff35996a),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SpinKitDoubleBounce(
            color: Colors.red,
            size: 50.0,
          ),
        ],
      ),
    );
  }
}
