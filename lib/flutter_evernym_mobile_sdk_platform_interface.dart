import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_evernym_mobile_sdk_method_channel.dart';

abstract class FlutterEvernymMobileSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterEvernymMobileSdkPlatform.
  FlutterEvernymMobileSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterEvernymMobileSdkPlatform _instance = MethodChannelFlutterEvernymMobileSdk();

  /// The default instance of [FlutterEvernymMobileSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterEvernymMobileSdk].
  static FlutterEvernymMobileSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterEvernymMobileSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterEvernymMobileSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
