import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/widgets/animated_button.dart';
import 'package:big_bank_take_little_bank/widgets/app_button.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseChallengeScreen extends StatelessWidget {
  final UserModel userModel;
  final Function onChallenge;
  final Function onSchedule;
  final Function onLive;
  ChooseChallengeScreen({
    this.userModel,
    this.onChallenge,
    this.onSchedule,
    this.onLive,
  });

  Widget build(BuildContext context) {
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
                                title: 'CHOOSE CHALLENGE',
                                shadow: true,
                                fontSize: 32,
                                align: TextAlign.center,
                                shadowColor: Color.fromRGBO(0, 0, 0, 0.58),
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
                                    onTap: onChallenge,
                                    content: AppButton(
                                      height: 72,
                                      colorStyle: 'yellow',
                                      titleWidget: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Center(
                                              child: Image.asset('assets/images/ic_scheduled_stats.png', height: 44,),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: AppButtonLabel(
                                              title: 'CHALLENGE\nNOW',
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
                                    onTap: onSchedule,
                                    content: AppButton(
                                      height: 72,
                                      colorStyle: 'orange',
                                      titleWidget: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Center(
                                              child: Image.asset('assets/images/ic_timer.png', height: 44,),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: AppButtonLabel(
                                              title: 'SCHEDULE',
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
                                    onTap: onLive,
                                    content: AppButton(
                                      height: 72,
                                      colorStyle: 'sky',
                                      titleWidget: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Center(
                                              child: Image.asset('assets/images/ic_live.png', height: 44,),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: AppButtonLabel(
                                              title: 'LIVE',
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