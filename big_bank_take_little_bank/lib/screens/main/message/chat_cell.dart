import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatCell extends StatelessWidget {
  final MessageModel messageModel;
  final Function onTap;
  final Function onDelete;
  final SlidableController controller;
  ChatCell({
    this.messageModel,
    this.onTap,
    this.onDelete,
    this.controller,
  });
  @override
  Widget build(BuildContext context) {
    double avatarSize = MediaQuery.of(context).size.width * 0.22;
    return Slidable(
      key: Key(messageModel.id),
      controller: controller,
      direction: Axis.horizontal,
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      child:  GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 8),
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
            left: 6,
            top: 6,
            bottom: 12,
            right: 12,
          ),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Color(0xFF0e3d48),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  ProfileAvatar(
                    avatarSize: 50,
                    image: messageModel.user.userImage ?? '',
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppLabel(
                              title: messageModel.user.userName ?? '',
                              fontSize: 16,
                              maxLine: 2,
                              shadow: true,
                            ),
                            AppLabel(
                              title: timeago.format(messageModel.createdAt),
                              fontSize: 10,
                              shadow: false,
                            ),
                          ],
                        ),
                        AppLabel(
                          title: messageModel.message ?? '',
                          fontSize: 14,
                          shadow: false,
                          maxLine: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ) ,
          ),
        ),
      ),
      secondaryActions: <Widget>[
        SlideAction(
          color: Colors.transparent,
          child: Image.asset('assets/images/ic_delete_notification.png'),
          onTap: () {
            print('delete');
            onDelete();
          },
        ),
      ],
    );
  }
}