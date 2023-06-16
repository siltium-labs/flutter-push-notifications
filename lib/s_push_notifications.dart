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
  //* VARIABLES
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel _andoridChannel =
      const AndroidNotificationChannel(
    'high_importance_channel', // id del canal en AndroidManifest.xml
    'High Importance Notifications',
    description: 'This channel is used for foreground notifications.',
    importance: Importance.max,
    // "Importance.max" muestra la notificacion en pantalla y vibra.
    // "Importance.defaultImportance" solo vibra y deja una notificacion en la barra de arriba sin mostrarla en pantalla.
  );

  //* INIT FCM, PERMISSIONS FOR IOS & GET DEVICE TOKEN FOR TEST
  init({required FirebaseOptions options}) async {
    // Init Firebase
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: options);
    // Init Notifications
    _onForegroundMessages();
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessages);
  }

  // For iOS
  requestPermission() async {
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
  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  //* FOREGROUND NOTIFICATION
  _onForegroundMessages() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_andoridChannel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      String? newPayload = message.data.toString();

      // TODO: OnReceiveForegroundNotify
      // DEBUG: REMOVE
      debugPrint("-----RECEIVE FOREGROUND NOTIFY-----");
      debugPrint("Title: ${message.notification?.title}");
      debugPrint("Body: ${message.notification?.body}");
      debugPrint("Payload: ${message.data}");
      debugPrint("----------------------------------------------");

      // onReceive (Foreground)
      if (notification != null && android != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          payload: newPayload,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _andoridChannel.id,
              _andoridChannel.name,
              channelDescription: _andoridChannel.description,
              icon: android.smallIcon,
            ),
          ),
        );
      }
    });

    // For iOS Foreground Notifications
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // onTap (Foreground) -> Se llama en el HomePage de la app para manejar las notificaciones
  onTapForegroundNotify({
    required Function(NotificationResponse?) function,
  }) async {
    var androidInit =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iOSInit = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            function(notificationResponse);
            break;
          default:
            break;
          // case NotificationResponseType.selectedNotificationAction:
          //   if (notificationResponse.actionId == navigationActionId) {
          //     selectNotificationStream.add(notificationResponse.payload);
          //   }
          //   break;
        }
      },
    );

    final platform =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_andoridChannel);
  }

  //* BACKGROUND AND TERMINATED NOTIFICATION
  // onReceive (Background & Terminated)
  @pragma('vm:entry-point')
  static Future<void> _onBackgroundMessages(RemoteMessage message) async {
    // TODO: OnReceiveBackgroundNotify
    // DEBUG: REMOVE
    debugPrint("-----RECEIVE BACKGROUND/TERMINATED NOTIFY-----");
    debugPrint("Title: ${message.notification?.title}");
    debugPrint("Body: ${message.notification?.body}");
    debugPrint("Payload: ${message.data}");
    debugPrint("----------------------------------------------");
  }

  // onTap (Background & Terminated) -> Se llama en el HomePage de la app para manejar las notificaciones
  onTapBackgroundNotify(void Function(RemoteMessage)? function) async {
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
