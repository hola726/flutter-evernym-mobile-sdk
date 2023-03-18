import 'package:flutter/services.dart';

class Utils {
  Utils(this._channel);

  final MethodChannel _channel;

  Future<void> storagePermission() async {
    await _channel.invokeMethod('storagePermissions');
  }

  Future<void> writeGenesisFile({
    required String genesisJson,
  }) async {
    await _channel.invokeMethod(
      'writeGenesisFile',
      {
        "genesisJson": genesisJson,
      },
    );
  }
}
