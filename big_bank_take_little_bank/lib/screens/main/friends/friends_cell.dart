import 'package:big_bank_take_little_bank/models/friends_model.dart';
import 'package:big_bank_take_little_bank/widgets/app_button.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendsCell extends StatelessWidget {
  final FriendsGroupModel groupModel;
  final Function onChat;
  final Function onChallenge;
  final Function onTap;
  FriendsCell({
    this.groupModel,
    this.onTap,
    this.onChat,
    this.onChallenge,
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
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: AppLabel(
                              title: groupModel.friendsModel.name,
                              fontSize: 24,
                              shadow: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 3,
              right: 24,
              bottom: 24,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: MaterialButton(
                        onPressed: onChat,
                        minWidth: 0,
                        padding: EdgeInsets.zero,
                        child: AppButton(
                          image: Image.asset('assets/images/ic_message_outline.png'),
                          colorStyle: 'blue',
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    Flexible(
                      child: MaterialButton(
                        onPressed: onChallenge,
                        minWidth: 0,
                        padding: EdgeInsets.zero,
                        child: AppButton(
                          image: Image.asset('assets/images/ic_vs.png'),
                          colorStyle: 'yellow',
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