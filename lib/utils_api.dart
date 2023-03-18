import 'package:flutter/services.dart';

class UtilsApi {
  UtilsApi(this._channel);

  final MethodChannel _channel;

  Future<String> setCloudAgentProvisioning({
    required String token,
    required String config,
  }) async {
    return await _channel.invokeMethod(
      'setCloudAgentProvisioning',
      {
        "token": token,
        "config": config,
      },
    );
  }

  Future<String> getExtractAttachedMessage({
    required String invite,
  }) async {
    return await _channel.invokeMethod(
      'getExtractAttachedMessage',
      {
        "invite": invite,
      },
    );
  }

  Future<String> getResolveMessageByUrl({
    required String invite,
  }) async {
    return await _channel.invokeMethod(
      'getResolveMessageByUrl',
      {
        "invite": invite,
      },
    );
  }

  Future<String> vcxGetMessages({
    required String MessageStatusType,
  }) async {
    return await _channel.invokeMethod(
      'vcxGetMessages',
      {
        "MessageStatusType": MessageStatusType,
      },
    );
  }

  Future<void> vcxUpdateMessages({
    required String messageStatusType,
    required String messagesToUpdate,
  }) async {
    return await _channel.invokeMethod(
      'vcxUpdateMessages',
      {
        "messageStatusType": messageStatusType,
        "messagesToUpdate": messagesToUpdate,
      },
    );
  }

  Future<void> vcxFetchPublicEntities() async {
    await _channel.invokeMethod('vcxFetchPublicEntities');
  }
}
