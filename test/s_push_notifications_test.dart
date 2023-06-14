import 'package:flutter_test/flutter_test.dart';
import 'package:s_push_notifications/s_push_notifications.dart';
import 'package:s_push_notifications/s_push_notifications_platform_interface.dart';
import 'package:s_push_notifications/s_push_notifications_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSPushNotificationsPlatform
    with MockPlatformInterfaceMixin
    implements SPushNotificationsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SPushNotificationsPlatform initialPlatform = SPushNotificationsPlatform.instance;

  test('$MethodChannelSPushNotifications is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSPushNotifications>());
  });

  test('getPlatformVersion', () async {
    SPushNotifications sPushNotificationsPlugin = SPushNotifications();
    MockSPushNotificationsPlatform fakePlatform = MockSPushNotificationsPlatform();
    SPushNotificationsPlatform.instance = fakePlatform;

    expect(await sPushNotificationsPlugin.getPlatformVersion(), '42');
  });
}
