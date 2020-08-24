import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppLabel extends StatelessWidget {
  final String title;
  final Color color;
  AppLabel({
    this.title = '',
    this.color = Colors.white,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: color,
      ),
    );
  }
}