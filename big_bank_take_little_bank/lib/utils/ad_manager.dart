
import 'dart:io';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8790458672355136~4448279269';
      // return 'ca-app-pub-5153425644830699~6315941467';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8790458672355136~8614073145';
      // return 'ca-app-pub-5153425644830699~7898462351';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8790458672355136/6551698420';
      // return 'ca-app-pub-5153425644830699/8856320805';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8790458672355136/7673208400';
      // return 'ca-app-pub-5153425644830699/3767645658';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
// String getRewardBasedVideoAdUnitId() {
//   if (Platform.isIOS) {
//     return 'ca-app-pub-3940256099942544/1712485313';
//   } else if (Platform.isAndroid) {
//     return 'ca-app-pub-3940256099942544/5224354917';
//   }
//   return null;
// }
// Reward Video
// Android: ca-app-pub-3940256099942544/5224354917
// iOS: ca-app-pub-3940256099942544/1712485313
