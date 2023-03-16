import Flutter
import UIKit
import vcx

enum ErrorMessage: Error {
    case outOfRange(from: Int)
    case failToSetGenesisPath
    case failToWriteGenesisFile
    case failToJsonCreate
    case notExistDirectoryPath
    case notExistJson
}

public class FlutterEvernymMobileSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {

    let channel = FlutterMethodChannel(name: "evernym", binaryMessenger: registrar.messenger())
    let instance = FlutterEvernymMobileSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

      private func isError(error:Error?) -> Bool{
          let notErrorCode = "Code=0"
          let alreadyInit = "Code=1044"

          if(error == nil){
              return false
          }

          return !(error.debugDescription.contains(notErrorCode) || error.debugDescription.contains(alreadyInit))

      }

          private func setGenesisPath(config:String) throws -> String{
              var dicData : Dictionary<String, Any> = [String : Any]()
              dicData = try JSONSerialization.jsonObject(with: Data(config.utf8), options: []) as! [String:Any]

              let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first

              if(directoryPath == nil){
                  throw ErrorMessage.notExistDirectoryPath
              }

              let filePath = (directoryPath! as NSString).appendingPathComponent("pool_transactions_genesis")

              dicData["genesis_path"] = filePath
              var jsonObj : String?
              let jsonCreate:Data
              do{
                  jsonCreate = try JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
              }catch{
                  throw ErrorMessage.failToJsonCreate
              }

              jsonObj = String(data: jsonCreate, encoding: .utf8)

              if(jsonObj == nil || jsonObj == ""){
                  throw ErrorMessage.notExistJson
              }

              return jsonObj!
          }

          private func writeGenesisFile(genesis:String) throws -> Void{

              let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first


              if(directoryPath == nil){
                  throw ErrorMessage.notExistDirectoryPath
              }

              let filePath = (directoryPath! as NSString).appendingPathComponent("pool_transactions_genesis")

              let fileManager = FileManager.default

              if(!fileManager.fileExists(atPath: filePath)){
                  do{
                      try genesis.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
                  }catch{
                      throw ErrorMessage.failToWriteGenesisFile
                  }
              }
          }

