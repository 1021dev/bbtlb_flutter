import 'package:big_bank_take_little_bank/models/notification_model.dart';
import 'package:big_bank_take_little_bank/widgets/app_button.dart';
import 'package:big_bank_take_little_bank/widgets/title_background_widget.dart';
import 'package:date_format/date_format.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ScheduleChallengeRequestCell extends StatelessWidget {
  final NotificationModel notificationModel;
  final Function onTap;
  ScheduleChallengeRequestCell({
    this.notificationModel,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    double avatarSize = MediaQuery.of(context).size.width * 0.15;
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
              ProfileAvatar(
                avatarSize: avatarSize,
                image: notificationModel.senderPhoto ?? '',
              ),
              SizedBox(width: 8,),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppLabel(
                      title: notificationModel.senderName ?? '',
                      shadowColor: Colors.black,
                      shadow: true,
                      fontSize: 18,
                    ),
                    AppLabel(
                      title: formatDate(notificationModel.createdAt, [hh, ':', nn, am, ' ', Z]),
                      maxLine: 2,
                      shadowColor: Colors.black,
                      shadow: true,
                      fontSize: 14,
                      color: Color(0xff56a7a4),
                    ),
                    AppLabel(
                      title: formatDate(notificationModel.createdAt, [M, ' ', d, ' ', yyyy]),
                      maxLine: 2,
                      shadowColor: Colors.black,
                      shadow: true,
                      fontSize: 14,
                      color: Color(0xff56a7a4),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: AppButton(
                      height: 40,
                      colorStyle: 'green',
                      titleWidget: Padding(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: Image.asset('assets/images/ic_check_outline.png', width: 24, height: 24,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: AppButton(
                      height: 40,
                      colorStyle: 'red',
                      titleWidget: Padding(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: Image.asset('assets/images/ic_close_outline.png', width: 24, height: 24,),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}