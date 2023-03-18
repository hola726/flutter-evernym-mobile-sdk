import 'package:flutter/services.dart';

import 'connection_api.dart';
import 'credential_api.dart';
import 'disclosed_proof_api.dart';
import 'utils.dart';
import 'utils_api.dart';
import 'vcx_api.dart';

class EvernymSdk {
  static late EvernymSdk _singleton;

  factory EvernymSdk() => _singleton;
  factory EvernymSdk.init() {
    _singleton = EvernymSdk._internal();
    return _singleton;
  }

  EvernymSdk._internal();
  final MethodChannel _channel = const MethodChannel('evernym');
  late final ConnectionApi _connectionApi = ConnectionApi(_channel);
  late final CredentialApi _credentialApi = CredentialApi(_channel);
  late final DisclosedProofApi _disclosedProofApi = DisclosedProofApi(_channel);
  late final UtilsApi _utilsApi = UtilsApi(_channel);
  late final VcxApi _vcxApi = VcxApi(_channel);
  late final Utils _utils = Utils(_channel);

  ConnectionApi get connectionApi => _connectionApi;
  CredentialApi get credentialApi => _credentialApi;
  DisclosedProofApi get disclosedProofApi => _disclosedProofApi;
  UtilsApi get utilsApi => _utilsApi;
  VcxApi get vcxApi => _vcxApi;
  Utils get utils => _utils;
}
