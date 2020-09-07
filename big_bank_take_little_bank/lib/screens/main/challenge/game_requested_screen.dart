import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/widgets/animated_button.dart';
import 'package:big_bank_take_little_bank/widgets/app_button.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flip_panel/flip_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameRequestedScreen extends StatelessWidget {
  final UserModel userModel;
  final ChallengeModel challengeModel;
  final Function onProfile;
  final Function onAccept;
  final Function onDecline;
  GameRequestedScreen({
    this.userModel,
    this.challengeModel,
    this.onProfile,
    this.onAccept,
    this.onDecline,
  });

  Widget build(BuildContext context) {

    DateTime dateTime = challengeModel.challengeTime;
    print(dateTime);
    Duration duration = DateTime.now().difference(dateTime);
    print(duration);
    int seconds = (duration.inSeconds - 60).abs();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 80),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF5c9c85),
                            Color(0xFF35777e),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            spreadRadius: 1.0,
                            offset: Offset(
                              4.0,
                              4.0,
                            ),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        left: 12,
                        top: 14,
                        bottom: 24,
                        right: 12,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF0e3d48),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.only(
                                top: 44,
                                bottom: 8,
                              ),
                              child: AppButtonLabel(
                                title: 'GAME REQUESTED',
                                shadow: true,
                                fontSize: 32,
                                align: TextAlign.center,
                                shadowColor: Color.fromRGBO(0, 0, 0, 0.58),
                              ),
                            ),
                            SizedBox(height: 12,),
                            Center(
                              child: SizedBox(
                                height: 64.0,
                                child: FlipClock.countdown(
                                  duration: Duration(seconds: seconds),
                                  digitColor: Color(0xfff49926),
                                  backgroundColor: Colors.transparent,
                                  digitSize: 48.0,
                                  borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                  onDone: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 12,),
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.28),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.only(
                                left: 36,
                                right: 36,
                                top: 16,
                                bottom: 16,
                              ),
                              child: Column(
                                children: [
                                  AnimatedButton(
                                    onTap: onProfile,
                                    content: AppButton(
                                      height: 72,
                                      colorStyle: 'sky',
                                      titleWidget: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Center(
                                              child: Image.asset('assets/images/setting_pig.png', height: 44,),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: AppButtonLabel(
                                              title: 'VIEW\nPROFILE',
                                              shadow: true,
                                              fontSize: 24,
                                              align: TextAlign.center,
                                              shadowColor: Color.fromRGBO(0, 0, 0, 0.58),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16,),
                                  AnimatedButton(
                                    onTap: onAccept,
                                    content: AppButton(
                                      height: 72,
                                      colorStyle: 'green',
                                      titleWidget: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Center(
                                              child: Image.asset('assets/images/ic_checkmark.png', height: 44,),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: AppButtonLabel(
                                              title: 'ACCEPT',
                                              shadow: true,
                                              fontSize: 24,
                                              align: TextAlign.center,
                                              shadowColor: Color.fromRGBO(0, 0, 0, 0.58),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16,),
                                  AnimatedButton(
                                    onTap: onDecline,
                                    content: AppButton(
                                      height: 72,
                                      colorStyle: 'orange',
                                      titleWidget: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Center(
                                              child: Image.asset('assets/images/ic_close_outline.png', height: 44,),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: AppButtonLabel(
                                              title: 'DECLINE',
                                              shadow: true,
                                              fontSize: 24,
                                              align: TextAlign.center,
                                              shadowColor: Color.fromRGBO(0, 0, 0, 0.58),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 32,
                      child: Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFF124652),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              spreadRadius: 1.0,
                              offset: Offset(
                                2.0,
                                4.0,
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.only(
                          left: 6,
                          top: 6,
                          bottom: 6,
                          right: 6,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                              ),
                              BoxShadow(
                                color: Color(0xFF124652),
                                spreadRadius: -8.0,
                                blurRadius: 12.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        child: Column(
                          children: [
                            ProfileAvatar(
                              image: userModel.image ?? '',
                              avatarSize: 80,
                            ),
                            AppLabel(
                              title: userModel.name ?? '',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: MaterialButton(
                        child: Icon(Icons.close),
                        shape: CircleBorder(),
                        minWidth: 0,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 16,
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 120,
                      child: Image.asset('assets/images/level_1_user_profile.png'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}