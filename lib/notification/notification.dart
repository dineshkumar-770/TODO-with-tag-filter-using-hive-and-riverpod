import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class Notify {
  static Future instantNotify() async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    var status = await Permission.notification.request();
    if (status.isGranted) {
      return awesomeNotifications.createNotification(
          actionButtons: [
            NotificationActionButton(
                key: 'instant_notification',
                label: 'OK',
                actionType: ActionType.DismissAction,
                showInCompactView: true)
          ],
          content: NotificationContent(
              id: Random().nextInt(100),
              
              displayOnBackground: true,
              displayOnForeground: true,
              payload: {
                'nagivate':'/third'
              },
              channelKey: 'instant_notification',
              body: 'A gentle reminder for testing in Notification Body',
              title: 'ToDo App'));
    } else {
      throw ('Permission restricted');
    }
  }
}
