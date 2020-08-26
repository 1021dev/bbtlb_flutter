import 'package:big_bank_take_little_bank/widgets/profile_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double avatarSize;
  final String image;
  ProfileAvatar({this.image, this.avatarSize = 64});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: avatarSize + 8,
      width: avatarSize + 8,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0e3d48),
            Color(0xFF1b5c6b),
          ],
        ),
        borderRadius: BorderRadius.circular(avatarSize / 2 + 4),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            spreadRadius: 1.0,
            blurRadius: 4.0,
            offset: Offset(
              2.0,
              2.0,
            ),
          ),
        ],
      ),
      padding: EdgeInsets.all(2),
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(avatarSize / 2),
        ),
        child: ProfileImageView(
          imageUrl: image ?? '',
          avatarSize: avatarSize,
        ),
      ),
    );
  }
}