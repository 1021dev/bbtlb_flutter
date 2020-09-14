import 'package:big_bank_take_little_bank/models/notification_model.dart';
import 'package:big_bank_take_little_bank/widgets/title_background_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LiveChallengeFinishedCell extends StatelessWidget {
  final NotificationModel notificationModel;
  final Function onTap;
  LiveChallengeFinishedCell({
    this.notificationModel,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    double avatarSize = MediaQuery.of(context).size.width * 0.12;
    // double height = width * 0.7;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Container(
          padding: EdgeInsets.only(
            left: 4,
            top: 4,
            bottom: 4,
            right: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfileAvatar(
                      avatarSize: avatarSize,
                      image: notificationModel.senderPhoto ?? '',
                    ),
                    Expanded(
                      child: Center(
                        child: AppLabel(
                          title: notificationModel.senderName ?? '',
                          shadowColor: Colors.black,
                          shadow: true,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 36,
                child: Image.asset('assets/images/ic_vs_small.png'),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: AppLabel(
                          title: notificationModel.senderName ?? '',
                          shadowColor: Colors.black,
                          shadow: true,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    ProfileAvatar(
                      avatarSize: avatarSize,
                      image: notificationModel.senderPhoto ?? '',
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