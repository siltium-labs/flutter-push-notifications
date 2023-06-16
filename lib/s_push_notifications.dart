//* Dart imports
import 'dart:async';

//* Flutter imports
import 'package:flutter/material.dart';

//* Packages imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//* Project imports
import 's_push_notifications_platform_interface.dart';

class SPushNotifications {
  Future<String?> getPlatformVersion() {
    return SPushNotificationsPlatform.instance.getPlatformVersion();
  }
}

class SPushNotify {
  //* INIT FCM, PERMISSIONS FOR IOS & GET DEVICE TOKEN FOR TEST
  init({required FirebaseOptions options}) async {
    // Init Firebase
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: options);
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
  onForegroundNoify(void Function(RemoteMessage)? function) async {
    FirebaseMessaging.onMessage.listen(
      function,
      onError: (error) {},
      onDone: () {},
    );
  }

  //* BACKGROUND AND TERMINATED NOTIFICATION
  //! El metodo que se use para "onBackgroundNotify" tiene que respetar este formato. README
  // @pragma('vm:entry-point')
  // static Future<void> _onBackgroundMessage(RemoteMessage message) async {
  //   debugPrint("-----RECEIVE BACKGROUND/TERMINATED NOTIFY-----");
  //   debugPrint("Title: ${message.notification?.title}");
  //   debugPrint("Body: ${message.notification?.body}");
  //   debugPrint("Payload: ${message.data}");
  //   debugPrint("----------------------------------------------");
  // }

  onBackgroundNotify(Future<void> Function(RemoteMessage) function) {
    FirebaseMessaging.onBackgroundMessage(function);
  }

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
