import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';

class AppButton extends StatelessWidget {

  final String title;
  final String colorStyle;
  final Image image;
  final double height;
  final Widget titleWidget;

  AppButton({
    this.title,
    this.colorStyle = 'green',
    this.image,
    this.height = 50,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getBackgroundColor(colorStyle),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: getStrokeColor(colorStyle),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x80000000),
            offset: Offset(3,5),
          ),
          BoxShadow(
            color: getStrokeColor(colorStyle),
            spreadRadius: 3,
            blurRadius: 10,
          ),
          BoxShadow(
            color: Color(0xAA000000),
            spreadRadius: -5,
            blurRadius: 2,
            offset: Offset(7,10),
          ),
        ]
      ),
      padding: EdgeInsets.all(4),
      child: Stack(
        children: [
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: Color(0x44ffffff),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Center(
            child: getChild(),
          ),
        ],
      ),
    );
  }

  Widget getChild() {
    if (titleWidget != null) {
      return titleWidget;
    }
    if (title != null) {
      return Text(
        title,
      );
    }
    if (image != null) {
      return image;
    }

    return Container();
  }
}

List<Color> getBackgroundColor(String type) {
  switch (type) {
    case 'green':
      return [
        Color(0xff22f863),
        Color(0xff48c26c),
      ];

    case 'orange':
      return [
        Color(0xfff38148),
        Color(0xffd44417),
      ];

    case 'blue':
      return [
        Color(0xff107495),
        Color(0xff18c7fa),
      ];

    case 'yellow':
      return [
        Color(0xfffe39714),
        Color(0xfff3c929),
      ];

    default:
      return [
        Color(0xff22f863),
        Color(0xff48c26c),
      ];
  }
}
Color getStrokeColor(String type) {
  switch (type) {
    case 'green':
      return Color(0xff7de25e);

    case 'orange':
      return Color(0xffc85d2e);

    case 'blue':
      return Color(0xff34c5f3);

    case 'yellow':
      return Color(0xfffac746);

    default:
      return Color(0xff69e890);
  }
}