import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_evernym_mobile_sdk_platform_interface.dart';

/// An implementation of [FlutterEvernymMobileSdkPlatform] that uses method channels.
class MethodChannelFlutterEvernymMobileSdk extends FlutterEvernymMobileSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_evernym_mobile_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
