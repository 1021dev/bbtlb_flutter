
import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:flip_panel/flip_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChallengePendingDialog extends StatelessWidget {
  final ChallengeModel challengeModel;
  final Function onChallenge;
  final Function onSchedule;
  final Function onLive;

  ChallengePendingDialog({
    this.challengeModel,
    this.onChallenge,
    this.onSchedule,
    this.onLive,
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
                              child: Align(
                                child: AppGradientLabel(
                                  title: 'CHALLENGE PENDING',
                                  shadow: true,
                                  fontSize: 28,
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
                                left: 16,
                                right: 16,
                                top: 16,
                                bottom: 16,
                              ),
                              child: Container(
                                child: Column(
                                  children: [
                                    AppButtonLabel(
                                      title: 'A CHALLENGE IS \nCURRENTLY PENDING, \nPLEASE TRY AGAIN LATER',
                                      align: TextAlign.center,
                                      fontSize: 22,
                                      shadow: true,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Center(
                                      child: FlipClock.countdown(
                                        duration: Duration(seconds: seconds),
                                        digitColor: Color(0xfff49926),
                                        backgroundColor: Colors.transparent,
                                        digitSize: 48.0,
                                        spacing: EdgeInsets.all(0),
                                        flipDirection: FlipDirection.down,
                                        onDone: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    AppGradientLabel(
                                      title: 'SECONDS',
                                      shadow: true,
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
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
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 120,
                      child: Image.asset('assets/images/ic_pending.png'),
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