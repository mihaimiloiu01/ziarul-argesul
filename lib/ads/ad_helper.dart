import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // Production ID: return 'ca-app-pub-4470739099972924~2355457446';
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      // Production ID: return 'ca-app-pub-4470739099972924/3546847705';
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get articleInterstitialAdUnitId {
    if (Platform.isAndroid) {
      // Production ID: return 'ca-app-pub-4470739099972924/3193170043';
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      // Production ID: return 'ca-app-pub-4470739099972924/1582141296';
      return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
