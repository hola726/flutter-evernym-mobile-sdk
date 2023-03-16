
import 'flutter_evernym_mobile_sdk_platform_interface.dart';

class FlutterEvernymMobileSdk {
  Future<String?> getPlatformVersion() {
    return FlutterEvernymMobileSdkPlatform.instance.getPlatformVersion();
  }
}
