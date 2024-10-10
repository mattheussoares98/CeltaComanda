package br.com.celtaware.comanda.rede_channel

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import rede.smartrede.sdk.FlexTipoPagamento
import rede.smartrede.sdk.PaymentStatus
import rede.smartrede.sdk.RedePaymentValidationError
import rede.smartrede.sdk.RedePayments

class PaymentHandler(
    private val activity: Activity,
    private val redePayments: RedePayments,
    private val flutterEngine: FlutterEngine,
) {
    private val channel: String = "rede_channel"

    companion object {
        private const val PAYMENT_REQUEST_CODE: Int = 1
    }

    fun setupMethodChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->
            val argumentsWithFlutter = call.arguments as? Map<*, *>
            argumentsWithFlutter?.let {
                val longAmountValue = (it["longAmountValue"] as? Int)?.toLong() ?: 0L
                val portionQuantity = it["portionQuantity"] as? Int ?: 0
                when (call.method) {
                    "credit" -> {
                        collectPayment(result, FlexTipoPagamento.CREDITO_A_VISTA, longAmountValue)
                    }
                    "creditPortion" -> {
                        collectPayment(result, FlexTipoPagamento.CREDITO_PARCELADO, longAmountValue, true, portionQuantity)
                    }
                    "debit" -> {
                        collectPayment(result, FlexTipoPagamento.DEBITO, longAmountValue)
                    }
                    "pix" -> {
                        collectPayment(result, FlexTipoPagamento.PIX, longAmountValue)
                    }
                    else -> result.notImplemented()
                }
            } ?: result.error("INVALID_ARGUMENTS", "Os argumentos fornecidos não são válidos.", null)
        }
    }

    private fun collectPayment(
        result: MethodChannel.Result,
        tipoPagamento: FlexTipoPagamento,
        longAmountValue: Long,
        setInstallments: Boolean = false,
        portionQuantity: Int = 1
    ) {
        try {
            val collectPaymentIntent = redePayments.intentForPaymentBuilder(tipoPagamento, longAmountValue)
            if (setInstallments) {
                collectPaymentIntent.setInstallments(portionQuantity)
            }

            val builtIntent = collectPaymentIntent.build()

            activity.startActivityForResult(builtIntent, PAYMENT_REQUEST_CODE)
            result.success("Método chamado com sucesso")

            Log.d("Pagamentos", "collect payment called with success")
        } catch (ex: ActivityNotFoundException) {
            Log.e("Pagamentos", "Aplicativo Pagamentos não encontrado", ex)
            result.error("ActivityNotFoundException", "Aplicativo Pagamentos não encontrado", null)
        } catch (ex: RedePaymentValidationError) {
            Log.e("Pagamentos", "Erro de validação do intent", ex)
            result.error("RedePaymentValidationError", "Erro de validação do intent", null)
        } catch (e: Exception) {
            Log.e("Pagamentos", "failed to collect payment because ${e.message}")
            result.error("Unknown error", "failed to collect payment because ${e.message}", null)
        }
    }

    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == PAYMENT_REQUEST_CODE) {
            when (resultCode) {
                Activity.RESULT_OK -> {
                    data?.let { intentData ->
                        val payment = RedePayments.getPaymentFromIntent(intentData)
                        when (payment?.status) {
                            PaymentStatus.AUTHORIZED -> sendMessageToFlutter("Pagamento Autorizado")
                            PaymentStatus.FAILED -> sendMessageToFlutter("Pagamento Falhou")
                            PaymentStatus.DECLINED -> sendMessageToFlutter("Pagamento Recusado")
                            else -> sendMessageToFlutter("Status de pagamento desconhecido: ${payment?.status}")
                        }
                    }
                }
                Activity.RESULT_CANCELED -> sendMessageToFlutter("Pagamento cancelado")
                else -> Log.w("Pagamentos", "Código de resultado desconhecido: $resultCode")
            }
        }
    }

    private fun sendMessageToFlutter(message: String) {
        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        methodChannel.invokeMethod("paymentResult", message)
    }
}
