package br.com.celtaware.comanda

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import rede.smartrede.sdk.api.IRedeSdk
import kotlinx.coroutines.*

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
            } else {
                result.notImplemented()
            }
        }
    }
}
