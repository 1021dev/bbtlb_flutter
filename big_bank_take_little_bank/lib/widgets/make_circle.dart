import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
class MakeCircle extends Decoration {
  final double strokeWidth;
  final StrokeCap strokeCap;
  final Color color;

  MakeCircle({
    this.strokeCap = StrokeCap.round,
    this.strokeWidth = 44.0,
    this.color = const Color.fromRGBO(255, 255, 255, 0.05),
  });

  @override
  BoxPainter createBoxPainter([onChanged]) {
    return _CustomDecorationPainter(
      strokeCap: strokeCap,
      strokeWidth: strokeWidth,
      color: color,
    );
  }
}

class _CustomDecorationPainter extends BoxPainter {

  final double strokeWidth;
  final StrokeCap strokeCap;
  final Color color;

  _CustomDecorationPainter({
    this.strokeCap = StrokeCap.round,
    this.strokeWidth = 10.0,
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
    for (int i = 1; i < 6; i++) {
      path
        ..moveTo(
            bounds.size.width / 2, bounds.size.height * 2 / 5)
        ..addOval(Rect.fromCircle(center: Offset(
            bounds.size.width / 2, bounds.size.height * 2 / 5),
            radius: i.toDouble() * 100));
    }

    canvas.drawPath(path, paint);
  }

}
