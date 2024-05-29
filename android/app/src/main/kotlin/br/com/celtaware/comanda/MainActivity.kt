package br.com.celtaware.comanda

import android.content.ActivityNotFoundException
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import rede.smartrede.sdk.RedePaymentValidationError
import rede.smartrede.sdk.RedePayments
import rede.smartrede.sdk.FlexTipoPagamento
import rede.smartrede.sdk.api.IRedeSdk
import rede.smartrede.sdk.PaymentStatus
import android.content.Intent
import android.app.Activity
import android.widget.Toast


class MainActivity : FlutterActivity() {
    private val channel = "rede_channel"
    private lateinit var redeSdk: IRedeSdk
    private lateinit var redePayments: RedePayments
    var sdkInitialized = false

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            var argumentsWithFlutter = call.arguments as? Map<String, String>
            if (argumentsWithFlutter != null) {
                var longAmountValue = (argumentsWithFlutter["longAmountValue"] as? Int)?.toLong() ?: 0L
                var portionQuantity = (argumentsWithFlutter["portionQuantity"] as? Int) ?: 0

                when (call.method) {
                    "startredesdk" -> {
                        initializeRedeSdk(result)
                    }
                    "creditoavista" -> {
                        collectPayment(result, FlexTipoPagamento.CREDITO_A_VISTA, longAmountValue)
                    }
                    "creditoparcelado" -> {
                        collectPayment(result, FlexTipoPagamento.CREDITO_PARCELADO, longAmountValue, true, portionQuantity)
                    }
                    "debito" -> {
                        collectPayment(result, FlexTipoPagamento.DEBITO, longAmountValue)
                    }
                    "pix" -> {
                        collectPayment(result, FlexTipoPagamento.PIX, longAmountValue)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    fun collectPayment(
        result: MethodChannel.Result,
        tipoPagamento: FlexTipoPagamento,
        longAmountValue: Long?,
        setInstallments: Boolean = false,
        portionQuantity: Int? = null
    ) {
        try {
            if (!sdkInitialized) {
                CoroutineScope(Dispatchers.Main).launch {
                    initializeRedeSdk(result)
                }
            }
            if (sdkInitialized) {
                var collectPaymentIntent = redePayments
                    .intentForPaymentBuilder(tipoPagamento, longAmountValue ?: 0)

                if (setInstallments && portionQuantity != null) {
                    collectPaymentIntent.setInstallments(portionQuantity)
                }

                startActivityForResult(collectPaymentIntent.build(), PAYMENT_REQUEST_CODE)
            }
            result.success("Método chamado com sucesso")
        } catch (ex: ActivityNotFoundException) {
            Log.e("Pagamentos", "Application Pagamentos not found")
            result.error("ActivityNotFoundException", "Application Pagamentos not found", null)
        } catch (ex: RedePaymentValidationError) {
            Log.e("Pagamentos", "Intent validation error")
            result.error("RedePaymentValidationError", "Intent validation error", null)
        }
    }

    private fun initializeRedeSdk(result: MethodChannel.Result) {
        try {
            if (!sdkInitialized) {
                CoroutineScope(Dispatchers.Main).launch {
                    redeSdk = IRedeSdk.newInstance(applicationContext)
                    redePayments = withContext(Dispatchers.IO) {
                        redeSdk.getRedePayments(this@MainActivity)
                    }
                    Toast.makeText(this@MainActivity, "SDK INICIALIZADO", Toast.LENGTH_LONG).show()
                    sdkInitialized = true
                }
            }
        } catch(e: Exception){
            Toast.makeText(this@MainActivity, "ERRO NA INICIALIZAÇÃO DO SDK", Toast.LENGTH_LONG).show()
            throw e
        }
    }
    companion object {
        private var PAYMENT_REQUEST_CODE: Int = 0
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PAYMENT_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                if (data != null) {
                    var payment = RedePayments.getPaymentFromIntent(data)
                    when (payment?.status) {
                        PaymentStatus.AUTHORIZED -> {
                            Toast.makeText(this, "Payment Authorized", Toast.LENGTH_LONG).show()
                        }
                        PaymentStatus.FAILED -> {
                            Toast.makeText(this, "Payment Failed", Toast.LENGTH_LONG).show()
                        }
                        PaymentStatus.DECLINED -> {
                            Toast.makeText(this, "Payment Declined", Toast.LENGTH_LONG).show()
                        }
                        else -> {
                            // Handle other cases if needed
                        }
                    }
                }
            } else if (resultCode == Activity.RESULT_CANCELED) {
                Toast.makeText(this, "Payment Canceled", Toast.LENGTH_LONG).show()
            }
        }
    }
}
