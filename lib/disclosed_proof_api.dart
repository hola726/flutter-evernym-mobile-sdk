import 'package:flutter/services.dart';

class DisclosedProofApi {
  DisclosedProofApi(this._channel);
  final MethodChannel _channel;

  Future<int> proofCreateWithRequest({
    required String sourceId,
    required String message,
  }) async {
    return await _channel.invokeMethod(
      'proofCreateWithRequest',
      {
        "sourceId": sourceId,
        "message": message,
      },
    );
  }

  Future<String> proofSerialize({
    required int proofHandle,
  }) async {
    return await _channel.invokeMethod(
      'proofSerialize',
      {
        "proofHandle": proofHandle,
      },
    );
  }

  Future<int> proofDeserialize({
    required String serializedProof,
  }) async {
    return await _channel.invokeMethod(
      'proofDeserialize',
      {
        "serializedProof": serializedProof,
      },
    );
  }

  Future<String> proofRetrieveCredentials({
    required int proofHandle,
  }) async {
    return await _channel.invokeMethod(
      'proofRetrieveCredentials',
      {
        "proofHandle": proofHandle,
      },
    );
  }

  Future<void> proofGenerate({
    required int proofHandle,
    required String selectedCreds,
    required String selfAttestedAttributes,
  }) async {
    return await _channel.invokeMethod(
      'proofGenerate',
      {
        "proofHandle": proofHandle,
        "selectedCreds": selectedCreds,
        "selfAttestedAttributes": selfAttestedAttributes,
      },
    );
  }

  Future<void> proofSend({
    required int proofHandle,
    required int connectionHandle,
  }) async {
    return await _channel.invokeMethod(
      'proofSend',
      {
        "proofHandle": proofHandle,
        "connectionHandle": connectionHandle,
      },
    );
  }
}
