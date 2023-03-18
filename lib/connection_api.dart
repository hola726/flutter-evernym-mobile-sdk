import 'package:flutter/services.dart';

class ConnectionApi {
  ConnectionApi(this._channel);
  final MethodChannel _channel;

  Future<int> createConnectionWithOutofbandInvite({
    required String invitationId,
    required String invitationDetails,
  }) async {
    return await _channel.invokeMethod(
      'createConnectionWithOutofbandInvite',
      {
        "invitationDetails": invitationDetails,
        "invitationId": invitationId,
      },
    );
  }

  Future<String> getConnectionConnect({
    required int connectionHandle,
  }) async {
    return await _channel.invokeMethod(
      'getConnectionConnect',
      {
        "connectionHandle": connectionHandle,
      },
    );
  }

  Future<String> connectionSerialize({
    required int connectionHandle,
  }) async {
    return await _channel.invokeMethod(
      'connectionSerialize',
      {
        "connectionHandle": connectionHandle,
      },
    );
  }

  Future<int> connectionDeserialize({
    required String? connectionData,
  }) async {
    return await _channel.invokeMethod(
      'connectionDeserialize',
      {
        "connectionData": connectionData,
      },
    );
  }

  Future<String> connectionGetPwDid({
    required int connectionHandle,
  }) async {
    return await _channel.invokeMethod(
      'connectionGetPwDid',
      {
        "connectionHandle": connectionHandle,
      },
    );
  }

  Future<int> vcxConnectionUpdateStateWithMessage({
    required int handle,
    required String? payload,
  }) async {
    return await _channel.invokeMethod(
      'vcxConnectionUpdateStateWithMessage',
      {
        "handle": handle,
        "payload": payload,
      },
    );
  }

  Future<String> connectionInviteDetails({
    required int handle,
  }) async {
    return await _channel.invokeMethod(
      'connectionInviteDetails',
      {
        "handle": handle,
      },
    );
  }

  Future<int> connectionRelease({
    required int handle,
  }) async {
    return await _channel.invokeMethod(
      'connectionRelease',
      {
        "handle": handle,
      },
    );
  }

  Future<void> connectionSendReuse({
    required int handle,
    required String invitation,
  }) async {
    return await _channel.invokeMethod(
      'connectionSendReuse',
      {
        "handle": handle,
        "invitation": invitation,
      },
    );
  }
}
