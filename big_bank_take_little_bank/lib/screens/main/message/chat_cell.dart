import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/chat_model.dart';
import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatCell extends StatelessWidget {
  final ChatModel chatModel;
  final Function onTap;
  final Function onDelete;
  final SlidableController controller;
  ChatCell({
    this.chatModel,
    this.onTap,
    this.onDelete,
    this.controller,
  });
  @override
  Widget build(BuildContext context) {
    double avatarSize = MediaQuery.of(context).size.width * 0.22;
    String userId = chatModel.members[0] == Global.instance.userId ? chatModel.members[1]: chatModel.members[0];
    DateTime ttime = chatModel.createdAt;
    String minute = ttime.minute > 9
        ? ttime.minute.toString()
        : '0' + ttime.minute.toString();
    String ampm = ttime.hour >= 12 ? "PM" : "AM";
    int hour = ttime.hour >= 12 ? ttime.hour % 12 : ttime.hour;
    return FutureBuilder(
      future: FirestoreService().getUserWithId(userId),
      builder: (context, snap) {
        return Slidable(
          key: Key(chatModel.id),
          controller: controller,
          direction: Axis.horizontal,
          actionPane: SlidableBehindActionPane(),
          actionExtentRatio: 0.25,
          child: GestureDetector(
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
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ProfileAvatar(
                            avatarSize: 50,
                            image: snap.hasData ? snap.data.image ?? '': '',
                          ),
                          Container(
                            width: 16,
                            height: 16,
                            alignment: Alignment.bottomRight,
                            decoration: BoxDecoration(
                                color: snap.hasData ? (snap.data.isOnline ? Colors.green: Colors.grey) : Colors.grey,
                                border: Border.all(
                                  color: Color(0xFF1b5c6b),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                        ],
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
                                  title: snap.hasData ? snap.data.name ?? '': '',
                                  fontSize: 16,
                                  maxLine: 2,
                                  shadow: true,
                                ),
                                AppLabel(
                                  title: hour.toString() + ":" + minute.toString() + " " + ampm,
                                  fontSize: 10,
                                  shadow: false,
                                ),
                              ],
                            ),
                            AppLabel(
                              title: chatModel.lastMessage != null ? chatModel.lastMessage.message: '',
                              fontSize: 14,
                              shadow: false,
                              maxLine: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
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
      },
    );
  }
}