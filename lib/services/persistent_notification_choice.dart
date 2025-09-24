import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../theme/config.dart';

class Notifications extends ChangeNotifier{
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
    const platform = MethodChannel('com.example.notifications/permissions');
    try {
      await platform.invokeMethod('openNotificationSettings');
    } on PlatformException catch (e) {
      print("Failed to open notification settings: '${e.message}'.");
    }
  }
}
