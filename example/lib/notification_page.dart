//* Flutter imports
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S-Push Notify - Siltium'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _navigate(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 30,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Notification Page',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  // CONTROLLER --------------------------------------------------
  _navigate() {
    // return Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: ((context) => const HomePage()),
    //   ),
    // );
    return Navigator.pop(context);
  }
}
