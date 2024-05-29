package br.com.celtaware.comanda

import android.content.ActivityNotFoundException
import android.util.Log
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import rede.smartrede.sdk.api.IRedeSdk
import kotlinx.coroutines.*
import rede.smartrede.commons.MerchantData
import rede.smartrede.commons.contract.ITerminalFunctions
import rede.smartrede.sdk.FlexTipoPagamento.CREDITO_PARCELADO
import rede.smartrede.sdk.FlexTipoPagamento.CREDITO_PARCELADO_EMISSOR
import rede.smartrede.sdk.PaymentStatus
import rede.smartrede.sdk.RedePaymentValidationError
import rede.smartrede.sdk.RedePayments

class MainActivity : FlutterActivity() {
    private val CHANNEL = "seu_channel"
    private lateinit var redeSdk: IRedeSdk
    private var redePayments: Any? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startredesdk") {
                // Iniciar a coroutine
                CoroutineScope(Dispatchers.Main).launch {
                    // Chama o método para iniciar o SDK aqui
                    redeSdk = IRedeSdk.newInstance(applicationContext)
                    // Faça o que for necessário com o objeto redeSdk
                    redePayments = withContext(Dispatchers.IO) {
                        redeSdk.getRedePayments(this@MainActivity)
                    }
                    result.success("message") // ou result.success(algumResultado) se desejar retornar algo para o Flutter
                }
            } else if (call.method == "creditoparcelado") {
                CoroutineScope(Dispatchers.Main).launch {
                    try {
                        val collectPaymentIntent = redePayments.intentForPaymentBuilder(FlexTipoPagamento.CREDITO_PARCELADO, longAmount)?.setInstallments(4)?.build()

                        collectPaymentIntent?.let {
                            startActivityForResult(it, PAYMENT_REQUEST_CODE)
                        } ?: run {
                            Log.e("Pagamentos", "redePayments is null")
                            // Handle the case where redePayments is null
                        }
                    } catch (ex: ActivityNotFoundException) {
                        Log.e("Pagamentos", "Application Pagamentos not found", ex)
                        // Handle the ActivityNotFoundException
                    } catch (ex: RedePaymentValidationError) {
                        Log.e("Pagamentos", "Intent validation error", ex)
                        // Handle the RedePaymentValidationError
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
