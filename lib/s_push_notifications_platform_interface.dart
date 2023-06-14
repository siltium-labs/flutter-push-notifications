import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 's_push_notifications_method_channel.dart';

abstract class SPushNotificationsPlatform extends PlatformInterface {
  /// Constructs a SPushNotificationsPlatform.
  SPushNotificationsPlatform() : super(token: _token);

  static final Object _token = Object();

  static SPushNotificationsPlatform _instance = MethodChannelSPushNotifications();

  /// The default instance of [SPushNotificationsPlatform] to use.
  ///
  /// Defaults to [MethodChannelSPushNotifications].
  static SPushNotificationsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SPushNotificationsPlatform] when
  /// they register themselves.
  static set instance(SPushNotificationsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
