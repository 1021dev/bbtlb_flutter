import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:big_bank_take_little_bank/utils/screen_util.dart';
import 'package:extended_image/extended_image.dart';
// ignore: implementation_imports
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:toast/toast.dart';
  
import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart' show Chewie, ChewieController;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef DoubleClickAnimationListener = void Function();

class PicSwiper extends StatefulWidget {
  const PicSwiper({
    this.index,
    this.pics,
    this.list,
  });
  final int index;
  final List<String> pics;
  final List<String> list;
  @override
  _PicSwiperState createState() => _PicSwiperState();
}

class _PicSwiperState extends State<PicSwiper> with TickerProviderStateMixin {
  final StreamController<int> rebuildIndex = StreamController<int>.broadcast();
  final StreamController<bool> rebuildSwiper =
      StreamController<bool>.broadcast();
  final StreamController<double> rebuildDetail =
      StreamController<double>.broadcast();
  final Map<int, ImageDetailInfo> detailKeys = <int, ImageDetailInfo>{};
  AnimationController _doubleClickAnimationController;
  AnimationController _slideEndAnimationController;
  Animation<double> _slideEndAnimation;
  Animation<double> _doubleClickAnimation;
  DoubleClickAnimationListener _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  int _currentIndex = 0;
  bool _showSwiper = true;
  double _imageDetailY = 0;
  Rect imageDRect;

  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
  bool isVideo = false;

