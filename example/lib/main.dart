//* Flutter imports
import 'package:flutter/material.dart';

//* Plugin/Packages import
import 'package:s_push_notifications/s_push_notifications.dart';

//* Project imports
import 'package:s_push_notifications_example/home_page.dart';

//* Firebase Options import
import 'firebase_options.dart';

Future<void> main() async {
  // Init del plugin
  await SPushNotify().initSPN(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request permissions for iOS
  SPushNotify().permissionSPN();

  // Get device token
  final fcmToken = await SPushNotify().getTokenSPN();
  debugPrint("TOKEN: $fcmToken");

  // Init for notifications
  SPushNotify().initInfoSPN();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Push Notifications - Siltium',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
