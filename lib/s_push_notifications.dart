//* Dart imports
import 'dart:async';

//* Flutter imports
import 'package:flutter/material.dart';

//* Packages imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//* Project imports
import 's_push_notifications_platform_interface.dart';

class SPushNotifications {
  Future<String?> getPlatformVersion() {
    return SPushNotificationsPlatform.instance.getPlatformVersion();
  }
}

class SPushNotify {
  //INIT FCM, PERMISSIONS FOR IOS & GET DEVICE TOKEN FOR TEST
  initSPN({
    required FirebaseOptions options,
    required Function(NotificationResponse?) function,
  }) async {
    // Init Firebase
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: options);
    // Init Notifications
    _onForegroundMessages(function: function);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessages);
  }

  // For iOS
  permissionSPN() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  // For test with Firebase console
  Future<String?> getTokenSPN() async {
    return await FirebaseMessaging.instance.getToken();
  }

  // FOREGROUND NOTIFICATION
  _onForegroundMessages({required Function(NotificationResponse?) function}) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id del canal en AndroidManifest.xml
      'High Importance Notifications',
      description: 'This channel is used for foreground notifications.',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // onReceive (Foreground)
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
            ),
          ),
        );
      }
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // onTap (Foreground)
    var androidInit =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iOSInit = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            function(notificationResponse);
            break;
          case NotificationResponseType.selectedNotificationAction:
            // todo
            // if (notificationResponse.actionId == navigationActionId) {
            //   selectNotificationStream.add(notificationResponse.payload);
            // }
            break;
        }
      },
    );

    final platform =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(channel);
  }

  // BACKGROUND AND TERMINATED NOTIFICATION
  // onReceive (Background & Terminated)
  @pragma('vm:entry-point')
  static Future<void> _onBackgroundMessages(RemoteMessage message) async {
    debugPrint("Handling a background message: ${message.messageId}");
  }

  // onTap (Background & Terminated)
  onTapNotify(void Function(RemoteMessage)? function) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (function != null && initialMessage != null) {
      function(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(
      function,
      onError: (error) {},
      onDone: () {},
    );
  }
}
