import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../theme/config.dart';

class Notifications extends ChangeNotifier {
  static const String _currentState = 'ON';
  static bool toggle = false;

  Notifications() {
    if (box!.containsKey(_currentState)) {
      toggle = box?.get(_currentState);
    } else {
      box?.put(_currentState, toggle);
    }
  }

  bool currentState() {
    return toggle;
  }

  void switchOnOff() {
    toggle = !toggle;
    box?.put(_currentState, toggle);
    notifyListeners();
  }

  Future<void> openNotificationSettings() async {
    // First request permission
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    // Then open settings
    const platform = MethodChannel('ro.ziarulargesul.mobile/browser');
    try {
      await platform.invokeMethod('openNotificationSettings');
    } on PlatformException catch (e) {
      print("Failed to open notification settings: '${e.message}'.");
    }
  }
}
