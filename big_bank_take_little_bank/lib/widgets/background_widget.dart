import 'package:flutter/cupertino.dart';

class BackgroundWidget extends StatelessWidget {
  final double height;
  final bool isShadow;

  BackgroundWidget({this.height = 60, this.isShadow = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Stack(
        children: [
          Positioned(
            top: 6,
            bottom: 0,
            right: 0,
            left: 6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0x66000000),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 6,
            right: 6,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFF549383),
              ),
            ),
          ),
          Positioned(
            top: 8,
            bottom: 16,
            right: 14,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isShadow ? null: Color(0xFF0E3D47),
                boxShadow: isShadow ? [
                  BoxShadow(
                    color: Color(0xAA000000),
                  ),
                  BoxShadow(
                    color: Color(0xFF0E3D47),
                    spreadRadius: -4.0,
                    blurRadius: 12.0,
                  ),
                ]: [],
              ),
            ),
          ),
        ],
      ),
    );
  }

}