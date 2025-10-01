import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5562747729301019/1894338733';
      // Test unit ID: return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5562747729301019/4643150374';
      // Test unit ID: return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get articleInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5562747729301019/2856066616';
      // Test unit ID: return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5562747729301019/9731825521';
      // Test unit ID: return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
