import 'dart:io';
import 'dart:ui' as ui;
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/provider/store/store.dart';
import 'package:big_bank_take_little_bank/screens/splash/splash_screen.dart';
import 'package:big_bank_take_little_bank/utils/notification_handle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

Future<void> myMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DefaultStore.instance.init();
  Firebase.initializeApp();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//  final mainBloc = MainBloc.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  BuildContext contextNo;

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: contextNo,
      builder: (_) => _buildDialog(contextNo, itemForMessage(message)),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final Item item = itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(contextNo, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(contextNo, item.route);
    }
  }

  Widget _buildDialog(BuildContext context, Item item) {
    return AlertDialog(
      content: Text("${item.matchteam} with score: ${item.score}"),
      actions: <Widget>[
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
      Global.instance.setToken(token);
    });
    _firebaseMessaging.subscribeToTopic("matchscore");
  }

  @override
  Widget build(BuildContext context) {
    contextNo = context;
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

class AppContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SplashScreen(),
          SpinKitDoubleBounce(
            color: Colors.red,
            size: 50.0,
          ),
        ],
      ),
    );
  }

  // After widget initialized.
  void onAfterBuild(BuildContext context) {
  }
}
