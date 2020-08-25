import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileImageView extends StatelessWidget {
  final String imageUrl;
  final double avatarSize;

  ProfileImageView({this.imageUrl, this.avatarSize = 50});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: avatarSize,
      width: avatarSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(avatarSize / 2),
        color: Colors.white,
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          height: avatarSize,
          width: avatarSize,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(avatarSize / 2),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Center(
          child: Container(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          return Container(
            height: avatarSize,
            width: avatarSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(avatarSize / 2),
              color: Colors.white,
              image: DecorationImage(
                image: Image.asset('assets/images/ic_person.png',).image,
                fit: BoxFit.fill,
              ),
            ),
          );
        },
      ),
    );
  }
}