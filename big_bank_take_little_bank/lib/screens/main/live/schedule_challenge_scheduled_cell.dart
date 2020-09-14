import 'package:big_bank_take_little_bank/models/notification_model.dart';
import 'package:big_bank_take_little_bank/widgets/title_background_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ScheduleChallengeScheduledCell extends StatelessWidget {
  final NotificationModel notificationModel;
  final Function onTap;
  ScheduleChallengeScheduledCell({
    this.notificationModel,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    double avatarSize = MediaQuery.of(context).size.width * 0.22;
    double width = MediaQuery.of(context).size.width - 64;
    double height = width * 0.7;
    return GestureDetector(
      onTap: onTap,
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
                        image: notificationModel.senderPhoto ?? '',
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
                            title: notificationModel.senderName ?? '',
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
                        image: notificationModel.senderPhoto ?? '',
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
                            title: notificationModel.senderName ?? '',
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
                title: '04:00',
                height: 44,
                isShadow: true,
                padding: EdgeInsets.only(left: 16, right: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}