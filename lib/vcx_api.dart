import 'package:flutter/services.dart';

class VcxApi {
  VcxApi(this._channel);

  final MethodChannel _channel;

  Future<void> vcxInitPool({
    required String poolConfig,
  }) async {
    return await _channel.invokeMethod(
      'vcxInitPool',
      {
        "poolConfig": poolConfig,
      },
    );
  }

  Future<void> initLibrary({
    required String configJson,
  }) async {
    await _channel.invokeMethod(
      'initLibrary',
      {
        "configJson": configJson,
      },
    );
  }
}