          private func handleError(error:Error,name: String,description: String) -> FlutterError{

              switch error{
              case ErrorMessage.notExistJson:
                  return FlutterError(code: "Error",
                                      message: name + ": not exist json",
                                      details: nil)
              case ErrorMessage.notExistDirectoryPath:
                  return FlutterError(code: "Error",
                                      message: name + ": not exist directoryPath",
                                      details: nil)
              case ErrorMessage.failToWriteGenesisFile:
                  return FlutterError(code: "Error",
                                      message: name + ": fail to write genesis file",
                                      details: nil)
              case ErrorMessage.failToSetGenesisPath:
                  return FlutterError(code: "Error",
                                      message: name + ": fail to set genesis path",
                                      details: nil)
              case ErrorMessage.failToJsonCreate:
                  return FlutterError(code: "Error",
                                      message: name + ": fail to json create",
                                      details: nil)
              default:
                  return FlutterError(code: "Error",
                                      message: name + ": " + description,
                                      details: nil)
              }

          }



    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)  {
        let arguments = call.arguments as? [String: Any?]
        let sdk = ConnectMeVcx.init()

        if(call.method == "getPlatformVersion") {
            result("iOS " + UIDevice.current.systemVersion)
            return

        }

        if(call.method == "setCloudAgentProvisioning") {
            let token = arguments?["token"] as? String
            let config = arguments?["config"] as? String
            let handleConfig: String
            do{
                handleConfig = try self.setGenesisPath(config: config!)
            }catch{
                result(self.handleError(error: error, name: "setCloudAgentProvisioning", description: "fail to set genesis path"))
                return
            }

            sdk.agentProvision(withTokenAsync: handleConfig, token: token) { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "setCloudAgentProvisioning : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)
            }
            return
        }

        if(call.method == "getExtractAttachedMessage") {
            let invite = arguments?["invite"] as? String

            sdk.extractAttachedMessage(invite, completion: { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "getExtractAttachedMessage : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)

            })
            return
        }

        if(call.method == "getResolveMessageByUrl") {
            let invite = arguments?["invite"] as? String

            sdk.resolveMessage(byUrl: invite, completion: { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "getResolveMessageByUrl : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)

            })
            return
        }

        if(call.method == "createConnectionWithOutofbandInvite") {
            let invitationDetails = arguments?["invitationDetails"] as? String
            let invitationId = arguments?["invitationId"] as? String

            sdk.connectionCreate(withOutofbandInvite: invitationId, invite: invitationDetails, completion:{ error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "createConnectionWithOutofbandInvite : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)

            })
            return
        }
        // 연결 초대 수락
        if(call.method == "getConnectionConnect") {
            let connectionHandle = arguments?["connectionHandle"] as? Int


            sdk.connectionConnect(Int32(truncatingIfNeeded: connectionHandle!)
                                  , connectionType: "{}", completion: { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "getConnectionConnect : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)

            })
            return
        }

        // 연결 직렬화
        if(call.method == "connectionSerialize") {
            let connectionHandle = arguments?["connectionHandle"] as? Int

            sdk.connectionSerialize(connectionHandle!, completion: { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "connectionSerialize : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)

            })
            return
        }

        // offer으로 자격증 생성
        if(call.method == "credentialCreateWithOffer") {
            let sourceId = arguments?["sourceId"] as? String
            let message = arguments?["message"] as? String

            sdk.credentialCreate(withOffer: sourceId, offer: message, completion: { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "credentialCreateWithOffer : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)

            })
            return
        }

        // 자격증 직렬화
        if(call.method == "credentialSerialize") {
            let credentialHandle = arguments?["credentialHandle"] as? Int

            sdk.credentialSerialize(credentialHandle!, completion: { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "credentialSerialize : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)

            })
            return
        }

        // 연결 개체 직렬화
        if(call.method == "connectionDeserialize") {
            let connectionData = arguments?["connectionData"] as? String

            sdk.connectionDeserialize(connectionData, completion: { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "connectionDeserialize : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)

            })
            return
        }

        // 연결에서 pwDid 추출
        if(call.method == "connectionGetPwDid") {
            let connectionHandle = arguments?["connectionHandle"] as? Int

            sdk.connectionGetPwDid(Int32(truncatingIfNeeded: connectionHandle!), withCompletion: { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "connectionGetPwDid : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)

            })
            return
        }

        if(call.method == "credentialDeserialize") {
            let serializedCredOffer = arguments?["serializedCredOffer"] as? String

            sdk.credentialDeserialize(serializedCredOffer, completion: { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "credentialDeserialize : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)

            })
            return
        }

        if(call.method == "deleteCredential") {
            let credHandle = arguments?["credHandle"] as? Int

            sdk.deleteCredential(credHandle!, completion: { error in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "deleteCredential : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result("")

            })
            return
        }

        if(call.method == "credentialSendRequest") {
            let credHandle = arguments?["credHandle"] as? Int
            let conHandle = arguments?["conHandle"] as? Int

            sdk.credentialSendRequest(credHandle!, connectionHandle:Int32(truncatingIfNeeded: conHandle!), paymentHandle: 0, completion: { error in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "credentialSendRequest : "+error.debugDescription,
                                        details: nil))

                    return
                }
                result("")

            })
            return
        }

        if(call.method == "vcxGetMessages") {
            let MessageStatusType = arguments?["MessageStatusType"] as? String

            sdk.downloadMessages(MessageStatusType, uid_s: nil, pwdids: nil, completion: { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "vcxGetMessages : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)
            })
            return
        }

        if(call.method == "vcxConnectionUpdateStateWithMessage") {
            let handle = arguments?["handle"] as? Int
            let payload = arguments?["payload"] as? String


            sdk.connectionUpdateState(withMessage: Int32(truncatingIfNeeded: handle!), message: payload, withCompletion: { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "vcxConnectionUpdateStateWithMessage : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)
            })
            return
        }

        if(call.method == "vcxUpdateMessages") {
            let messageStatusType = arguments?["messageStatusType"] as? String
            let messagesToUpdate = arguments?["messagesToUpdate"] as? String

            sdk.updateMessages(messageStatusType, pwdidsJson: messagesToUpdate, completion: { error in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "vcxUpdateMessages : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result("")
            })
            return
        }

        if(call.method == "credentialUpdateStateWithMessage") {
            let handle = arguments?["handle"] as? Int
            let payload = arguments?["payload"] as? String


            sdk.credentialUpdateState(withMessage: Int32(truncatingIfNeeded: handle!), message: payload, withCompletion: { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "credentialUpdateStateWithMessage : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)
            })
            return
        }

        if(call.method == "vcxFetchPublicEntities") {
            sdk.fetchPublicEntities({ error in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "vcxFetchPublicEntities : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result("")
            })
            return
        }

        if(call.method == "vcxInitPool") {
            let poolConfig = arguments?["poolConfig"] as? String

            sdk.initPool(poolConfig, completion: { error in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "vcxInitPool : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result("")
            })
            return
        }

        // 자격 증명 상태 개체 만들기
        if(call.method == "writeGenesisFile") {
            let genesisJson = arguments?["genesisJson"] as? String
            do{
                try self.writeGenesisFile(genesis: genesisJson!)
            }catch{
                result(self.handleError(error: error, name: "writeGenesisFile", description: "fail to write genesis file"))
                return
            }
            result("")
            return
        }

        if(call.method == "proofCreateWithRequest") {
            let sourceId = arguments?["sourceId"] as? String
            let message = arguments?["message"] as? String

            sdk.proofCreate(withRequest: sourceId, withProofRequest: message, withCompletion: { error,value in
                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "proofCreateWithRequest : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)
            })
            return
        }

        // 증명 상태 개체 직렬화
        if(call.method == "proofSerialize") {
            let proofHandle = arguments?["proofHandle"] as? Int

            sdk.proofSerialize(vcx_proof_handle_t(proofHandle!), withCompletion: { error,value in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "proofSerialize : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)
            })
            return
        }

        // 증명 요청과 연결된 증명 개체를 역질렬화
        if(call.method == "proofDeserialize") {
            let serializedProof = arguments?["serializedProof"] as? String

            sdk.proofDeserialize(serializedProof, withCompletion: { error,value in
                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "proofDeserialize : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)
            })
            return
        }


        // Proof Request에서 요청된 각 속성/술어를 채우는 데 사용할 수 있는 자격 증명 검색
        if(call.method == "proofRetrieveCredentials") {
            let proofHandle = arguments?["proofHandle"] as? Int

            sdk.proofRetrieveCredentials(vcx_proof_handle_t(proofHandle!), withCompletion: { error,value in
                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "proofRetrieveCredentials : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)
            })
            return
        }

        // 선택한 자격 증명 및 자체 증명된 속성을 사용하여 증명 생성
        if(call.method == "proofGenerate") {
            let proofHandle = arguments?["proofHandle"] as? Int
            let selectedCreds = arguments?["selectedCreds"] as? String
            let selfAttestedAttributes = arguments?["selfAttestedAttributes"] as? String

            sdk.proofGenerate(vcx_proof_handle_t(proofHandle!), withSelectedCredentials: selectedCreds, withSelfAttestedAttrs: selfAttestedAttributes, withCompletion: { error in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "proofGenerate : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result("")
            })
            return
        }

        if(call.method == "proofSend") {
            let proofHandle = arguments?["proofHandle"] as? Int
            let connectionHandle = arguments?["connectionHandle"] as? Int

            sdk.proofSend(vcx_proof_handle_t(proofHandle!), withConnectionHandle: vcx_connection_handle_t(connectionHandle!), withCompletion: { error in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "proofSend : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result("")
            })
            return
        }

        if(call.method == "connectionInviteDetails") {
            let handle = arguments?["handle"] as? Int
            let abbreviated = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 0)

            sdk.getConnectionInviteDetails(handle!, abbreviated:abbreviated, withCompletion: { error, value in
                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "connectionInviteDetails : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result(value)
            })
            return
        }

        if(call.method == "connectionRelease") {
            let handle = arguments?["handle"] as? Int
            let value = sdk.connectionRelease(handle!)
            result(value)
            return
        }

        if(call.method == "connectionSendReuse") {

            let handle = arguments?["handle"] as? Int
            let invitation = arguments?["invitation"] as? String


            sdk.connectionSendReuse(Int32(truncatingIfNeeded: handle!), invite: invitation, withCompletion: { error in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "connectionSendReuse : "+error.debugDescription,
                                        details: nil))
                    return
                }
                result("")
            })
            return
        }

        if(call.method == "initLibrary") {
            let configJson = arguments?["configJson"] as? String

            sdk.initWithConfig(configJson,completion: {error in

                if(self.isError(error: error)){
                    result(FlutterError(code: "Error",
                                        message: "initLibrary : "+error.debugDescription,
                                        details: nil))
                    return
                }

                result("")

            })
            return
        }
        result(FlutterMethodNotImplemented)
    }
}
