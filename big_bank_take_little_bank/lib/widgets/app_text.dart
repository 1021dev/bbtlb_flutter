import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppLabel extends StatelessWidget {
  final String title;
  final Color color;
  final bool shadow;
  final Color shadowColor;
  final String fontFamily;
  final double fontSize;

  AppLabel({
    this.title = '',
    this.color = Colors.white,
    this.shadow = false,
    this.shadowColor = Colors.black87,
    this.fontFamily = 'BackToSchool',
    this.fontSize = 18,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: fontSize,
        shadows: shadow ? [
          Shadow(
            color: shadowColor,
            offset: Offset(2.0, 2.0),
          ),
        ] : [],
      ),
      maxLines: 1,
      softWrap: true,
    );
  }
}

class AppBorderLabel extends StatelessWidget {
  final String title;
  final Color color;
  final bool shadow;
  final Color shadowColor;
  final String fontFamily;
  final double fontSize;
  final double borderWidth;

  AppBorderLabel({
    this.title = '',
    this.color = Colors.white,
    this.shadow = false,
    this.shadowColor = Colors.black87,
    this.fontFamily = 'BackToSchool',
    this.fontSize = 18,
    this.borderWidth = 4,

  });
  @override
  Widget build(BuildContext context) {
    return BorderedText(
      strokeWidth: borderWidth,
      strokeColor: Colors.black,
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontFamily: fontFamily,
          fontSize: fontSize,
          shadows: shadow ? [
            Shadow(
              color: shadowColor,
              offset: Offset(4.0, 4.0),
            ),
          ] : [],
        ),
      ),
    );
  }
}

class AppButtonLabel extends StatelessWidget {
  final String title;
  final Color color;
  final bool shadow;
  final Color shadowColor;
  final String fontFamily;
  final double fontSize;

  AppButtonLabel({
    this.title = '',
    this.color = Colors.white,
    this.shadow = false,
    this.shadowColor = Colors.black87,
    this.fontFamily = 'Lucky',
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: fontSize,
        shadows: shadow ? [
          Shadow(
            color: shadowColor,
            offset: Offset(4.0, 4.0),
          ),
        ] : [],
      ),
    );
  }
}

class BackgroundButton extends StatelessWidget {
  final String title;
  final Color color;
  final bool shadow;
  final Color shadowColor;
  final String fontFamily;
  final double fontSize;
  final Function onTap;
  final double height;
  final double width;

  BackgroundButton({
    this.title = '',
    this.color = Colors.white,
    this.shadow = false,
    this.shadowColor = Colors.black87,
    this.fontFamily = 'Lucky',
    this.fontSize = 18,
    this.onTap,
    this.width,
    this.height = 44,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.asset('assets/images/2.0x/button_yellow.png', fit: BoxFit.fill,).image,
          )
        ),
        child: Center(
          child: AppButtonLabel(
            title: title,
            color: color,
            shadow: shadow,
            shadowColor: shadowColor,
            fontFamily: fontFamily,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}

class AppGradientLabel extends StatelessWidget {
  final String title;
  final Gradient gradient;
  final bool shadow;
  final Color shadowColor;
  final String fontFamily;
  final double fontSize;

  AppGradientLabel({
    this.title = '',
    this.gradient,
    this.shadow = false,
    this.shadowColor = Colors.black87,
    this.fontFamily = 'Lucky',
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xffff8d1e), Color(0xffffc412)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    return Text(
      title,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        shadows: shadow ? [
          Shadow(
            color: shadowColor,
            offset: Offset(fontSize * 0.1, fontSize * 0.1),
          ),
        ] : [],
        foreground: Paint()..shader = linearGradient,
      ),
    );
  }
}

