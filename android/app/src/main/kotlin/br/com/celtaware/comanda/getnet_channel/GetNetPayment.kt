package br.com.celtaware.comanda.getnet_channel

import android.app.Activity
import android.app.Activity.RESULT_OK
import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import com.getnet.posdigital.PosDigital
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class GetNetPayment(
    private val activity: Activity,
    private val flutterEngine: FlutterEngine,
) {
    private var REQUEST_CODE = 10001
    private val channel: String = "getnet"


    private val bindCallback: PosDigital.BindCallback
        get() = object : PosDigital.BindCallback {
            override fun onError(e: Exception) {
                if (PosDigital.getInstance().isInitiated)
                    PosDigital.unregister(activity.applicationContext)

                connectPosDigitalService()
            }

            override fun onConnected() {}
            override fun onDisconnected() {}
        }

    private fun connectPosDigitalService() {
        PosDigital.register(activity.applicationContext, bindCallback)
    }


    fun setupMethodChannel() {
        connectPosDigitalService()
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, channel
        ).setMethodCallHandler { call, result ->
            val argumentsWithFlutter = call.arguments as? Map<*, *>
            argumentsWithFlutter?.let {
                val longAmountValue =
                    (it["longAmountValue"] as? Int ?: 1).toString().padStart(12, '0')
                val portionQuantity = it["portionQuantity"] as? Int ?: 1

                when (call.method) {
                    "credit" -> {
                        collectPayment(
                            result,
                            longAmountValue,
                            "credit",
                            true,
                            portionQuantity,
                        )
                    }

                    "voucher" -> {
                        collectPayment(result, longAmountValue, "voucher")
                    }

                    "debit" -> {
                        collectPayment(result, longAmountValue, "debit")
                    }

                    "pix" -> {
                        collectPayment(result, longAmountValue, "pix")
                    }

                    else -> result.notImplemented()
                }
            } ?: result.error(
                "INVALID_ARGUMENTS", "Os argumentos fornecidos não são válidos.", null
            )
        }
    }

    private fun collectPayment(
        result: MethodChannel.Result,
        longAmountValue: String,
        paymentType: String,
        isCredit: Boolean = false,
        portionQuantity: Int = 1,
    ) {
        try {
            val bundle = Bundle()
            bundle.putString("paymentType", paymentType)
            if (isCredit) {
                bundle.putString("creditType", "creditIssuer")
                bundle.putInt("installments", portionQuantity)
            }
            bundle.putString("amount", longAmountValue)
            bundle.putString(
                "callerId", "criar um identificador único pra chamar aqui, até 50 caracteres"
            )
            bundle.putString("currencyCode", "986") //R$

            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("getnet://pagamento/v3/payment"))
            intent.putExtras(bundle)
            activity.startActivityForResult(intent, REQUEST_CODE)

            result.success("Método chamado com sucesso")

            Log.d("Pagamentos", "collect payment called with success")
        } catch (ex: ActivityNotFoundException) {
            Log.e("Pagamentos", "Aplicativo Pagamentos não encontrado", ex)
            result.error("ActivityNotFoundException", "Aplicativo Pagamentos não encontrado", null)
        } catch (e: Exception) {
            Log.e("Pagamentos", "failed to collect payment because ${e.message}")
            result.error("Unknown error", "failed to collect payment because ${e.message}", null)
        }
    }

    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (RESULT_OK == resultCode && REQUEST_CODE == requestCode) {
            val result = HashMap<String, String?>()

            result["result"] = data?.getStringExtra("result") as String
            result["resultDetails"] = data.getStringExtra("resultDetails")
            result["amount"] = data.getStringExtra("amount")
            result["callerId"] = data.getStringExtra("callerId")
            result["nsu"] = data.getStringExtra("nsu")
            result["nsuLastSuccesfullMessage"] = data.getStringExtra("nsuLastSuccesfullMessage")
            result["cvNumber"] = data.getStringExtra("cvNumber")
            result["type"] = data.getStringExtra("type")
            result["brand"] = data.getStringExtra("brand")
            result["inputType"] = data.getStringExtra("inputType")
            result["installments"] = data.getStringExtra("installments")
            result["nsuLocal"] = data.getStringExtra("nsuLocal")
            result["authorizationCode"] = data.getStringExtra("authorizationCode")
            result["cardBin"] = data.getStringExtra("cardBin")
            result["cardLastDigits"] = data.getStringExtra("cardLastDigits")
            result["extraScreensResult"] = data.getStringExtra("extraScreensResult")
            result["cardholderName"] = data.getStringExtra("cardholderName")
            result["automationSlip"] = data.getStringExtra("automationSlip")
            result["printMerchantPreference"] = data.getStringExtra("printMerchantPreference")
            result["gmtDateTime"] = data.getStringExtra("gmtDateTime")
            result["orderId"] = data.getStringExtra("orderId")
            result["pixPayloadResponse"] = data.getStringExtra("pixPayloadResponse")

            sendMessageToFlutter("Resultado: $result")
        }
    }

    fun onDestroy() {
        val tag = javaClass.name
        try {
            if (PosDigital.getInstance().isInitiated)
                PosDigital.unregister(activity.applicationContext)
        } catch (e: Exception) {
            Log.e(tag, "Erro de exception no Destroy da Activity")
        }
    }


    private fun sendMessageToFlutter(message: String) {
        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        methodChannel.invokeMethod("paymentResult", message)
    }
}
