import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeCell extends StatelessWidget {

  final UserModel userModel;
  final Function onTap;
  HomeCell({this.userModel, this.onTap,});

  @override
  Widget build(BuildContext context) {
    double avatarSize = MediaQuery.of(context).size.width * 0.22;
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 24, bottom: 16),
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
              child: Container(),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              height: avatarSize + 8,
              width: avatarSize + 8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0e3d48),
                    Color(0xFF1b5c6b),
                  ],
                ),
                borderRadius: BorderRadius.circular(avatarSize / 2 + 4),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    spreadRadius: 1.0,
                    blurRadius: 4.0,
                    offset: Offset(
                      2.0,
                      2.0,
                    ),
                  ),
                ],
              ),
              padding: EdgeInsets.all(2),
              child: Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(avatarSize / 2),
                ),
                child: ProfileImageView(
                  imageUrl: userModel.image ?? '',
                  avatarSize: avatarSize,
                ),
              ),
            ),
          ),
          Positioned(
            child: Container(
              padding: EdgeInsets.only(top: avatarSize / 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: AppLabel(
                      title: userModel.name,
                      shadow: true,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          width: avatarSize * 0.7,
                          height: avatarSize * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color.fromRGBO(9, 9, 9, 0.28),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppButtonLabel(
                                title: '${userModel.totalWin}',
                                color: Color(0xFF84b65b),
                                fontSize: 24,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              AppButtonLabel(
                                title: 'WINS',
                                color: Colors.white,
                                fontSize: 12,
                                shadow: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8,),
                      Flexible(
                        child: Container(
                          width: avatarSize * 0.7,
                          height: avatarSize * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color.fromRGBO(9, 9, 9, 0.28),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppButtonLabel(
                                title: '${userModel.totalLoss}',
                                color: Color(0xFFd741d9),
                                fontSize: 24,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              AppButtonLabel(
                                title: 'LOSSES',
                                color: Colors.white,
                                fontSize: 12,
                                shadow: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            height: 50,
            width: avatarSize * 1.2,
            child: MaterialButton(
              onPressed: onTap,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: avatarSize * 1.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/button_yellow.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Image.asset('assets/images/ic_vs.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}