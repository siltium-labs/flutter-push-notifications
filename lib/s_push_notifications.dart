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
  static Future<void> _onBackgroundMessages(RemoteMessage message) async {
    // Cuando la aplicación está abierta, pero en segundo plano (minimizada).
    // await Firebase.initializeApp();
    debugPrint("Handling a background message: ${message.messageId}");
  }

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initSPN({required FirebaseOptions options}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: options);
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessages);
  }

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
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken;
  }

  initInfoSPN() {
    var androidInit =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iOSInit = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        try {
          if (notificationResponse.payload != null &&
              notificationResponse.payload!.isNotEmpty) {
            debugPrint(notificationResponse.payload);
          } else {
            // else
          }
        } catch (e) {
          // catch
        }
      },
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );
    //
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("..........onMesagge..........");
      debugPrint(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: false,
      );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(),
      );
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data["body"],
      );
    });
  }

  @pragma('vm:entry-point')
  static _notificationTapBackground(NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }

//----------------------------------------------------------------

  // onForegroundMessages(Function? onForegroundNotify) {
  //   // Cuando la aplicación está abierta, a la vista y en uso.
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     debugPrint(
  //         'Message: ${message.notification?.title ?? "New Notification"}');
  //     onForegroundNotify;
  //   });
  // }
}
