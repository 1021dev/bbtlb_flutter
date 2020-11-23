import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/widgets/app_button.dart';
import 'package:date_format/date_format.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleChallengeFinishedCell extends StatelessWidget {
  final ChallengeModel challengeModel;
  final Function onTap;
  final Function tapUser;
  ScheduleChallengeFinishedCell({
    this.challengeModel,
    this.onTap,
    this.tapUser,
  });
  @override
  Widget build(BuildContext context) {
    double avatarSize = MediaQuery.of(context).size.width * 0.15;
    return FutureBuilder(
      future: FirestoreService().getUserWithId(challengeModel.sender),
      builder: (ctx, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        UserModel sender = snapshot.data;
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
                  GestureDetector(
                    onTap: () {
                      tapUser(sender);
                    },
                    child: ProfileAvatar(
                      avatarSize: avatarSize,
                      image: sender.image ?? '',
                    ),
                  ),
                  SizedBox(width: 8,),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppLabel(
                          title: sender.name ?? '',
                          shadowColor: Colors.black,
                          shadow: true,
                          fontSize: 18,
                        ),
                        AppLabel(
                          title: formatDate(challengeModel.challengeTime, [hh, ':', nn, am, ' ', Z]),
                          maxLine: 2,
                          shadowColor: Colors.black,
                          shadow: true,
                          fontSize: 14,
                          color: Color(0xff56a7a4),
                        ),
                        AppLabel(
                          title: formatDate(challengeModel.challengeTime, [M, ' ', d, ' ', yyyy]),
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
      },
    );
  }
}