  @override
  void initState() {
    _currentIndex = widget.index;
    String url = widget.list[_currentIndex];
    if (url.contains('video') || url.split('.').last == 'm3u8') {
      isVideo = true;
      _videoPlayerController1 = VideoPlayerController.network(url);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        autoPlay: true,
        looping: true,
        // Try playing around with some of these other options:

        // showControls: false,
        // materialProgressColors: ChewieProgressColors(
        //   playedColor: Colors.red,
        //   handleColor: Colors.blue,
        //   backgroundColor: Colors.grey,
        //   bufferedColor: Colors.lightGreen,
        // ),
        // placeholder: Container(
        //   color: Colors.grey,
        // ),
        // autoInitialize: true,
      );
    } else {
      _doubleClickAnimationController = AnimationController(
          duration: const Duration(milliseconds: 150), vsync: this);

      _slideEndAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
      );
      _slideEndAnimationController.addListener(() {
        _imageDetailY = _slideEndAnimation.value;
        if (_imageDetailY == 0) {
          _showSwiper = true;
          rebuildSwiper.add(_showSwiper);
        }
        rebuildDetail.sink.add(_imageDetailY);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (!isVideo) {
      rebuildIndex.close();
      rebuildSwiper.close();
      rebuildDetail.close();
      _doubleClickAnimationController.dispose();
      _slideEndAnimationController.dispose();
      clearGestureDetailsCache();
    } else {
      _videoPlayerController1.dispose();
      _chewieController.dispose();
    }
    //cancelToken?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String url = widget.list[_currentIndex];
    if (url.contains('video') || url.split('.').last == 'm3u8') {
      Widget result = Material(
        color: Colors.transparent,
        child: Center(
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      );
      result = ExtendedImageSlidePage(
        key: slidePagekey,
        slidePageBackgroundHandler: (offset, pageSize) {
          double opacity = 0.0;
          opacity = offset.distance /
              (Offset(pageSize.width, pageSize.height).distance / 2.0);
          return Colors.black87.withOpacity(min(1.0, max(1.0 - opacity, 0.0)));
        },
        child: result,
        slideAxis: SlideAxis.both,
        slideType: SlideType.onlyImage,
        slideScaleHandler: (
          Offset offset, {
          ExtendedImageSlidePageState state,
        }) {
          //image is ready and it's not sliding.
          if (detailKeys[_currentIndex] != null && state.scale == 1.0) {
            //don't slide page if scale of image is more than 1.0
            if (state != null &&
                state.imageGestureState.gestureDetails.totalScale > 1.0) {
              return 1.0;
            }
            //or slide down into detail mode
            if (offset.dy < 0 || _imageDetailY < 0) {
              return 1.0;
            }
          }

          return null;
        },
        slideOffsetHandler: (
          Offset offset, {
          ExtendedImageSlidePageState state,
        }) {
          return null;
        },
        slideEndHandler: (
          Offset offset, {
          ExtendedImageSlidePageState state,
          ScaleEndDetails details,
        }) {
          if (_imageDetailY != 0 && state.scale == 1) {
            if (!_slideEndAnimationController.isAnimating) {
              final double magnitude = details.velocity.pixelsPerSecond.distance;
              if (doubleCompare(magnitude, minMagnitude) >= 0) {
                final Offset direction =
                    details.velocity.pixelsPerSecond / magnitude * 1000;

                _slideEndAnimation =
                    _slideEndAnimationController.drive(Tween<double>(
                  begin: _imageDetailY,
                  end: (_imageDetailY + direction.dy).clamp(
                      -detailKeys[_currentIndex].maxImageDetailY, 0.0) as double,
                ));
                _slideEndAnimationController.reset();
                _slideEndAnimationController.forward();
              }
            }
            return false;
          }

          return null;
        },
        onSlidingPage: (ExtendedImageSlidePageState state) {
          final bool showSwiper = !state.isSliding;
          if (showSwiper != _showSwiper) {
            // _showSwiper = showSwiper;
            // });

            _showSwiper = showSwiper;
            rebuildSwiper.add(_showSwiper);
          }
        },
      );
      return result;

    } else {
      final Size size = MediaQuery.of(context).size;
      imageDRect = Offset.zero & size;
      Widget result = Material(
          color: Colors.transparent,
          shadowColor: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ExtendedImageGesturePageView.builder(
                controller: PageController(
                  initialPage: widget.index,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final String item = widget.pics[index];

                  Widget image = ExtendedImage.network(
                    item,
                    fit: BoxFit.contain,
                    enableSlideOutPage: true,
                    mode: ExtendedImageMode.gesture,
                    heroBuilderForSlidingPage: (Widget result) {
                      if (index < min(6, widget.pics.length)) {
                        return Hero(
                          tag: item,
                          child: result,
                          flightShuttleBuilder: (BuildContext flightContext,
                              Animation<double> animation,
                              HeroFlightDirection flightDirection,
                              BuildContext fromHeroContext,
                              BuildContext toHeroContext) {
                            final Hero hero =
                                (flightDirection == HeroFlightDirection.pop
                                    ? fromHeroContext.widget
                                    : toHeroContext.widget) as Hero;
                            return hero.child;
                          },
                        );
                      } else {
                        return result;
                      }
                    },
                    initGestureConfigHandler: (ExtendedImageState state) {
                      double initialScale = 1.0;

                      if (state.extendedImageInfo != null &&
                          state.extendedImageInfo.image != null) {
                        initialScale = initScale(
                            size: size,
                            initialScale: initialScale,
                            imageSize: Size(
                                state.extendedImageInfo.image.width.toDouble(),
                                state.extendedImageInfo.image.height.toDouble()));
                      }
                      return GestureConfig(
                          inPageView: true,
                          initialScale: initialScale,
                          maxScale: max(initialScale, 5.0),
                          animationMaxScale: max(initialScale, 5.0),
                          initialAlignment: InitialAlignment.center,
                          //you can cache gesture state even though page view page change.
                          //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
                          cacheGesture: false);
                    },
                    onDoubleTap: (ExtendedImageGestureState state) {
                      ///you can use define pointerDownPosition as you can,
                      ///default value is double tap pointer down postion.
                      final Offset pointerDownPosition =
                          state.pointerDownPosition;
                      final double begin = state.gestureDetails.totalScale;
                      double end;

                      //remove old
                      _doubleClickAnimation
                          ?.removeListener(_doubleClickAnimationListener);

                      //stop pre
                      _doubleClickAnimationController.stop();

                      //reset to use
                      _doubleClickAnimationController.reset();

                      if (begin == doubleTapScales[0]) {
                        end = doubleTapScales[1];
                      } else {
                        end = doubleTapScales[0];
                      }

                      _doubleClickAnimationListener = () {
                        //print(_animation.value);
                        state.handleDoubleTap(
                            scale: _doubleClickAnimation.value,
                            doubleTapPosition: pointerDownPosition);
                      };
                      _doubleClickAnimation = _doubleClickAnimationController
                          .drive(Tween<double>(begin: begin, end: end));

                      _doubleClickAnimation
                          .addListener(_doubleClickAnimationListener);

                      _doubleClickAnimationController.forward();
                    },
                    loadStateChanged: (ExtendedImageState state) {
                      if (state.extendedImageLoadState == LoadState.completed) {
                        final Rect imageDRect = getDestinationRect(
                          rect: Offset.zero & size,
                          inputSize: Size(
                            state.extendedImageInfo.image.width.toDouble(),
                            state.extendedImageInfo.image.height.toDouble(),
                          ),
                          fit: BoxFit.contain,
                        );

                        detailKeys[index] ??= ImageDetailInfo(
                          imageDRect: imageDRect,
                          pageSize: size,
                          imageInfo: state.extendedImageInfo,
                        );
                        final ImageDetailInfo imageDetailInfo = detailKeys[index];
                        return StreamBuilder<double>(
                          builder:
                              (BuildContext context, AsyncSnapshot<double> data) {
                            return ExtendedImageGesture(
                              state,
                              canScaleImage: (_) => _imageDetailY == 0,
                              imageBuilder: (Widget image) {
                                return Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: image,
                                      top: _imageDetailY,
                                      bottom: -_imageDetailY,
                                    ),
                                    Positioned(
                                      left: 0.0,
                                      right: 0.0,
                                      top: imageDetailInfo.imageBottom +
                                          _imageDetailY,
                                      child: Opacity(
                                        opacity: _imageDetailY == 0
                                            ? 0
                                            : min(
                                                1,
                                                _imageDetailY.abs() /
                                                    (imageDetailInfo
                                                            .maxImageDetailY /
                                                        4.0),
                                              ),
                                        child: Container(),
                                        // ImageDetail(
                                        //   imageDetailInfo,
                                        //   index,
                                        //   widget.tuChongItem,
                                        // ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          initialData: _imageDetailY,
                          stream: rebuildDetail.stream,
                        );
                      }
                      return null;
                    },
                  );
                  image = GestureDetector(
                    child: image,
                    onTap: () {
                      {
                        // slidePagekey.currentState.popPage();
                        Navigator.pop(context);
                      }
                    },
                  );

                  return image;
                },
                itemCount: widget.pics.length,
                onPageChanged: (int index) {
                  _currentIndex = index;
                  rebuildIndex.add(index);
                  if (_imageDetailY != 0) {
                    _imageDetailY = 0;
                    rebuildDetail.sink.add(_imageDetailY);
                  }
                  _showSwiper = true;
                  rebuildSwiper.add(_showSwiper);
                },
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
  //              //move page only when scale is not more than 1.0
                // canMovePage: (GestureDetails gestureDetails) {
                //   //gestureDetails.totalScale <= 1.0
                //   //return translateY == 0.0;

                // }
                //physics: ClampingScrollPhysics(),
              ),
              StreamBuilder<bool>(
                builder: (BuildContext c, AsyncSnapshot<bool> d) {
                  if (d.data == null || !d.data) {
                    return Container();
                  }

                  return MySwiperPlugin(widget.pics, _currentIndex, rebuildIndex);
                },
                initialData: true,
                stream: rebuildSwiper.stream,
              )
            ],
          )
        );

      result = ExtendedImageSlidePage(
        key: slidePagekey,
        slidePageBackgroundHandler: (offset, pageSize) {
          double opacity = 0.0;
          opacity = offset.distance /
              (Offset(pageSize.width, pageSize.height).distance / 2.0);
          return Colors.black87.withOpacity(min(1.0, max(1.0 - opacity, 0.0)));
        },
        child: result,
        slideAxis: SlideAxis.both,
        slideType: SlideType.onlyImage,
        slideScaleHandler: (
          Offset offset, {
          ExtendedImageSlidePageState state,
        }) {
          //image is ready and it's not sliding.
          if (detailKeys[_currentIndex] != null && state.scale == 1.0) {
            //don't slide page if scale of image is more than 1.0
            if (state != null &&
                state.imageGestureState.gestureDetails.totalScale > 1.0) {
              return 1.0;
            }
            //or slide down into detail mode
            if (offset.dy < 0 || _imageDetailY < 0) {
              return 1.0;
            }
          }

          return null;
        },
        slideOffsetHandler: (
          Offset offset, {
          ExtendedImageSlidePageState state,
        }) {
          return null;
        },
        slideEndHandler: (
          Offset offset, {
          ExtendedImageSlidePageState state,
          ScaleEndDetails details,
        }) {
          if (_imageDetailY != 0 && state.scale == 1) {
            if (!_slideEndAnimationController.isAnimating) {
              final double magnitude = details.velocity.pixelsPerSecond.distance;
              if (doubleCompare(magnitude, minMagnitude) >= 0) {
                final Offset direction =
                    details.velocity.pixelsPerSecond / magnitude * 1000;

                _slideEndAnimation =
                    _slideEndAnimationController.drive(Tween<double>(
                  begin: _imageDetailY,
                  end: (_imageDetailY + direction.dy).clamp(
                      -detailKeys[_currentIndex].maxImageDetailY, 0.0) as double,
                ));
                _slideEndAnimationController.reset();
                _slideEndAnimationController.forward();
              }
            }
            return false;
          }

          return null;
        },
        onSlidingPage: (ExtendedImageSlidePageState state) {
          final bool showSwiper = !state.isSliding;
          if (showSwiper != _showSwiper) {
            // _showSwiper = showSwiper;
            // });

            _showSwiper = showSwiper;
            rebuildSwiper.add(_showSwiper);
          }
        },
      );

      return result;
      }
    }
}

class MySwiperPlugin extends StatelessWidget {
  const MySwiperPlugin(this.pics, this.index, this.reBuild);
  final List<String> pics;
  final int index;
  final StreamController<int> reBuild;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      builder: (BuildContext context, AsyncSnapshot<int> data) {
        return DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  child: Container(
                    alignment: Alignment.center,
                    width: 60,
                    height: 24,
                    decoration: BoxDecoration(
                      backgroundBlendMode: BlendMode.darken,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black54,
                    ),
                    child: Text(
                      '${data.data + 1} / ${pics.length}',
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16, bottom: 16),
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 36,
                      decoration: BoxDecoration(
                        backgroundBlendMode: BlendMode.darken,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black54,
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Roboto-Bold',),
                      ),
                    ),
                  ),
                  onTap: () {
                    saveNetworkImageToPhoto(pics[index])
                        .then((bool done) {
                          Toast.show(done ? 'save succeed' : 'save failed', context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM,);
                      // showToast(done ? 'save succeed' : 'save failed',
                      //     position:
                      //         ToastPosition(align: Alignment.topCenter));
                    });
                  },
                ),

              ],
            ),
          ),
        );
      },
      initialData: index,
      stream: reBuild.stream,
    );
  }
}

class ImageDetailInfo {
  ImageDetailInfo({
    @required this.imageDRect,
    @required this.pageSize,
    @required this.imageInfo,
  });

  final GlobalKey<State<StatefulWidget>> key = GlobalKey<State>();

  final Rect imageDRect;

  final Size pageSize;

  final ImageInfo imageInfo;

  double get imageBottom => imageDRect.bottom - 20;

  double _maxImageDetailY;
  double get maxImageDetailY {
    try {
      //
      return _maxImageDetailY ??= max(
          key.currentContext.size.height - (pageSize.height - imageBottom),
          0.1);
    } catch (e) {
      //currentContext is not ready
      return 100.0;
    }
  }
}