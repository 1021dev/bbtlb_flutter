import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingCellView extends StatelessWidget {
  final String text;
  final String icon;
  final bool notification;
  final Function onTap;
  final Function onChange;
  final bool isDelete;
  SettingCellView({
    this.text,
    this.icon,
    this.notification,
    this.onTap,
    this.onChange,
    this.isDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      width: double.infinity,
      height: 80,
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: () {
            onTap();
          },
          minWidth: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                bottom: 4,
                right: 4,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: isDelete ? [
                        _redBorderColor1,
                        _redBorderColor2,
                      ]: [
                        _greenBorderColor1,
                        _greenBorderColor2,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x90000000),
                        spreadRadius: -1,
                        offset: Offset(6, 6),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                bottom: 16,
                right: 24,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDelete ? _redBackgroundColor: _greenBackgroundColor,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 28,
                left: 12,
                height: 24,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0x23ffffff),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: [
                    Image.asset('assets/images/$icon.png', height: 50,),
                    SizedBox(width: 16,),
                    Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lucky',
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 16,),
                    notification != null ? CupertinoSwitch(
                      value: notification,
                      onChanged: (val) {
                        onChange(val);
                      },
                      trackColor: Color(0xff114650),
                      activeColor: Color(0xff46BDBF),
                    ): Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color get _redBorderColor1 => Color(0xffe86138);
  Color get _redBorderColor2 => Color(0xffed2020);
  Color get _redBackgroundColor => Color(0xffcd1b15);
  Color get _greenBorderColor1 => Color(0xff5c9d86);
  Color get _greenBorderColor2 => Color(0xff35777e);
  Color get _greenBackgroundColor => Color(0xff0e3d48);
}