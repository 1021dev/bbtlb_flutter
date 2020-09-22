import 'dart:async';

import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/widgets/title_background_widget.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class ScheduleChallengeScheduledCell extends StatefulWidget {
  final ChallengeModel challengeModel;
  final Function onTap;

  ScheduleChallengeScheduledCell({
    this.challengeModel,
    this.onTap,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ScheduleChallengeScheduledCellState();
  }

}

class _ScheduleChallengeScheduledCellState extends State<ScheduleChallengeScheduledCell> {

  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = new Timer.periodic(new Duration(microseconds: 500), (Timer t) {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double avatarSize = MediaQuery.of(context).size.width * 0.22;
    double width = MediaQuery.of(context).size.width - 64;
    double height = width * 0.7;
    String otherUserId = '';
    if (widget.challengeModel.sender == Global.instance.userId) {
      otherUserId = widget.challengeModel.receiver;
    } else {
      otherUserId = widget.challengeModel.sender;
    }
    return FutureBuilder(
      future: FirestoreService().getUserWithId(otherUserId),
      builder: (ctx, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        UserModel sender;
        UserModel receiver;
        if (widget.challengeModel.sender == Global.instance.userId) {
          sender = Global.instance.userModel;
          receiver = snapshot.data;
        } else {
          sender = snapshot.data;
          receiver = Global.instance.userModel;
        }
        int remain = (widget.challengeModel.challengeTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch) ~/ 1000;
        int h = remain ~/ 60;
        int m = remain % 60;
        if (remain < 0) {
          h = 0;
          m = 0;
        }
        return GestureDetector(
          onTap: () {
            if (widget.challengeModel.sender == Global.instance.userId) {
              widget.onTap(receiver);
            } else {
              widget.onTap(sender);
            }
          },
          child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Transform.rotate(
                  angle: -0.05,
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 24),
                    decoration: BoxDecoration(
                      color: Color(0xFF0b353f),
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF194f5c),
                        Color(0xFF498f8b),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.only(
                    left: 6,
                    top: 6,
                    bottom: 12,
                    right: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProfileAvatar(
                            avatarSize: width * 0.3,
                            image: sender.image ?? '',
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: width * 0.28,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFF1a3c44),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(5, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: AppLabel(
                                title: sender.name ?? '',
                                shadowColor: Colors.black,
                                shadow: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProfileAvatar(
                            avatarSize: width * 0.3,
                            image: receiver.image ?? '',
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: width * 0.28,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFF1a3c44),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(5, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: AppLabel(
                                title: receiver.name ?? '',
                                shadowColor: Colors.black,
                                shadow: true,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  child: Image.asset('assets/images/ic_live_vs.png'),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: TitleBackgroundWidget(
                    title: sprintf('%02d:%02d', [h, m]),
                    height: 44,
                    isShadow: true,
                    padding: EdgeInsets.only(left: 16, right: 24),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}