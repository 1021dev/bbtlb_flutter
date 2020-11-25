import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedBubble extends AnimatedWidget{

  final Image image;
  // A 4-Dimensional matrix to transform a bubble
  var transform = Matrix4.identity();

  // Start size of the bubble
  final double startSize;
  final double size;
  //End size of the bubble
  final double endSize;
  final Function ended;


  AnimatedBubble({
    Key key,
    Animation<double> animation,
    this.endSize,
    this.startSize,
    this.image,
    this.size = 10.0,
    this.ended,
  }):super(key: key, listenable:animation);

  @override
  Widget build(BuildContext context) {
    // final Animation<double> animation = listenable;
    // final _sizeTween = Tween<double>(begin: startSize, end: endSize);

    double x = Random().nextDouble() * size * 0.1 - size * 0.05;
    double y = Random().nextDouble() * endSize.toDouble() * 0.2;
    transform.translate(0.0, y, 0.0);
    print(transform);

    return Transform(
      transform: transform,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: image.image ?? Image.asset('assets/images/coin1.png'),
          ),
        ),
        height: size,//_sizeTween.evaluate(animation),
        width: size,//_sizeTween.evaluate(animation),
      ),
    );
  }

}

