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
                    activity.startActivity(intent)
                } catch (e: Exception) {
                    Log.e(TAG, "Error launching payment: ${e.message}")
                    result.error("PAYMENT_ERROR", e.message, null)
                }
            }
            else -> result.notImplemented()
        }
    }



    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        // No-op: Cielo handles all callback responses via deep links (onNewIntent)
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