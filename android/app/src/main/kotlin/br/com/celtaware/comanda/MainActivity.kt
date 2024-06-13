package br.com.celtaware.comanda

import android.content.ActivityNotFoundException
import android.content.Intent
import android.app.Activity
import android.os.Bundle
import android.widget.Toast
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.koin.android.ext.android.inject
import rede.smartrede.sdk.RedePaymentValidationError
import rede.smartrede.sdk.RedePayments
import rede.smartrede.sdk.FlexTipoPagamento
import rede.smartrede.sdk.api.IRedeSdk
import rede.smartrede.sdk.PaymentStatus

class MainActivity : FlutterActivity() {
    private val redeSdk: IRedeSdk by inject()
    private val redePayments: RedePayments by inject()

    private val channel = "rede_channel"
    companion object {
        // Definindo um valor específico para PAYMENT_REQUEST_CODE
        private var PAYMENT_REQUEST_CODE: Int = 1
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            // Verificando se os argumentos são do tipo esperado
            val argumentsWithFlutter = call.arguments as? Map<*, *>
            argumentsWithFlutter?.let {
                val longAmountValue = (it["longAmountValue"] as? Int)?.toLong() ?: 0L
                val portionQuantity = it["portionQuantity"] as? Int ?: 0
                when (call.method) {
                    "startRedeSdk" -> {
                        // A inicialização do SDK agora é feita na classe App

                    }
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
            val collectPaymentIntent = redePayments
                .intentForPaymentBuilder(tipoPagamento, longAmountValue)
            if (setInstallments) {
                collectPaymentIntent.setInstallments(portionQuantity)
            }
            startActivityForResult(collectPaymentIntent.build(), PAYMENT_REQUEST_CODE)
            result.success("Método chamado com sucesso")
        } catch (ex: ActivityNotFoundException) {
            Log.e("Pagamentos", "Aplicativo Pagamentos não encontrado", ex)
            result.error("ActivityNotFoundException", "Aplicativo Pagamentos não encontrado", null)
        } catch (ex: RedePaymentValidationError) {
            Log.e("Pagamentos", "Erro de validação do intent", ex)
            result.error("RedePaymentValidationError", "Erro de validação do intent", null)
        }
    }

    private fun showToast(message: String) {
        runOnUiThread {
            Toast.makeText(this@MainActivity, message, Toast.LENGTH_LONG).show()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PAYMENT_REQUEST_CODE) {
            when (resultCode) {
                Activity.RESULT_OK -> {
                    data?.let { intentData ->
                        val payment = RedePayments.getPaymentFromIntent(intentData)
                        when (payment?.status) {
                            PaymentStatus.AUTHORIZED -> showToast("Pagamento Autorizado")
                            PaymentStatus.FAILED -> showToast("Pagamento Falhou")
                            PaymentStatus.DECLINED -> showToast("Pagamento Recusado")
                            // Adicionando tratamento para outros status de pagamento
                            else -> Log.w("Pagamentos", "Status de pagamento desconhecido: ${payment?.status}")
                        }
                    }
                }
                Activity.RESULT_CANCELED -> showToast("Pagamento Cancelado")
                // Adicionando tratamento para outros códigos de resultado
                else -> Log.w("Pagamentos", "Código de resultado desconhecido: $resultCode")
            }
        }
    }
}
