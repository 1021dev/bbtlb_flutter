import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/login/login_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/main_screen.dart';
import 'package:big_bank_take_little_bank/widgets/animated_button.dart';
import 'package:big_bank_take_little_bank/widgets/make_circle.dart';
import 'package:big_bank_take_little_bank/widgets/shake_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  AnimationController logoController;
  AnimationController detailController;
  AnimationController buttonController;
  AnimationController ringsController;
  Animation<double> logoScale;
  Animation<double> logoRotation;
  Animation<double> ringTransition;
  Animation<double> buttonTransition;
  bool _isVisible = false;
  bool isShake = false;

  @override
  void initState() {
    super.initState();
    logoController =
        AnimationController(duration: Duration(milliseconds: 3000), vsync: this);
    detailController =
        AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    buttonController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    ringsController = new AnimationController(vsync: this);
    logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isVisible = true;
        });
        detailController.forward();
      }
    });
    detailController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isShake = true;
        });
        buttonController.forward();
      }
    });
    buttonController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isShake = false;
        });
      }
    });

    logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: logoController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    logoRotation = Tween<double>(
      begin: 0.0,
      end: -4 * pi,
    ).animate(
      CurvedAnimation(
        parent: logoController,
        curve: Interval(
          0.0, 1.0,
          curve: Curves.decelerate,
        ),
      ),
    );
    ringTransition = Tween<double>(
      begin: 0.0,
      end: -2 * pi,
    ).animate(
      CurvedAnimation(
        parent: ringsController,
        curve: Curves.linear,
      ),
    );
    buttonTransition = Tween<double>(
      begin: 200.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: detailController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    checkAuth();
  }

  void setAnimation() {
    logoController.forward();
    ringsController.repeat(
      period: Duration(seconds: 2),
    );
  }

  void checkAuth() {
   // await auth.signOut();
    User currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Global.instance.userId = currentUser.uid;
    }
    print(currentUser);
    if (currentUser != null) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: MainScreen(),
          type: PageTransitionType.fade,
          duration: Duration(microseconds: 0),
        ),
      );
    } else {
      setAnimation();
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    logoController.dispose();
    detailController.dispose();
    buttonController.dispose();
    ringsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appleSignInAvailable = Provider.of<AppleSignInAvailable>(context, listen: false);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        overflow: Overflow.visible,
        children: [
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
          AnimatedBuilder(
            animation: ringsController,
            builder: (context, builder) {
              return Transform(
                transform: Matrix4.identity()..translate(
                  30.0 * cos(ringTransition.value),
                  30.0 * sin(ringTransition.value),
                ),
                child: Container(
                  // width: MediaQuery.of(context).size.height * 1.2,
                  // height: MediaQuery.of(context).size.height * 1.2,
                  decoration: MakeCircle(
                    animation: ringTransition,
                    strokeWidth: 36,
                    strokeCap: StrokeCap.square,
                  ),
                  // child: Image.asset('assets/images/rings.png', fit: BoxFit.cover,),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: logoController,
            builder: (context, builder) {
              return Transform(
                transform: Matrix4.identity()..rotateZ(
                  logoRotation.value,
                )..scale(logoScale.value)..translate(
                  0.0,
                  -MediaQuery.of(context).size.height * 1 / 10,
                ),
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                  child: Image.asset('assets/images/logo.png', fit: BoxFit.fill,),
                ),
              );
            },
          ),
          AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: _isVisible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            // The green box must be a child of the AnimatedOpacity widget.
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              transform: Matrix4.identity()..translate(
                0.0,
                MediaQuery.of(context).size.height * 3 / 10,
              ),
              child: Image.asset('assets/images/txt_splash_detail.png', fit: BoxFit.fill,),
            ),
          ),
          AnimatedBuilder(
            animation: detailController,
            builder: (context, builder) {
              return Transform(
                transform: Matrix4.identity()..translate(
                  0.0,
                  buttonTransition.value,
                ),
                alignment: Alignment.center,
                child: Container(
                  transform: Matrix4.identity()..translate(
                    0.0,
                    MediaQuery.of(context).size.height * 2 / 5,
                  ),
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: AnimatedButton(
                    content: ShakeAnimatedWidget(
                      enabled: isShake,
                      duration: Duration(milliseconds: 100),
                      shakeAngle: Rotation.deg(z: 5),
                      curve: Curves.easeOutQuad,
                      child:  Image.asset('assets/images/btn_get_start.png', fit: BoxFit.contain,),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          child: LoginScreen(appleSignInAvailable: appleSignInAvailable,),
                          type: PageTransitionType.fade,
                          duration: Duration(microseconds: 0),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
