import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingCellView extends StatelessWidget {
  final String text;
  final String icon;
  final bool notification;
  final Function onTap;
  final Function onChange;
  SettingCellView({
    this.text,
    this.icon,
    this.notification,
    this.onTap,
    this.onChange,
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
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0x66000000),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 4,
                right: 4,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFF549383),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                bottom: 12,
                right: 12,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFF0E3D47),
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
}