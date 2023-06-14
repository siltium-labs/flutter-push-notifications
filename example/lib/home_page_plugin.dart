//* Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s_push_notifications/s_push_notifications.dart';

class HomePagePlugin extends StatefulWidget {
  const HomePagePlugin({super.key});

  @override
  State<HomePagePlugin> createState() => _HomePagePluginState();
}

class _HomePagePluginState extends State<HomePagePlugin> {
  String _platformVersion = 'Unknown';
  final _sPushNotificationsPlugin = SPushNotifications();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await _sPushNotificationsPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Text('Running on: $_platformVersion\n'),
      ),
    );
  }
}
