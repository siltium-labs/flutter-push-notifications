//* Flutter imports
import 'package:flutter/material.dart';

//* Plugin/Packages imports
import 'package:s_push_notifications/s_push_notifications.dart';

//* Project imports
import 'package:s_push_notifications_example/notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S-Push Notify - Siltium'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Home Page',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _navigate(),
            child: const Text("Navegar a Notify"),
          )
        ],
      ),
    );
  }

  // CONTROLLER --------------------------------------------------
  @override
  void initState() {
    super.initState();
    _onReceiveForegroundNotify();
    _onReceiveBackgroundNotify();
    _onTapBackgroundNotify();
  }

  _navigate() {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => const NotificationPage()),
      ),
    );
  }

  _onReceiveForegroundNotify() async {
    await SPushNotify().onForegroundNoify(
      (message) {
        debugPrint("-----RECEIVE FOREGROUND NOTIFY-----");
        debugPrint("Title: ${message.notification?.title}");
        debugPrint("Body: ${message.notification?.body}");
        debugPrint("Payload: ${message.data}");
        debugPrint("----------------------------------------------");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Notify: ${message.notification?.title}")));
      },
    );
  }

  _onReceiveBackgroundNotify() async {
    await SPushNotify().onBackgroundNotify(_onBackgroundMessage);
  }

  _onTapBackgroundNotify() async {
    await SPushNotify().onTapBackgroundNotify(
      (message) {
        debugPrint("-----ONTAP BACKGROUND/TERMINATED NOTIFY-----");
        debugPrint("Title: ${message.notification?.title}");
        debugPrint("Body: ${message.notification?.body}");
        debugPrint("Payload: ${message.data}");
        debugPrint("----------------------------------------------");
        _navigate();
      },
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _onBackgroundMessage(message) async {
    debugPrint("-----RECEIVE BACKGROUND/TERMINATED NOTIFY-----");
    debugPrint("Title: ${message.notification?.title}");
    debugPrint("Body: ${message.notification?.body}");
    debugPrint("Payload: ${message.data}");
    debugPrint("----------------------------------------------");
  }
}
