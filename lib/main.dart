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

  // Request notification permissions
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

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

  // FCM token with proper timing handling
  try {
    if (Platform.isIOS) {
      final bool isSimulator = Platform.environment.containsKey("SIMULATOR_DEVICE_NAME");
      if (isSimulator) {
        print("⚠️ iOS Simulator → Skipping FCM token");
      } else {
        print("📲 iOS device → Getting FCM token...");

        // Add delay to allow APNS token to be set
        await Future.delayed(Duration(seconds: 2));

        String? token;
        int maxRetries = 5;

        for (int i = 0; i < maxRetries; i++) {
          try {
            // Check if APNS token is available first
            String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();

            if (apnsToken != null) {
              print("✅ APNS token available, getting FCM token...");
              token = await FirebaseMessaging.instance.getToken();
              if (token != null) {
                print("📲 iOS device FCM token: $token");
                break; // Success, exit retry loop
              }
            } else {
              print("⏳ APNS token not ready, waiting... (attempt ${i + 1})");
            }

            // Wait before retrying (exponential backoff)
            if (i < maxRetries - 1) {
              await Future.delayed(Duration(seconds: 2 * (i + 1)));
            }

          } catch (e) {
            print("❌ FCM token error (attempt ${i + 1}): $e");
            if (i < maxRetries - 1) {
              await Future.delayed(Duration(seconds: 2 * (i + 1)));
            } else {
              rethrow; // Rethrow on last attempt
            }
          }
        }

        if (token == null) {
          print("❌ Failed to get FCM token after $maxRetries attempts");
        }
      }
    } else if (Platform.isAndroid) {
      final token = await FirebaseMessaging.instance.getToken();
      print("📲 Android FCM token: $token");
    }
  } catch (e) {
    print("❌ FCM token error: $e");
    // Optional: Try again later in the app lifecycle
    print("💡 Will retry FCM token later...");
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
