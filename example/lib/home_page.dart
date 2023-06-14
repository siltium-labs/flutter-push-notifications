//* Flutter imports
import 'package:flutter/material.dart';
import 'package:s_push_notifications/s_push_notifications.dart';
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
    SPushNotify().onTapNotify((message) => _navigate());
  }

  _navigate() {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => const NotificationPage()),
      ),
    );
  }
}
