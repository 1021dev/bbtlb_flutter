import 'package:big_bank_take_little_bank/models/friends_model.dart';
import 'package:big_bank_take_little_bank/widgets/app_button.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendsRequestCell extends StatelessWidget {
  final FriendsGroupModel groupModel;
  final Function onAccept;
  final Function onDecline;
  final Function onTap;
  FriendsRequestCell({
    this.groupModel,
    this.onTap,
    this.onAccept,
    this.onDecline,
  });
  @override
  Widget build(BuildContext context) {
    double avatarSize = MediaQuery.of(context).size.width * 0.22;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 16),
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
                bottom: 24,
                right: 24,
              ),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFF0e3d48),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      ProfileAvatar(
                        image: groupModel.friendsModel.image,
                      ),
                      SizedBox(width: 16,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLabel(
                            title: groupModel.friendsModel.name,
                            fontSize: 24,
                            shadow: true,
                          ),
                          AppLabel(
                            title: 'sent you a friend request',
                            fontSize: 14,
                            color: Color(0xFFa0d9c5),
                            shadow: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 3,
              right: 24,
              bottom: 0,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: MaterialButton(
                        onPressed: onAccept,
                        minWidth: 0,
                        padding: EdgeInsets.zero,
                        child: AppButton(
                          image: Image.asset('assets/images/ic_check_outline.png'),
                          colorStyle: 'green',
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    Flexible(
                      child: MaterialButton(
                        onPressed: onDecline,
                        minWidth: 0,
                        padding: EdgeInsets.zero,
                        child: AppButton(
                          image: Image.asset('assets/images/ic_close_outline.png'),
                          colorStyle: 'orange',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}