// package br.com.celtaware.comanda.getnet_channel
//
// import android.app.Activity
// import android.graphics.Bitmap
// import android.graphics.BitmapFactory
// import android.os.RemoteException
// import android.util.Log
// import com.getnet.posdigital.PosDigital
// import com.getnet.posdigital.printer.AlignMode
// import com.getnet.posdigital.printer.IPrinterCallback
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel
//
//
// class GetNetPrinter(
//     private val activity: Activity,
//     private val flutterEngine: FlutterEngine,
// ) {
//     private val channel: String = "printer"
//
//
//    private var methodChannel: MethodChannel? = null
//    private var retryCount = 0
//    private val maxRetries = 3
//
//    private val bindCallback = object : PosDigital.BindCallback {
//        override fun onError(e: Exception) {
//            Log.e("GetNetPrinter", "PosDigital error: ${e.message}")
//            
//            try {
//                if (PosDigital.getInstance().isInitiated)
//                    PosDigital.unregister(activity.applicationContext)
//            } catch (ex: Exception) {
//                Log.e("GetNetPrinter", "Error unregistering: ${ex.message}")
//            }
//
//            if (retryCount < maxRetries) {
//                retryCount++
//                Log.d("GetNetPrinter", "Retrying connection ($retryCount/$maxRetries)...")
//                connectPosDigitalService()
//            } else {
//                Log.e("GetNetPrinter", "Max retries reached. Could not connect to PosDigital.")
//                sendMessageToFlutter("Error: Max connection retries reached")
//            }
//        }
//
//        override fun onConnected() {
//            Log.d("GetNetPrinter", "PosDigital service connected")
//            retryCount = 0
//        }
//
//        override fun onDisconnected() {
//            Log.d("GetNetPrinter", "PosDigital service disconnected")
//            if (retryCount < maxRetries) {
//                retryCount++
//                connectPosDigitalService()
//            } else {
//                sendMessageToFlutter("Error: PosDigital disconnected and max retries reached")
//            }
//        }
//    }
//
//    private fun connectPosDigitalService() {
//        Log.d("GetNetPrinter", "Registering PosDigital service...")
//        try {
//            PosDigital.register(activity.applicationContext, bindCallback)
//        } catch (e: Exception) {
//            Log.e("GetNetPrinter", "Failed to register PosDigital: ${e.message}")
//        }
//    }
//
//    fun setupMethodChannel() {
//        connectPosDigitalService()
//        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
//        methodChannel?.setMethodCallHandler { call, result ->
//            if (call.method == "printBitmap") {
//                val bitmapBytes = call.argument<ByteArray>("bitmap")
//                if (bitmapBytes != null) {
//                    val bitmap = BitmapFactory.decodeByteArray(bitmapBytes, 0, bitmapBytes.size)
//                    Log.d("GetNetPrinter", "Bitmap received: ${bitmap.width}x${bitmap.height}")
//                    
//                    if (bitmap.width > 378) {
//                        Log.w("GetNetPrinter", "Bitmap width (${bitmap.width}) exceeds recommended 378px. SDK will resize.")
//                    }
//
//                    try {
//                        printReceipt(bitmap)
//                        result.success(null)
//                    } catch (e: Exception) {
//                        Log.e("GetNetPrinter", "Error sending bitmap to printer: ${e.message}")
//                        result.error("PRINTER_ERROR", e.message, null)
//                    }
//                } else {
//                    Log.e("GetNetPrinter", "Bitmap bytes are null")
//                    result.error("INVALID_ARGUMENT", "Bitmap bytes are null", null)
//                }
//            } else {
//                result.notImplemented()
//            }
//        }
//    }
//
//    fun printReceipt(bitmap: Bitmap) {
//        if (PosDigital.getInstance().isInitiated) {
//            try {
//                PosDigital.getInstance().printer.init()
//                PosDigital.getInstance().printer.setGray(5) // Adicionado conforme documentação
//                PosDigital.getInstance().printer.addImageBitmap(AlignMode.CENTER, bitmap)
//                // Usando printAndRemovePaper para facilitar o corte do papel
//                PosDigital.getInstance().printer.printAndRemovePaper(getPrinterCallback())
//            } catch (e: Exception) {
//                Log.e("GetNetPrinter", "Print error: ${e.message}")
//                sendMessageToFlutter("Error: ${e.message}")
//            }
//        } else {
//            Log.w("GetNetPrinter", "PosDigital not initiated, attempting to connect...")
//            connectPosDigitalService()
//            sendMessageToFlutter("Error: PosDigital não foi inicializado.Tente novamente em breve. Reconectando...")
//        }
//    }
//
//
//    private fun getPrinterCallback(): IPrinterCallback.Stub {
//        return object : IPrinterCallback.Stub() {
//            @Throws(RemoteException::class)
//            override fun onSuccess() {
//                sendMessageToFlutter("Success")
//            }
//
//            @Throws(RemoteException::class)
//            override fun onError(cause: Int) {
//                sendMessageToFlutter("Error: ${parseStatus(cause)}")
//            }
//        }
//    }
//
//    private fun parseStatus(cause: Int): String {
//        return when (cause) {
//            0 -> "OK"
//            1 -> "Imprimindo"
//            2 -> "Impressora não iniciada"
//            3 -> "Impressora superaquecida"
//            4 -> "Fila de impressão muito grande"
//            5 -> "Parâmetros incorretos"
//            10 -> "Porta da impressora aberta"
//            11 -> "Temperatura baixa demais para impressão"
//            12 -> "Sem bateria suficiente para impressão"
//            13 -> "Motor de passo com problemas"
//            15 -> "Sem bobina"
//            16 -> "Bobina acabando"
//            17 -> "Bobina travada"
//            else -> "Erro desconhecido ($cause)"
//        }
//    }
//
//     fun onDestroy() {
//        val tag = javaClass.name
//        try {
//            if (PosDigital.getInstance().isInitiated)
//                PosDigital.unregister(activity.applicationContext)
//        } catch (e: Exception) {
//            Log.e(tag, "Erro de exception no Destroy da Activity: ${e.message}")
//        }
//    }
//
//
//     private fun sendMessageToFlutter(message: Any) {
//         activity.runOnUiThread {
//             methodChannel?.invokeMethod("printerResult", message)
//         }
//     }
// }
//