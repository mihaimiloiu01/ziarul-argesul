/*import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let notificationChannel = FlutterMethodChannel(name: "ro.ziarulargesul.mobile/browser",
                                                  binaryMessenger: controller.binaryMessenger)

    notificationChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "openNotificationSettings" {
        self.openNotificationSettings(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func openNotificationSettings(result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(settingsUrl)
        result(nil)
      } else {
        result(FlutterError(code: "UNAVAILABLE",
                           message: "Could not open settings",
                           details: nil))
      }
    }
  }
}*/

import UIKit
import Flutter
import Firebase
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Initialize Firebase
    guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
      fatalError("GoogleService-Info.plist not found")
    }
    guard let options = FirebaseOptions(contentsOfFile: path) else {
      fatalError("Invalid GoogleService-Info.plist")
    }
    FirebaseApp.configure(options: options)

    // Setup notifications
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { granted, error in
          print("Notification permission granted: \(granted)")
          if let error = error {
            print("Notification permission error: \(error)")
          }
        }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }

    application.registerForRemoteNotifications()

    // Set messaging delegate
    Messaging.messaging().delegate = self

    GeneratedPluginRegistrant.register(with: self)

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let notificationChannel = FlutterMethodChannel(name: "ro.ziarulargesul.mobile/browser",
                                                  binaryMessenger: controller.binaryMessenger)

    notificationChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "openNotificationSettings" {
        self.openNotificationSettings(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func openNotificationSettings(result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(settingsUrl)
        result(nil)
      } else {
        result(FlutterError(code: "UNAVAILABLE",
                           message: "Could not open settings",
                           details: nil))
      }
    }
  }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")

    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
  }
}

// MARK: - UNUserNotificationCenterDelegate
// Note: Removed redundant protocol conformance since FlutterAppDelegate already conforms
extension AppDelegate {
  // Receive displayed notifications for iOS 10 devices.
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
    let userInfo = notification.request.content.userInfo

    // Print message ID.
    if let messageID = userInfo["gcm.message_id"] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    // Print message ID.
    if let messageID = userInfo["gcm.message_id"] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}