import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/screens/login/login_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  BuildContext contextNo;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500)).then((value) {
      checkAuth(context);
    });
  }

  void checkAuth(BuildContext context) async {
    final currentUser = await auth.currentUser();
//    if (currentUser != null) {
//      await auth.signOut();
//    }
    // mainBloc.navigateReplace(currentUser != null ? SignUpProfileScreen() : WelcomeScreen());
    print('login screen');
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => currentUser != null ? MainScreen(): LoginScreen()));

  }

  @override
  Widget build(BuildContext context) {
    contextNo = context;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(0.0),
        child: Image.asset('assets/images/splash.png', fit: BoxFit.fill,),
      ),
    );
  }
}
