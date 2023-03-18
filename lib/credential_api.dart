import 'package:flutter/services.dart';

class CredentialApi {
  CredentialApi(this._channel);
  final MethodChannel _channel;

  Future<int> credentialCreateWithOffer({
    required String sourceId,
    required String message,
  }) async {
    return await _channel.invokeMethod(
      'credentialCreateWithOffer',
      {
        "sourceId": sourceId,
        "message": message,
      },
    );
  }

  Future<String> credentialSerialize({
    required int credentialHandle,
  }) async {
    return await _channel.invokeMethod(
      'credentialSerialize',
      {
        "credentialHandle": credentialHandle,
      },
    );
  }

  Future<int> credentialDeserialize({
    required String serializedCredOffer,
  }) async {
    return await _channel.invokeMethod(
      'credentialDeserialize',
      {
        "serializedCredOffer": serializedCredOffer,
      },
    );
  }

  Future<void> deleteCredential({
    required int credHandle,
  }) async {
    return await _channel.invokeMethod(
      'deleteCredential',
      {
        "credHandle": credHandle,
      },
    );
  }

  Future<void> credentialSendRequest({
    required int credHandle,
    required int conHandle,
  }) async {
    return await _channel.invokeMethod(
      'credentialSendRequest',
      {
        "credHandle": credHandle,
        "conHandle": conHandle,
      },
    );
  }

  Future<int> credentialUpdateStateWithMessage({
    required int handle,
    required String? payload,
  }) async {
    return await _channel.invokeMethod(
      'credentialUpdateStateWithMessage',
      {
        "handle": handle,
        "payload": payload,
      },
    );
  }
}
