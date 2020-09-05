import 'dart:math';

import 'package:align_positioned/align_positioned.dart';
import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/utils/app_constant.dart';
import 'package:big_bank_take_little_bank/widgets/animated_bubble.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/make_circle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameWinTempScreen extends StatefulWidget {

  final int points;
  final ChallengeModel challengeModel;

  GameWinTempScreen({this.points, this.challengeModel});

  @override
  State<StatefulWidget> createState() {
    return _GameWinTempScreenState();
  }
}

class _GameWinTempScreenState extends State<GameWinTempScreen> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: MediaQuery.of(context).size.height,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/screen_win.png'),
              )
            ),
          ),
          Positioned(
            bottom: 64,
            left: 0,
            right: 0,
            child: Column(
              children: [
                AppButtonLabel(
                  title: 'YOUR WIN',
                  fontSize: 32,
                  shadow: true,
                ),
                SizedBox(
                  height: 8,
                ),
                AppGradientLabel(
                  title: '1234',
                  shadow: true,
                  fontSize: 48,
                ),
                SizedBox(
                  height: 8,
                ),
                AppButtonLabel(
                  title: 'POINTS',
                  fontSize: 20,
                  shadow: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

