import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        Navigator.of(context).pushNamed(route);
      }
    });
  }

  static Future<void> displayHeadsUpNotification(RemoteMessage message) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
      'noobdevs',
      'noobdevs channel',
      icon: "@mipmap/ic_launcher",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    ));
    await _notificationsPlugin.show(id, message.notification!.title,
        message.notification!.body, notificationDetails,
        payload: message.data['route']);
  }
}
