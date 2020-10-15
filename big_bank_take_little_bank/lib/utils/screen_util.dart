import 'dart:math';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class ScreenUtil {
  

  ScreenUtil._({
    this.width = 1080,
    this.height = 1920,
    this.allowFontScaling = false,
    //dp
    this.maxPhysicalSize = 480,
  });

  static void init({
    double width = 1080,
    double height = 1920,
    bool allowFontScaling = false,
    double maxPhysicalSize = 480,
  }) {
    _instance = ScreenUtil._(
      width: width,
      height: height,
      allowFontScaling: allowFontScaling,
      maxPhysicalSize: maxPhysicalSize,
    );
  }

  static ScreenUtil get instance => _instance;
  static ScreenUtil _instance;

  //设计稿的设备尺寸修改
  double width;
  double height;
  bool allowFontScaling;
  double maxPhysicalSize;

  double get _screenWidth => min(window.physicalSize.width, maxPhysicalSize);
  double get _screenHeight => window.physicalSize.height;
  double get _pixelRatio => window.devicePixelRatio;
  double get _statusBarHeight =>
      EdgeInsets.fromWindowPadding(window.padding, window.devicePixelRatio).top;

  double get _bottomBarHeight =>
      EdgeInsets.fromWindowPadding(window.padding, window.devicePixelRatio)
          .bottom;

  double get _textScaleFactor => window.textScaleFactor;

  static MediaQueryData get mediaQueryData => MediaQueryData.fromWindow(window);

  ///每个逻辑像素的字体像素数，字体的缩放比例
  double get textScaleFactory => _textScaleFactor;

  ///设备的像素密度
  double get pixelRatio => _pixelRatio;

  ///当前设备宽度 dp
  double get screenWidthDp => _screenWidth;

  ///当前设备高度 dp
  double get screenHeightDp => _screenHeight;

  ///当前设备宽度 px
  double get screenWidth => _screenWidth * _pixelRatio;

  ///当前设备高度 px
  double get screenHeight => _screenHeight * _pixelRatio;

  ///状态栏高度 dp 刘海屏会更高
  double get statusBarHeight => _statusBarHeight;

  ///底部安全区距离 dp
  double get bottomBarHeight => _bottomBarHeight;

  ///实际的dp与设计稿px的比例
  double get scaleWidth => _screenWidth / instance.width;

  double get scaleHeight => _screenHeight / instance.height;

  ///根据设计稿的设备宽度适配
  ///高度也根据这个来做适配可以保证不变形
  double setWidth(double width) => width * scaleWidth;

  /// 根据设计稿的设备高度适配
  /// 当发现设计稿中的一屏显示的与当前样式效果不符合时,
  /// 或者形状有差异时,高度适配建议使用此方法
  /// 高度适配主要针对想根据设计稿的一屏展示一样的效果
  double setHeight(double height) => height * scaleHeight;

  ///字体大小适配方法
  ///@param fontSize 传入设计稿上字体的px ,
  ///@param allowFontScaling 控制字体是否要根据系统的“字体大小”辅助选项来进行缩放。默认值为false。
  ///@param allowFontScaling Specifies whether fonts should scale to respect Text Size accessibility settings. The default is false.
  double setSp(double fontSize) => allowFontScaling
      ? setWidth(fontSize)
      : setWidth(fontSize) / _textScaleFactor;
}

///
///  create by zmtzawqlp on 2020/1/31
///
double initScale({Size imageSize, Size size, double initialScale}) {
  final double n1 = imageSize.height / imageSize.width;
  final double n2 = size.height / size.width;
  if (n1 > n2) {
    final FittedSizes fittedSizes = applyBoxFit(BoxFit.contain, imageSize, size);
    //final Size sourceSize = fittedSizes.source;
    final Size destinationSize = fittedSizes.destination;
    return size.width / destinationSize.width;
  } else if (n1 / n2 < 1 / 4) {
    final FittedSizes fittedSizes = applyBoxFit(BoxFit.contain, imageSize, size);
    //final Size sourceSize = fittedSizes.source;
    final Size destinationSize = fittedSizes.destination;
    return size.height / destinationSize.height;
  }

  return initialScale;
}

///save netwrok image to photo
Future<bool> saveNetworkImageToPhoto(String url, {bool useCache = true}) async {
  if (kIsWeb) {
    return false;
  }
  // final Uint8List data = await getNetworkImageData(url, useCache: useCache);
  // // var filePath = await ImagePickerSaver.saveFile(fileData: data);
  // // return filePath != null && filePath != '';
  // final AssetEntity imageEntity = await PhotoManager.editor.saveImage(data);

  // return imageEntity != null;
  return false;
}
