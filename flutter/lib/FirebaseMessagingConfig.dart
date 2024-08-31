import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingConfig {
  static ValueNotifier<String?> fcmTokenNotifier = ValueNotifier<String?>(null);

  static Future<void> Run() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await requestPermission();
  }

  static Future<void> requestPermission() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    String? token;
    try {
      token = await messaging.getToken();
      fcmTokenNotifier.value = token;
      print('Token: $token');
    } catch (e) {
      token = null;
      fcmTokenNotifier.value = null;
      print('Error getting token: $e');
    }

    if (token != null && token.isNotEmpty) {
      print('Token saved: $token');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received in foreground');

      if (message.notification != null) {
        LocalNotification(
            title: message.notification!.title,
            body: message.notification!.body,
            payload: message.data);
      }

      if (message.data.isNotEmpty) {
        LocalNotification(
            title: message.data['key1'],
            body: message.data['key2'],
            payload: message.data);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: App opened from background');

      if (message.data.isNotEmpty) {
        print('Message data: ${message.data}');
      }

      if (message.notification != null) {
        print(
            'Message notification: ${'${message.notification!.title!} ${message.notification!.body!}'}');
      }
    });

    // Initialize local notifications for Android and iOS
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        if (title != null && title.isNotEmpty) {
          print('Handle the notification received in foreground (iOS)');
        }
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Notification clicked: App is in foreground');
      },
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');

    if (message.data.isNotEmpty) {
      print('Message data: ${message.data}');
    }

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  }

  static Future<void> LocalNotification(
      {String? title, String? body, Map<String, dynamic>? payload}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name',
        channelDescription: 'your_channel_description',
        icon: '@mipmap/ic_launcher',
        playSound: true,
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails(presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    print('LocalNotification');
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: jsonEncode(payload));
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
