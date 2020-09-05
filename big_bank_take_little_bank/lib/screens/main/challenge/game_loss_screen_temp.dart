import 'dart:math';

import 'package:align_positioned/align_positioned.dart';
import 'package:big_bank_take_little_bank/utils/app_constant.dart';
import 'package:big_bank_take_little_bank/widgets/animated_bubble.dart';
import 'package:big_bank_take_little_bank/widgets/animated_button.dart';
import 'package:big_bank_take_little_bank/widgets/app_button.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/make_circle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameLossTempScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _GameLossTempScreenState();
  }
}

class _GameLossTempScreenState extends State<GameLossTempScreen> with TickerProviderStateMixin {

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
                image: AssetImage('assets/images/screen_loss.png'),
              )
            ),
          ),
          Positioned(
            bottom: 64,
            left: 0,
            right: 0,
            child: AnimatedButton(
              content: AppButton(
                height: 50,
                title: 'TRY AGAIN',
                colorStyle: 'yellow',
              ),
              onTap: () {

              },
            ),
          ),
        ],
      ),
    );
  }
}

