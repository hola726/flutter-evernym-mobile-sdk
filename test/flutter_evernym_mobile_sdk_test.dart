import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_evernym_mobile_sdk/flutter_evernym_mobile_sdk.dart';
import 'package:flutter_evernym_mobile_sdk/flutter_evernym_mobile_sdk_platform_interface.dart';
import 'package:flutter_evernym_mobile_sdk/flutter_evernym_mobile_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterEvernymMobileSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterEvernymMobileSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterEvernymMobileSdkPlatform initialPlatform = FlutterEvernymMobileSdkPlatform.instance;

  test('$MethodChannelFlutterEvernymMobileSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterEvernymMobileSdk>());
  });

  test('getPlatformVersion', () async {
    FlutterEvernymMobileSdk flutterEvernymMobileSdkPlugin = FlutterEvernymMobileSdk();
    MockFlutterEvernymMobileSdkPlatform fakePlatform = MockFlutterEvernymMobileSdkPlatform();
    FlutterEvernymMobileSdkPlatform.instance = fakePlatform;

    expect(await flutterEvernymMobileSdkPlugin.getPlatformVersion(), '42');
  });
}
