import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:s_push_notifications/s_push_notifications_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSPushNotifications platform = MethodChannelSPushNotifications();
  const MethodChannel channel = MethodChannel('s_push_notifications');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
