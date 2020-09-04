import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/widgets/pulse_widget.dart';
import 'package:flutter/material.dart';

class ChallengeRequestButton extends StatefulWidget {
  final ChallengeModel challengeModel;
  final Function onTap;

  ChallengeRequestButton({this.challengeModel, this.onTap});
  @override
  _ChallengeRequestButtonState createState() => new _ChallengeRequestButtonState();
}

class _ChallengeRequestButtonState extends State<ChallengeRequestButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
    );
    _startAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    // _controller.stop();
    // _controller.reset();
    _controller.repeat(
      period: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: new PulseWidget(_controller),
      child: GestureDetector(
        onTap: widget.onTap(widget.challengeModel),
        child: SizedBox(
          width: 100.0,
          height: 100.0,
        ),
      ),
    );
  }
}
