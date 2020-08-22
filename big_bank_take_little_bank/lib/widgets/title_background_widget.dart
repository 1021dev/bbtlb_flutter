import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleBackgroundWidget extends StatelessWidget {
  final double height;
  final bool isShadow;
  final String title;

  TitleBackgroundWidget({this.height = 60, this.isShadow = true, this.title = '',});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 6,
            bottom: 0,
            right: 0,
            left: 6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
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
                borderRadius: BorderRadius.circular(24),
                color: Color(0xFF549383),
              ),
            ),
          ),
          Positioned(
            top: 8,
            bottom: 14,
            right: 14,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isShadow ? null: Color(0xFF0E3D47),
                boxShadow: isShadow ? [
                  BoxShadow(
                    color: Color(0xBB000000),
                  ),
                  BoxShadow(
                    color: Color(0xFF0E3D47),
                    spreadRadius: -4.0,
                    blurRadius: 4.0,
                  ),
                ]: [],
              ),
            ),
          ),
          Positioned(
            top: 14,
            right: 18,
            left: 14,
            height: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0x20FFFFFF),
              ),
            ),
          ),
          Text(
            title ?? '',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Lucky',
              fontSize: 20,
              shadows: [
                Shadow(
                  color: Colors.black87,
                  offset: Offset(4.0, 4.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}