package com.jyp.flutter_evernym_mobile_sdk

import android.content.Context
import android.system.ErrnoException
import android.system.Os
import androidx.annotation.NonNull
import com.evernym.sdk.vcx.connection.ConnectionApi
import com.evernym.sdk.vcx.credential.CredentialApi
import com.evernym.sdk.vcx.proof.DisclosedProofApi
import com.evernym.sdk.vcx.utils.UtilsApi
import com.evernym.sdk.vcx.vcx.AlreadyInitializedException
import com.evernym.sdk.vcx.vcx.VcxApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject
import java.io.File
import java.io.FileOutputStream


/** FlutterEvernymMobileSdkPlugin */
class FlutterEvernymMobileSdkPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private var coroutine: CoroutineScope = CoroutineScope(Dispatchers.Default)

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "evernym")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  private fun setGenesisPath(config: String): String {
    var json = JSONObject(config)
    json.put("genesis_path", context.filesDir.absolutePath + "/pool_transactions_genesis")

    return json.toString()
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
      return
    }

    if (call.method == "storagePermissions") {
      try {
        Os.setenv("EXTERNAL_STORAGE", context.filesDir.absolutePath, true)
        result.success("")
      } catch (e: ErrnoException) {
        result.success("Failed to set environment variable storage")
      }
      return
    }

    if (call.method == "setCloudAgentProvisioning") {
      coroutine.launch {

        var token: String? = call.argument<String?>("token")
        var config: String? = call.argument<String?>("config")
        val handleConfig = setGenesisPath(config!!)

        UtilsApi.vcxAgentProvisionWithTokenAsync(handleConfig, token)
          .whenComplete { value: String?, err: Throwable? ->
            if (err != null) {
              result.error("Error: setCloudAgentProvisioning", err.message, null)
            }
            result.success(value)
          }
      }
      return
    }


    if (call.method == "getExtractAttachedMessage") {

      coroutine.launch {
        var invite: String? = call.argument<String?>("invite")

        UtilsApi.vcxExtractAttachedMessage(invite)
          .whenComplete { value: String?, e: Throwable? ->
            if (e != null) {
              result.error("Error: getExtractAttachedMessage", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    if (call.method == "getResolveMessageByUrl") {
      coroutine.launch {
        var invite: String? = call.argument<String?>("invite")

        UtilsApi.vcxResolveMessageByUrl(invite)
          .whenComplete { value: String?, e: Throwable? ->
            if (e != null) {
              result.error("Error: getResolveMessageByUrl", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    if (call.method == "createConnectionWithOutofbandInvite") {
      coroutine.launch {
        var invitationDetails: String? = call.argument<String?>("invitationDetails")
        var invitationId: String? = call.argument<String?>("invitationId")

        ConnectionApi.vcxCreateConnectionWithOutofbandInvite(
          invitationId!!,
          invitationDetails!!
        ).whenComplete { value: Int?, e: Throwable? ->
          if (e != null) {
            result.error("Error: createConnectionWithOutofbandInvite", e.message, null)
          }
          result.success(value)
        }
      }
      return
    }

    // 연결 초대 수락
    if (call.method == "getConnectionConnect") {
      coroutine.launch {
        var connectionHandle: Int? = call.argument<Int?>("connectionHandle")

        ConnectionApi.vcxConnectionConnect(connectionHandle!!, "{}")
          .whenComplete { invite: String?, t: Throwable? ->
            if (t != null) {
              result.error("Error: getConnectionConnect", t.message, null)

            }
            result.success(invite)
          }
      }
      return
    }
    // 연결 직렬화
    if (call.method == "connectionSerialize") {
      coroutine.launch {
        var connectionHandle: Int? = call.argument<Int?>("connectionHandle")

        ConnectionApi.connectionSerialize(connectionHandle!!)
          .whenComplete { value: String?, e: Throwable? ->
            if (e != null) {
              result.error("Error: connectionSerialize", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    // offer으로 자격증 생성
    if (call.method == "credentialCreateWithOffer") {
      coroutine.launch {
        var sourceId: String? = call.argument<String?>("sourceId")
        var message: String? = call.argument<String?>("message")

        CredentialApi.credentialCreateWithOffer(sourceId, message)
          .whenComplete { value: Int?, e: Throwable? ->
            if (e != null) {
              result.error("Error: credentialCreateWithOffer", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    // 자격증 직렬화
    if (call.method == "credentialSerialize") {
      coroutine.launch {
        var credentialHandle: Int? = call.argument<Int?>("credentialHandle")

        CredentialApi.credentialSerialize(credentialHandle!!)
          .whenComplete { value: String?, e: Throwable? ->
            if (e != null) {
              result.error("Error: credentialSerialize", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    // 연결 개체 직렬화
    if (call.method == "connectionDeserialize") {
      coroutine.launch {
        var connectionData: String? = call.argument<String?>("connectionData")

        ConnectionApi.connectionDeserialize(connectionData)
          .whenComplete { value: Int?, e: Throwable? ->
            if (e != null) {
              result.error("Error: connectionDeserialize", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    // 연결에서 pwDid 추출
    if (call.method == "connectionGetPwDid") {
      coroutine.launch {
        var connectionHandle: Int? = call.argument<Int?>("connectionHandle")

        ConnectionApi.connectionGetPwDid(connectionHandle!!)
          .whenComplete { value: String?, e: Throwable? ->
            if (e != null) {
              result.error("Error: connectionGetPwDid", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    if (call.method == "credentialDeserialize") {
      coroutine.launch {
        var serializedCredOffer: String? = call.argument<String?>("serializedCredOffer")

        CredentialApi.credentialDeserialize(serializedCredOffer)
          .whenComplete { value: Int?, e: Throwable? ->
            if (e != null) {
              result.error("Error: credentialDeserialize", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    if (call.method == "deleteCredential") {
      coroutine.launch {
        var credHandle: Int? = call.argument<Int?>("credHandle")

        CredentialApi.deleteCredential(credHandle!!)
          .whenComplete { value: Void?, e: Throwable? ->
            if (e != null) {
              result.error("Error: deleteCredential", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    if (call.method == "credentialSendRequest") {
      // 스레드 사용시 메소드가 제대로 실행 안됨
      var credHandle: Int? = call.argument<Int?>("credHandle")
      var conHandle: Int? = call.argument<Int?>("conHandle")

      CredentialApi.credentialSendRequest(credHandle!!, conHandle!!, 0)
        .whenComplete { value: Void?, e: Throwable? ->
          if (e != null) {
            result.error("Error: credentialSendRequest", e.message, null)
          }
          result.success(value)
        }
      return
    }

    if (call.method == "vcxGetMessages") {
      coroutine.launch {
        var MessageStatusType: String? = call.argument<String?>("MessageStatusType")

        UtilsApi.vcxGetMessages(MessageStatusType, null, null)
          .whenComplete { value: String?, e: Throwable? ->
            if (e != null) {
              result.error("Error: vcxGetMessages", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    if (call.method == "vcxConnectionUpdateStateWithMessage") {
      coroutine.launch {
        var handle: Int? = call.argument<Int?>("handle")
        var payload: String? = call.argument<String?>("payload")

        ConnectionApi.vcxConnectionUpdateStateWithMessage(handle!!, payload)
          .whenComplete { value: Int?, e: Throwable? ->
            if (e != null) {
              result.error(
                "Error: vcxConnectionUpdateStateWithMessage",
                e.message,
                null
              )
            }
            result.success(value)
          }
      }
      return
    }

    if (call.method == "vcxUpdateMessages") {
      coroutine.launch {
        var messageStatusType: String? = call.argument<String?>("messageStatusType")
        var messagesToUpdate: String? = call.argument<String?>("messagesToUpdate")

        UtilsApi.vcxUpdateMessages(messageStatusType, messagesToUpdate)
          .whenComplete { value: Void?, e: Throwable? ->
            if (e != null) {
              result.error("Error: vcxUpdateMessages", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    if (call.method == "credentialUpdateStateWithMessage") {
      coroutine.launch {
        var handle: Int? = call.argument<Int?>("handle")
        var payload: String? = call.argument<String?>("payload")

        CredentialApi.credentialUpdateStateWithMessage(handle!!, payload)
          .whenComplete { value: Int?, e: Throwable? ->
            if (e != null) {
              result.error("Error: credentialUpdateStateWithMessage", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    if (call.method == "vcxFetchPublicEntities") {
      coroutine.launch {
        UtilsApi.vcxFetchPublicEntities().whenComplete { value: Void?, e: Throwable? ->
          if (e != null) {
            result.error("Error: vcxFetchPublicEntities", e.message, null)
          }
          result.success(value)
        }
      }
      return
    }

    if (call.method == "vcxInitPool") {
      coroutine.launch {
        var poolConfig: String? = call.argument<String?>("poolConfig")

        VcxApi.vcxInitPool(poolConfig).whenComplete { value: Void?, e: Throwable? ->
          if (e != null) {
            result.error("Error: vcxInitPool", e.message, null)
          }
          result.success(value)
        }
      }
      return
    }


    if (call.method == "writeGenesisFile") {
      coroutine.launch {
        try {
          var genesisJson: String? = call.argument<String?>("genesisJson")
          val genesisFile =
            File(context.filesDir.absolutePath, "pool_transactions_genesis")

          if (!genesisFile.exists()) {
            val strToBytes: ByteArray = genesisJson!!.toByteArray()
            val outputStream = FileOutputStream(genesisFile)
            outputStream.write(strToBytes)
            outputStream.close()
          }
          result.success("")
        } catch (e: Exception) {
          result.error("Error: writeGenesisFile", e.message, null)

        }
      }
      return
    }

    // 자격 증명 상태 개체 만들기
    if (call.method == "proofCreateWithRequest") {
      coroutine.launch {
        var sourceId: String? = call.argument<String?>("sourceId")
        var message: String? = call.argument<String?>("message")

        DisclosedProofApi.proofCreateWithRequest(sourceId, message)
          .whenComplete { value: Int?, e: Throwable? ->
            if (e != null) {
              result.error("Error: proofCreateWithRequest", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    // 증명 상태 개체 직렬화
    if (call.method == "proofSerialize") {
      coroutine.launch {
        var proofHandle: Int? = call.argument<Int?>("proofHandle")

        DisclosedProofApi.proofSerialize(proofHandle!!)
          .whenComplete { value: String?, e: Throwable? ->
            if (e != null) {
              result.error("Error: proofSerialize", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    // 증명 요청과 연결된 증명 상태 개체를 역직렬화
    if (call.method == "proofDeserialize") {
      coroutine.launch {
        var serializedProof: String? = call.argument<String?>("serializedProof")
        DisclosedProofApi.proofDeserialize(serializedProof)
          .whenComplete { value: Int?, e: Throwable? ->
            if (e != null) {
              result.error("Error: proofDeserialize", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    // Proof Request에서 요청된 각 속성/술어를 채우는 데 사용할 수 있는 자격 증명 검색
    if (call.method == "proofRetrieveCredentials") {
      coroutine.launch {
        var proofHandle: Int? = call.argument<Int?>("proofHandle")

        DisclosedProofApi.proofRetrieveCredentials(proofHandle!!)
          .whenComplete { value: String?, e: Throwable? ->
            if (e != null) {
              result.error("Error: proofRetrieveCredentials", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    // 선택한 자격 증명 및 자체 증명된 속성을 사용하여 증명 생성
    if (call.method == "proofGenerate") {
      coroutine.launch {
        var proofHandle: Int? = call.argument<Int?>("proofHandle")
        var selectedCreds: String? = call.argument<String?>("selectedCreds")
        var selfAttestedAttributes: String? =
          call.argument<String?>("selfAttestedAttributes")

        DisclosedProofApi.proofGenerate(
          proofHandle!!,
          selectedCreds,
          selfAttestedAttributes
        )
          .whenComplete { value: Void?, e: Throwable? ->
            if (e != null) {
              result.error("Error: proofGenerate", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    if (call.method == "proofSend") {
      coroutine.launch {
        var proofHandle: Int? = call.argument<Int?>("proofHandle")
        var connectionHandle: Int? = call.argument<Int?>("connectionHandle")

        DisclosedProofApi.proofSend(proofHandle!!, connectionHandle!!)
          .whenComplete { value: Void?, e: Throwable? ->
            if (e != null) {
              result.error("Error: proofSend", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }


    if (call.method == "connectionInviteDetails") {
      coroutine.launch {
        var handle: Int? = call.argument<Int?>("handle")

        ConnectionApi.connectionInviteDetails(handle!!, 0)
          .whenComplete { value: String?, e: Throwable? ->
            if (e != null) {
              result.error("Error: connectionInviteDetails", e.message, null)
            }
            result.success(value)
          }
      }
      return
    }

    if (call.method == "connectionRelease") {
      coroutine.launch {
        try {
          var handle: Int? = call.argument<Int?>("handle")

          var value: Int = ConnectionApi.connectionRelease(handle!!)
          result.success(value)

        } catch (e: Exception) {
          result.error("Error: connectionRelease", e.message, null)
        }
      }
      return
    }

    if (call.method == "connectionSendReuse") {
      coroutine.launch {
        var handle: Int? = call.argument<Int?>("handle")
        var invitation: String? = call.argument<String?>("invitation")

        ConnectionApi.connectionSendReuse(handle!!, invitation)
          .whenComplete { value: Void?, e: Throwable? ->
            if (e != null) {
              result.error("Error: connectionSendReuse", e.message, null)
            }
            result.success(value)
          }
      }

      return
    }


    if (call.method == "initLibrary") {
      coroutine.launch {
        var configJson: String? = call.argument<String?>("configJson")
        try {

          VcxApi.vcxInitWithConfig(configJson)
            .whenComplete { value: Int?, e: Throwable? ->
              if (e != null) {
                result.error("Error: initLibrary", e.message, null)
              }
              result.success(value)
            }
        } catch (e: AlreadyInitializedException) {
          result.success("already initialized")
        }
      }
      return
    }

    result.notImplemented()
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
