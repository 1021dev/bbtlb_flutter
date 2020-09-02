import 'dart:io';

import 'package:big_bank_take_little_bank/utils/pic_swiper.dart';
import 'package:big_bank_take_little_bank/utils/video_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CropImage extends StatelessWidget {
  const CropImage({
    @required this.index,
    @required this.albumn,
    @required this.list,
    this.isVideo,
  });
  final List<String> albumn;
  final List<String> list;
  final bool isVideo;
  final int index;
  @override
  Widget build(BuildContext context) {
    if (albumn.length == 0) {
      return Container();
    }
    final String imageItem = albumn[index];

    return ExtendedImage.network(
      imageItem,
        clearMemoryCacheWhenDispose: true,
        loadStateChanged: (ExtendedImageState state) {
        Widget widget;
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            widget = Container(
              color: Colors.grey,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              ),
            );
            break;
          case LoadState.completed:
            state.returnLoadStateChangedWidget = false;
            widget = Hero(
                tag: imageItem,
                child: ExtendedRawImage(image: state.extendedImageInfo.image, fit: BoxFit.cover),);

            // widget = ExtendedRawImage(image: state.extendedImageInfo.image, fit: BoxFit.cover);

            break;
          case LoadState.failed:
            widget = GestureDetector(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    'assets/images/ic_block.png',
                    fit: BoxFit.cover,
                  ),
                  const Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Text(
                      'load image failed, click to reload',
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              onTap: () {
                state.reLoadImage();
              },
            );
            break;
        }
        if (index == 6 && albumn.length > 6) {
          widget = Stack(
            children: <Widget>[
              widget,
              Container(
                color: Colors.grey.withOpacity(0.2),
                alignment: Alignment.center,
                child: Text(
                  '+${albumn.length - 6}',
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              )
            ],
          );
        }

        widget = GestureDetector(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              widget,
              isVideo ? Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 36,
              ): Container(),
            ],
          ),
          onTap: () {
            String url = list[index];
            if (url.contains('video') || url.split('.').last == 'm3u8') {
              final page = VideoViewer(index: index, pics: albumn, list: list,);
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,fullscreenDialog:false,
                  pageBuilder: (_, __, ___) => page,
                ),
              );
            } else {
              final page = PicSwiper(index: index, pics: albumn, list: list,);
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,fullscreenDialog:false,
                  pageBuilder: (_, __, ___) => page,
                ),
              );
            }
          },
        );

        return widget;
      }
    );
  }

}
