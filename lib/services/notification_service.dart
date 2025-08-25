import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // TODO: Initialize FCM and local notifications
  }

  Future<void> sendPushNotification(String title, String body) async {
    // TODO: Send push notification
  }

  Future<void> showLocalNotification(String title, String body) async {
    // TODO: Show local notification
  }
}