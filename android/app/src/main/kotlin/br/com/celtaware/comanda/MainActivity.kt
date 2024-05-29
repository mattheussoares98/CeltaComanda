package br.com.celtaware.comanda

import android.content.ActivityNotFoundException
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
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
    private val CHANNEL = "seu_channel"
    private lateinit var redeSdk: IRedeSdk
    private lateinit var redePayments: RedePayments // Alteração feita aqui

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startredesdk" -> {
                    CoroutineScope(Dispatchers.Main).launch {
                        redeSdk = IRedeSdk.newInstance(applicationContext)
                        redePayments = withContext(Dispatchers.IO) {
                            redeSdk.getRedePayments(this@MainActivity)
                        }
                        result.success("message")
                    }
                }
                "creditoparcelado" -> {
                    try {
                        val longAmount = call.argument<Long>("amount") // Supondo que você esteja recebendo o valor como argumento
                        val collectPaymentIntent = redePayments
                            .intentForPaymentBuilder(FlexTipoPagamento.CREDITO_PARCELADO, longAmount ?: 0)
                            .setInstallments(4)
                            .build()

                        startActivityForResult(collectPaymentIntent, PAYMENT_REQUEST_CODE)
                    } catch (ex: ActivityNotFoundException) {
                        Log.e("Pagamentos", "Application Pagamentos not found")
                    } catch (ex: RedePaymentValidationError) {
                        Log.e("Pagamentos", "Intent validation error")
                    }
                    result.success("Method executed for creditoparcelado")
                }
                else -> result.notImplemented()
            }
        }
    }
    companion object {
        private const val PAYMENT_REQUEST_CODE = 1001 // Defina um valor adequado para o seu caso
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PAYMENT_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                if (data != null) {
                    val payment = RedePayments.getPaymentFromIntent(data)
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
