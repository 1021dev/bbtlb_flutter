
import 'dart:io';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5153425644830699~6315941467';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5153425644830699~7898462351';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5153425644830699/8856320805';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5153425644830699/3767645658';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
