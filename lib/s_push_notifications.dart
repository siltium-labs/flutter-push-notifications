//* Flutter imports
import 'dart:async';

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
  //! Init FCM, getToken & Permissions
  initSPN({
    required FirebaseOptions options,
    required Function(NotificationResponse?) function,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: options);
    // Habilitar recibir notificaciones en fore, back y terminated
    _onForegroundMessages(function: function);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessages);
  }

  // Para iOS
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

  Future<String?> getTokenSPN() async {
    return await FirebaseMessaging.instance.getToken();
  }

  //! Foreground Notify
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

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
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

    // onTap Foreground
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
            // selectNotificationStream.add(notificationResponse.payload);
            // debugPrint("TAP ON FORE");
            break;
          case NotificationResponseType.selectedNotificationAction:
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

  //! Background Notify
  @pragma('vm:entry-point')
  static Future<void> _onBackgroundMessages(RemoteMessage message) async {
    // Cuando la aplicación está abierta, pero en segundo plano (minimizada).
    debugPrint("Handling a background message: ${message.messageId}");
  }

  //! onTap Notify (Background & Terminated)
  onTapNotify(void Function(RemoteMessage)? function) async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (function != null && initialMessage != null) {
      function(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(
      function,
      onError: (error) {},
      onDone: () {},
    );
  }
}
