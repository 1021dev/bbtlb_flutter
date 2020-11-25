import UIKit
import Flutter
import UserNotificationsUI
import flutter_local_notifications
import GoogleMaps
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCAYuONUEZr-sGesqKLV1QAzeGyY6nsm3Q")
      GeneratedPluginRegistrant.register(with: self)
    if (!(UserDefaults.standard.object(forKey: "notification") != nil)) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UserDefaults.standard.set(true, forKey: "notification")
    }
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // This method will be called when app received push notifications in foreground
  override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
  {
      completionHandler([.alert, .badge, .sound])
  }
  
  //    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  //        Messaging.messaging().apnsToken = deviceToken
  //    }
}
