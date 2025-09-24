import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ziarul_argesul/pages/timeline_page.dart';
import 'package:ziarul_argesul/theme/app_theme.dart';
import 'package:ziarul_argesul/theme/config.dart';
import 'package:ziarul_argesul/util/adapters.dart';

const firebaseOptionsAndroid = FirebaseOptions(
  apiKey: 'AIzaSyA1JguWDqTs0yn3L4asYnHyBSmAoCs0fS4',
  appId: '1:508394428500:android:b99b14616feb905e0475c1',
  messagingSenderId: '508394428500',
  projectId: 'ziarul-argesul',
  storageBucket: 'ziarul-argesul.firebasestorage.app',
);

const firebaseOptionsIOS = FirebaseOptions(
  apiKey: 'AIzaSyCl4GxJZ1_YtXUl0unP2rtOX1PxGOh3dhQ',
  appId: '1:508394428500:ios:c2ee33c6b65bff920475c1',
  messagingSenderId: '508394428500',
  projectId: 'ziarul-argesul',
  storageBucket: 'ziarul-argesul.firebasestorage.app',
  iosBundleId: 'ro.ziarulargesul.mobile',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("➡️ Starting Firebase init");

  await Firebase.initializeApp(
    options: Platform.isIOS ? firebaseOptionsIOS : firebaseOptionsAndroid,
  );
  print("✅ Firebase initialized");

  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  print("➡️ Opening Hive boxes...");
  try {
    box = await Hive.openBox('box').timeout(const Duration(seconds: 5));
    articleBox = await Hive.openBox('article_box').timeout(const Duration(seconds: 5));
    print("✅ Hive boxes opened");
  } catch (e) {
    print("❌ Hive error: $e");
  }

  await MobileAds.instance.initialize();
  print("✅ Google Mobile Ads initialized");

  // Permissions
  try {
    print("➡️ Checking notification permissions");
    bool shouldRequest = !await Permission.notification.isGranted;
    if (shouldRequest) {
      print("➡️ Requesting notification permission...");
      await Permission.notification.request().timeout(const Duration(seconds: 5));
      print("✅ Permission request done");
    }
  } catch (e) {
    print("❌ Permission error: $e");
  }

  // FCM token
  try {
    if (Platform.isIOS) {
      final bool isSimulator =
      Platform.environment.containsKey("SIMULATOR_DEVICE_NAME");
      if (isSimulator) {
        print("⚠️ iOS Simulator → Skipping FCM token");
      } else {
        final token = await FirebaseMessaging.instance.getToken();
        print("📲 iOS device FCM token: $token");
      }
    } else if (Platform.isAndroid) {
      final token = await FirebaseMessaging.instance.getToken();
      print("📲 Android FCM token: $token");
    }
  } catch (e) {
    print("❌ FCM token error: $e");
  }

  print("➡️ Running app...");
  runApp(ArgesulApp());
}


class ArgesulApp extends StatefulWidget {
  @override
  State<ArgesulApp> createState() => _MyAppState();
}

class _MyAppState extends State<ArgesulApp> {
  @override
  void initState() {
    super.initState();
    appTheme.addListener(() {
      setState(() {});
    });
    notifications.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ziarul Argesul',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appTheme.currentTheme(),
      home: const TimelinePage(),
    );
  }
}
