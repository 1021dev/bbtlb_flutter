import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LiveChallengeFinishedCell extends StatelessWidget {
  final ChallengeModel challengeModel;
  final Function onTap;
  LiveChallengeFinishedCell({
    this.challengeModel,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    double avatarSize = MediaQuery.of(context).size.width * 0.12;
    // double height = width * 0.7;
    return FutureBuilder(
      future: FirestoreService().getUserWithId(challengeModel.winner),
      builder: (ctx, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        UserModel winner = snapshot.data;
        return FutureBuilder(
          future: FirestoreService().getUserWithId(challengeModel.loser),
          builder: (context, snap) {
            if (snap.data == null) {
              return Container();
            }
            UserModel loser = snap.data;
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
                              image: winner.image ?? '',
                            ),
                            Expanded(
                              child: Center(
                                child: AppLabel(
                                  title: winner.name ?? '',
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
                                  title: loser.name ?? '',
                                  shadowColor: Colors.black,
                                  shadow: true,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            ProfileAvatar(
                              avatarSize: avatarSize,
                              image: loser.image ?? '',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}