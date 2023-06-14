import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 's_push_notifications_platform_interface.dart';

/// An implementation of [SPushNotificationsPlatform] that uses method channels.
class MethodChannelSPushNotifications extends SPushNotificationsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('s_push_notifications');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
