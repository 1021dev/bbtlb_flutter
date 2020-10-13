import 'dart:async';

import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/login/login_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/main_screen.dart';
import 'package:big_bank_take_little_bank/widgets/make_circle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(milliseconds: 3000),
        () {
          checkAuth();
        }
    );
  }

  void checkAuth() async {
   // await auth.signOut();
    User currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Global.instance.userId = currentUser.uid;
    }
    print(currentUser);
    await Navigator.pushReplacement(
      context,
      PageTransition(
        child: currentUser != null ? MainScreen(): LoginScreen(),
        type: PageTransitionType.fade,
        duration: Duration(microseconds: 0),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Container(
          width: MediaQuery.of(context).size.height,
          height: MediaQuery.of(context).size.height,
          decoration: MakeCircle(
            strokeWidth: 44,
            strokeCap: StrokeCap.square,
          ),
          child: Image.asset('assets/images/splash.png', fit: BoxFit.fill,),
        ),
      ),
    );
  }
}
