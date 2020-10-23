import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class MakeCircle extends Decoration {
  final Animation<double> animation;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final Color color;

  MakeCircle({
    this.animation,
    this.strokeCap = StrokeCap.round,
    this.strokeWidth = 36.0,
    this.color = const Color.fromRGBO(255, 255, 255, 0.05),
  });

  @override
  BoxPainter createBoxPainter([onChanged]) {
    return _CustomDecorationPainter(
      animation: animation,
      strokeCap: strokeCap,
      strokeWidth: strokeWidth,
      color: color,
    );
  }
}

class _CustomDecorationPainter extends BoxPainter {
  final Animation<double> animation;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final Color color;

  _CustomDecorationPainter({
    this.animation,
    this.strokeCap = StrokeCap.round,
    this.strokeWidth = 36.0,
    this.color = const Color.fromRGBO(255, 255, 255, 0.05),
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect bounds = offset & configuration.size;
    final paint = Paint()
      ..color = color
      ..strokeCap = strokeCap
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke; //important set stroke style

    Path path = Path();
    for (int i = 1; i < 8; i++) {
      path
        ..moveTo(
            bounds.size.width / 2 + 30.0 * cos(animation.value), bounds.size.height * 2 / 5 + 30.0 * sin(animation.value))
        ..addOval(Rect.fromCircle(center: Offset(
            bounds.size.width / 2 + 30.0 * cos(animation.value), bounds.size.height * 2 / 5 + 30.0 * sin(animation.value)),
            radius: i.toDouble() * 80 + 40));
    }

    canvas.drawPath(path, paint);
  }

}
