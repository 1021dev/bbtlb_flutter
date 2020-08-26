import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendsRequestSentDialog extends StatelessWidget {
  final String image;
  final String name;
  FriendsRequestSentDialog({this.image = '', this.name = ''});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Container(
            height: 350,
            padding: EdgeInsets.all(16),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppLabel(
                            title: 'Friend request sent',
                          ),
                          SizedBox(height: 16,),
                          MaterialButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            minWidth: 0,
                            shape: CircleBorder(),
                            child: Image.asset('assets/images/ic_checkmark.png'),
                          ),
                        ],
                      ),
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
                  child: Container(
                    child: Column(
                      children: [
                        ProfileAvatar(
                          image: image ?? '',
                          avatarSize: 80,
                        ),
                        AppLabel(
                          title: name ?? '',
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}