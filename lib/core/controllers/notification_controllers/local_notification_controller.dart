import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/resources/styles.dart';

//PR
class LocalNotificationController {
  initLocalNotification() {
    AwesomeNotifications().initialize(
      'resource://drawable/launcher_icon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic_Notifications',
          defaultColor: orangeColor,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          channelDescription: "Food Notification",
        ),
      ],
    );
  }

  Future<void> createLocalNotification(
      {required String title, required String body}) async {
    debugPrint("This is inside create notification in local\n ");
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: title,
        body: body,
        // bigPicture: 'asset://assets/notification_map.png',
        // notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}
