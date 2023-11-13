import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void notificationService() {
  var notificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = const AndroidInitializationSettings('launch_background');
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  notificationsPlugin.initialize(
    initializationSettings,
  );

  var androidPlatformChannelInfo = const AndroidNotificationDetails(
      'kanjouNotifications',
      'Kanjou - Notifications',
      channelDescription: 'Notifications for Kanjou',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker'
  );
  NotificationDetails notificationDetails = NotificationDetails(android: androidPlatformChannelInfo);

  notificationsPlugin.periodicallyShow(
      1, // unique if you want to delete this scheduled notification
      'Kanjou Notetaking',
      "We've missed you! It's been a while since you last used [Your App Name]. Don't forget to check out your notes and stay organized. We're here whenever you need us!",
      RepeatInterval.weekly,
      notificationDetails
  );
}