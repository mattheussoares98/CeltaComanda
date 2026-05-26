package br.com.celtaware.comanda.cielo_channel

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.util.Base64
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

class CieloPayment(private val activity: Activity) : MethodCallHandler {
    private val CHANNEL = "cielo"
    private val TAG = "CieloPayment"
    private var channel: MethodChannel? = null
    private var callback: Result? = null
    private var paymentStartTime: Long = 0

    companion object {
        const val CIELO_PAYMENT_REQUEST_CODE = 20001
    }

    fun setupMethodChannel(flutterEngine: FlutterEngine) {
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel?.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "pay" -> {
                callback = result
                val params = call.arguments as? Map<String, Any>
                if (params == null) {
                    result.error("INVALID_ARGUMENTS", "Arguments are null", null)
                    return
                }

                try {
                    var accessToken = params["accessToken"] as? String ?: ""
                    var clientID = params["clientID"] as? String ?: ""
                    if (accessToken.isEmpty()) accessToken = "xxxxxxxxxxxxxxxxxxxxxx"
                    if (clientID.isEmpty()) clientID = "xxxxxxxxxxxxxxxxx"
                    val value = params["value"] as? String ?: "0"
                    val rawPaymentCode = params["paymentCode"] as? String
                    val paymentCode = when (rawPaymentCode?.lowercase()) {
                        "debit" -> "DEBITO_AVISTA"
                        "credit" -> "CREDITO_AVISTA"
                        "creditportion" -> "CREDITO_PARCELADO_LOJA"
                        "pix" -> "PIX"
                        "voucher" -> "VOUCHER_REFEICAO"
                        else -> rawPaymentCode
                    }
                    val installments = params["installments"] as? Int ?: 0
                    val email = params["email"] as? String ?: ""
                    val reference = params["reference"] as? String

                    val jsonObject = JSONObject().apply {
                        put("accessToken", accessToken)
                        put("clientID", clientID)
                        put("value", value)
                        put("installments", installments)
                        put("email", email)
                        put("items", org.json.JSONArray().put(
                            JSONObject().apply {
                                put("name", "Geral")
                                put("quantity", 1)
                                put("sku", "1")
                                put("unitOfMeasure", "unidade")
                                put("unitPrice", value.toIntOrNull() ?: 0)
                            }
                        ))
                        if (!paymentCode.isNullOrEmpty()) {
                            put("paymentCode", paymentCode)
                        }
                        if (!reference.isNullOrEmpty()) {
                            put("reference", reference)
                        }
                    }

                    val jsonString = jsonObject.toString()
                    val base64 = Base64.encodeToString(
                        jsonString.toByteArray(Charsets.UTF_8),
                        Base64.NO_WRAP
                    )

                    val scheme = params["callbackScheme"] as? String ?: "order"
                    val host = params["callbackHost"] as? String ?: "response"

                    val checkoutUri =
                        "lio://payment?request=$base64&urlCallback=$scheme://$host"

                    Log.d(TAG, "Payment URI: $checkoutUri")

                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(checkoutUri))
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    paymentStartTime = System.currentTimeMillis()
                    activity.startActivityForResult(intent, CIELO_PAYMENT_REQUEST_CODE)
                } catch (e: Exception) {
                    Log.e(TAG, "Error launching payment: ${e.message}")
                    result.error("PAYMENT_ERROR", e.message, null)
                }
            }
            else -> result.notImplemented()
        }
    }

    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode != CIELO_PAYMENT_REQUEST_CODE) return

        try {
            if (resultCode == Activity.RESULT_OK && data?.data != null) {
                val uri = data.data
                val response = uri?.getQueryParameter("response")
                val responseCode = uri?.getQueryParameter("responsecode")

                if (response != null) {
                    val decodedBytes = Base64.decode(response, Base64.DEFAULT)
                    val jsonString = String(decodedBytes, Charsets.UTF_8)

                    Log.d(TAG, "Payment response JSON: $jsonString")

                    val resultMap = HashMap<String, Any?>()
                    resultMap["responseJson"] = jsonString
                    resultMap["responsecode"] = responseCode

                    callback?.success(resultMap)
                    callback = null
                } else {
                    callback?.error("PAYMENT_ERROR", "Empty response from Cielo", null)
                    callback = null
                }
            } else if (resultCode == Activity.RESULT_CANCELED) {
                val duration = System.currentTimeMillis() - paymentStartTime
                Log.d(TAG, "onActivityResult RESULT_CANCELED after ${duration}ms")
                if (duration > 1500) {
                    callback?.error("PAYMENT_CANCELED", "Payment was canceled", null)
                    callback = null
                } else {
                    Log.d(TAG, "Ignoring immediate automatic RESULT_CANCELED (duration: ${duration}ms)")
                }
            } else {
                callback?.error("PAYMENT_ERROR", "Unexpected result from Cielo", null)
                callback = null
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling payment result: ${e.message}")
            callback?.error("PAYMENT_ERROR", e.message, null)
            callback = null
        }
    }

    /**
     * Handle deep link response when the app is brought back via urlCallback.
     * This is called from MainActivity.onNewIntent if the response comes as a deep link.
     */
    fun handleDeepLinkResponse(intent: Intent) {
        try {
            if (Intent.ACTION_VIEW == intent.action) {
                val uri = intent.data
                val response = uri?.getQueryParameter("response")
                val responseCode = uri?.getQueryParameter("responsecode")

                if (response != null && callback != null) {
                    val decodedBytes = Base64.decode(response, Base64.DEFAULT)
                    val jsonString = String(decodedBytes, Charsets.UTF_8)

                    Log.d(TAG, "Deep link payment response: $jsonString")

                    val resultMap = HashMap<String, Any?>()
                    resultMap["responseJson"] = jsonString
                    resultMap["responsecode"] = responseCode

                    callback?.success(resultMap)
                    callback = null
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling deep link response: ${e.message}")
            callback?.error("PAYMENT_ERROR", e.message, null)
            callback = null
        }
    }
}