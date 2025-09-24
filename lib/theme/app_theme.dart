import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config.dart';

/// The core file which establishes the theme of our app. Here are described the
/// light/dark themes and all of their corresponding assets, like button colors,
/// text colors, fonts, styles..
class AppTheme with ChangeNotifier{
  static const String _currentThemeKey = 'currentTheme';
  static bool _isDarkTheme = false;
  static const int _color = 0xFF404040;

  /// Box is used for making the selected AppTheme persistent after restarting the app.
  AppTheme() {
    if(box!.containsKey(_currentThemeKey)) {
      _isDarkTheme = box?.get(_currentThemeKey );
    } else {
      box?.put(_currentThemeKey, _isDarkTheme);
    }
  }

  /// Keeping track of the current selected theme by the user.
  ThemeMode currentTheme() {
    return _isDarkTheme ?  ThemeMode.dark : ThemeMode.light;
  }

  /// Method used to switch theme, considering the one that is currently used.
  void switchTheme() {
    _isDarkTheme = !_isDarkTheme;
    box?.put(_currentThemeKey, _isDarkTheme);
    notifyListeners();
  }

  /// LightTheme description.
  /// It works like a blueprint: any visual element that we want to be utilized
  /// as part of the theme will be described here.
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemStatusBarContrastEnforced: true,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        color: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        titleTextStyle: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      listTileTheme: const ListTileThemeData(textColor: Colors.black),
      colorScheme: const ColorScheme.light(
        primary: Colors.white,
        onPrimary: Colors.white,
        secondary: Colors.white,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
      ),
      textTheme: ThemeData.light().textTheme,
    );
  }

  /// Dark theme description.
  /// It works like a blueprint: any visual element that we want to be utilized
  /// as part of the theme will be described here.
  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(_color),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(_color),
          systemStatusBarContrastEnforced: true,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        color: Color(_color),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 20,
        )
      ),
      listTileTheme: const ListTileThemeData(textColor: Colors.white),
      colorScheme: const ColorScheme.dark(
        primary: Color(_color),
        onPrimary: Color(_color),
        secondary: Color(_color),
      ),
      cardTheme: const CardThemeData(
        color: Color(_color),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(_color),
      ),
      textTheme: ThemeData.dark().textTheme,
    );
  }
}