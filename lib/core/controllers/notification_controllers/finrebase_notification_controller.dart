import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/controllers/notification_controllers/local_notification_controller.dart';

class NotificationController {
  final _firebaseMessaging = FirebaseMessaging.instance;

  handelMessage(RemoteMessage? message) {
    if (message == null) return;
    debugPrint("This is inside create notification in handelMessage \n ");
    LocalNotificationController().createLocalNotification(
        title: message.notification?.title ?? "Test",
        body: message.notification?.body ?? "Hello");
  }

  initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen(handelMessage);
    await handelTerminatedStatus();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("App opened from terminated state");
      LocalNotificationController().createLocalNotification(
        title: message.notification?.title ?? "Test",
        body: message.notification?.body ?? "Hello",
      );
    });
    FirebaseMessaging.onBackgroundMessage(handelBackgroundNotification);
  }

  Future initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    debugPrint("This is FCM Token: >>>> $fcmToken");
    initPushNotification();
  }

  handelTerminatedStatus() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handelMessage(initialMessage);
    }
  }

  Future handelBackgroundNotification(RemoteMessage message) async {
    debugPrint(
        "This is inside create notification in handelBackgroundNotification \n ");
    // await Firebase.initializeApp();
    // debugPrint("Title: ${message.notification?.title}");
    // debugPrint("Body: ${message.notification?.body}");
    // debugPrint("Payload: ${message.data}");
    // LocalNotificationController().createLocalNotification(title: message.notification?.title ?? "Test", body: message.notification?.body ?? "Hello");
  }

  Future disposeNotification() async {
    await _firebaseMessaging.deleteToken();
  }
}
