package br.com.celtaware.comanda

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import br.com.celtaware.comanda.utils.AppUtils
import br.com.celtaware.comanda.utils.OrientationUtils
import br.com.celtaware.comanda.utils.PersistentChannelManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.koin.android.ext.android.inject
import rede.smartrede.sdk.FlexTipoPagamento
import rede.smartrede.sdk.PaymentStatus
import rede.smartrede.sdk.RedePaymentValidationError
import rede.smartrede.sdk.RedePayments

class MainActivity : FlutterActivity() {
    private val redePayments: RedePayments by inject()
    private lateinit var persistentChannelManager: PersistentChannelManager
    private var engine: FlutterEngine? = null

    private val channel = "rede_channel"
    private companion object {
        private var PAYMENT_REQUEST_CODE: Int = 1
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        engine = flutterEngine
        super.configureFlutterEngine(flutterEngine)
        persistentChannelManager = PersistentChannelManager(flutterEngine)

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
                        collectPayment(
                            result,
                            FlexTipoPagamento.CREDITO_PARCELADO,
                            longAmountValue,
                            true,
                            portionQuantity
                        )
                    }
                    "debit" -> {
                        collectPayment(result, FlexTipoPagamento.DEBITO, longAmountValue)
                    }
                    "pix" -> {
                        collectPayment(result, FlexTipoPagamento.PIX, longAmountValue)
                    }
                    else -> result.notImplemented()
                }
            } ?: result.error(
                "INVALID_ARGUMENTS",
                "Os argumentos fornecidos não são válidos.",
                null
            )
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

            val builtIntent = collectPaymentIntent.build()

            startActivityForResult(builtIntent, PAYMENT_REQUEST_CODE)
            result.success("Método chamado com sucesso")

            val payment = builtIntent.extras?.get("rede.smartrede.sdk.INTENT_EXTRAS_PAYMENT")
            val appVersion =
                builtIntent.extras?.get("rede.smartrede.sdk.INTENT_EXTRAS_APPLICATION_VERSION")
            val sdkVersion =
                builtIntent.extras?.get("rede.smartrede.sdk.INTENT_EXTRAS_SDK_VERSION_NAME")
            val calledAppId =
                builtIntent.extras?.get("rede.smartrede.sdk.INTENT_EXTRAS_APPLICATION_ID")
            Log.d("", "## called sdk with $payment")
            Log.d("", "## called sdk with $appVersion")
            Log.d("", "## called sdk with $sdkVersion")
            Log.d("", "## called sdk with $calledAppId")
            Log.w("Pagamentos", "collect payment called with success")
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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PAYMENT_REQUEST_CODE) {
            when (resultCode) {
                Activity.RESULT_OK -> {
                    data?.let { intentData ->
                        val payment = RedePayments.getPaymentFromIntent(intentData)
                        when (payment?.status) {
                            PaymentStatus.AUTHORIZED -> sendMessageToFlutter("Pagamento Autorizado")
                            PaymentStatus.FAILED -> sendMessageToFlutter("Pagamento Falhou")
                            PaymentStatus.DECLINED -> sendMessageToFlutter("Pagamento Recusado")
                            else -> sendMessageToFlutter(
                                "Status de pagamento desconhecido: ${payment?.status}"
                            )
                        }
                    }
                }
                Activity.RESULT_CANCELED -> sendMessageToFlutter("Pagamento cancelado")
                else -> Log.w("Pagamentos", "Código de resultado desconhecido: $resultCode")
            }
        }
    }

    private fun sendMessageToFlutter(message: String) {
        engine?.dartExecutor?.let { MethodChannel(it.binaryMessenger, channel).invokeMethod("paymentResult", message) }
    }

    private fun showToast(message: String) {
        runOnUiThread {
            Toast.makeText(this@MainActivity, message, Toast.LENGTH_LONG).show()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        OrientationUtils.doOrientation(this)
    }

    override fun onPause() {
        super.onPause()
        if (persistentChannelManager.isPersistApp()) {
            AppUtils.bringAppToFront(this)
        }
    }

    override fun onStop() {
        super.onStop()
        if (persistentChannelManager.isPersistApp()) {
            AppUtils.bringAppToFront(this)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (Intent.ACTION_MAIN == intent.action && persistentChannelManager.isPersistApp()) {
            Log.i("MyLauncher", "onNewIntent: HOME Key")
        }
    }
}
