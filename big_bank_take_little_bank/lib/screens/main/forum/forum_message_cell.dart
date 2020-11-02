import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/utils/crop_image.dart';
import 'package:big_bank_take_little_bank/widgets/image_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ForumMessageCell extends StatelessWidget {
  final MessageModel messageModel;
  final Function onTap;
  final Function onReply;
  final Function onDelete;
  final SlidableController controller;
  final bool isReply;
  ForumMessageCell({
    this.messageModel,
    this.onTap,
    this.onReply,
    this.onDelete,
    this.controller,
    this.isReply = false,
  });
  @override
  Widget build(BuildContext context) {
    double avatarSize = MediaQuery.of(context).size.width * 0.22;

    DateTime ttime = messageModel.createdAt;
    String minute = ttime.minute > 9
        ? ttime.minute.toString()
        : '0' + ttime.minute.toString();
    String ampm = ttime.hour >= 12 ? "PM" : "AM";
    int hour = ttime.hour >= 12 ? ttime.hour % 12 : ttime.hour;
    if (messageModel.user.userId == Global.instance.userId) {
      return Slidable(
        key: Key(messageModel.id),
        controller: controller,
        direction: Axis.horizontal,
        actionPane: SlidableBehindActionPane(),
        actionExtentRatio: 0.25,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(left: 64, right: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF913080),
                      Color(0xFFb346a1),
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
                  bottom: 6,
                  right: 6,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFa0478d),
                          Color(0xFF902f80),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomRight,
                      )
                  ),
                  child: messageModel.type == 'text'
                      ? Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder(
                              future: FirestoreService().getUserWithId(messageModel.user.userId),
                              builder: (context, snap) {
                                return AppLabel(
                                  title: 'You',
                                  fontSize: 18,
                                  shadow: true,
                                );
                              },
                            ),
                            AppLabel(
                              title: hour.toString() + ":" + minute.toString() + " " + ampm,
                              fontSize: 10,
                              shadow: false,
                            ),
                          ],
                        ),
                        AppLabel(
                          title: messageModel.message ?? '',
                          fontSize: 14,
                          maxLine: 100,
                          shadow: true,
                        ),
                        if (!isReply)  GestureDetector(
                          onTap: onReply,
                          child: Container(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: AppLabel(title: 'Reply', fontSize: 12,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FutureBuilder(
                                future: FirestoreService().getUserWithId(messageModel.user.userId),
                                builder: (context, snap) {
                                  return AppLabel(
                                    title: 'You',
                                    fontSize: 18,
                                    shadow: true,
                                  );
                                },
                              ),
                              AppLabel(
                                title: hour.toString() + ':' + minute.toString() + ' ' + ampm,
                                fontSize: 10,
                                shadow: false,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CropImage(
                            index: 0,
                            albumn: [messageModel.message ?? ''],
                            isVideo: false,
                            list: [messageModel.message ?? ''],
                          ),
                        ),
                        if (!isReply)  GestureDetector(
                          onTap: onReply,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: AppLabel(title: 'Reply', fontSize: 12,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 64),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF3e7c6a),
                Color(0xFF5a9a85),
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
            bottom: 6,
            right: 6,
          ),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5c9d86),
                    Color(0xFF35777e),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
            ),
            child: messageModel.type == 'text'
                ? Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                        future: FirestoreService().getUserWithId(messageModel.user.userId),
                        builder: (context, snap) {
                          return AppLabel(
                            title: snap.hasData ? snap.data.name ?? '': '',
                            fontSize: 18,
                            shadow: true,
                          );
                        },
                      ),
                      AppLabel(
                        title: hour.toString() + ":" + minute.toString() + " " + ampm,
                        fontSize: 10,
                        shadow: false,
                      ),
                    ],
                  ),
                  AppLabel(
                    title: messageModel.message ?? '',
                    fontSize: 14,
                    maxLine: 100,
                    shadow: true,
                  ),
                  if (!isReply)  GestureDetector(
                    onTap: onReply,
                    child: Container(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AppLabel(title: 'Reply', fontSize: 12,),
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder(
                          future: FirestoreService().getUserWithId(messageModel.user.userId),
                          builder: (context, snap) {
                            return AppLabel(
                              title: snap.hasData ? snap.data.name ?? '': '',
                              fontSize: 18,
                              shadow: true,
                            );
                          },
                        ),
                        AppLabel(
                          title: hour.toString() + ':' + minute.toString() + ' ' + ampm,
                          fontSize: 10,
                          shadow: false,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CropImage(
                      index: 0,
                      albumn: [messageModel.message ?? ''],
                      isVideo: false,
                      list: [messageModel.message ?? ''],
                    ),
                  ),
                  if (!isReply)  GestureDetector(
                    onTap: onReply,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: AppLabel(title: 'Reply', fontSize: 12,),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}