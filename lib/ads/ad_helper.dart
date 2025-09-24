import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7904587159144019/7458501500';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7904587159144019/2014603131';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get articleInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7904587159144019/2014603131';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7904587159144019/9651650071';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
