// package br.com.celtaware.comanda.rede_channel

// import android.graphics.Bitmap
// import android.graphics.BitmapFactory
// import android.util.Log
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel
// import rede.smartrede.commons.callback.IPrinterCallback
// import rede.smartrede.commons.contract.IConnectorPrinter

// import android.os.Handler
// import android.os.Looper

// class RedePrinter(
//     private val flutterEngine: FlutterEngine,
//     private val connectorPrinter: IConnectorPrinter,
// ) {
//     private val channel: String = "redePrinter"
//     private val mainHandler = Handler(Looper.getMainLooper())

//     fun setupMethodChannel() {
//         MethodChannel(
//             flutterEngine.dartExecutor.binaryMessenger, channel
//         ).setMethodCallHandler { call, _ ->
//             if (call.method == "printBitmap") {
//                 val bitmapBytes = call.argument<ByteArray>("bitmap")
//                 if (bitmapBytes != null) {
//                     val bitmap = BitmapFactory.decodeByteArray(
//                         bitmapBytes, 0, bitmapBytes.size
//                     )
//                     Log.d("MainActivity", "Bitmap received: ${bitmap.height}x${bitmap.width}")

//                     try {
//                         print(bitmap)

//                     } catch (e: Exception) {
//                         Log.e("MainActivity", "Error sending bitmap to printer: ${e.message}")
//                     }
//                 } else {
//                     Log.e("MainActivity", "Bitmap bytes are null")
//                 }
//             }
//         }
//     }

//     private fun sendMessageToFlutter(message: String) {
//         mainHandler.post {
//             try {
//                 val methodChannel =
//                     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
//                 methodChannel.invokeMethod("printerResult", message)
//             } catch (exception: Exception) {
//                 Log.e(javaClass.simpleName, exception.message.orEmpty())
//             }
//         }
//     }

//     private fun print(bitmap: Bitmap) {
//         mainHandler.post {
//             try {
//                 val callback: IPrinterCallback =
//                     PrinterCallbackImpl(
//                         flutterEngine = flutterEngine,
//                         channel = channel
//                     )
//                 with(connectorPrinter) {
//                     setPrinterCallback(callback)
//                     printBitmap(bitmap)
//                 }
//                 sendMessageToFlutter("Success")
//             } catch (exception: Exception) {
//                 Log.e(javaClass.simpleName, exception.message.orEmpty())
//                 sendMessageToFlutter("Error")
//             }
//         }
//     }

//     class PrinterCallbackImpl(
//         private val channel: String = "redePrinter",
//         private val flutterEngine: FlutterEngine,
//     ) : IPrinterCallback {
//         private val mainHandler = Handler(Looper.getMainLooper())

//         private fun sendMessageToFlutter(message: String) {
//             mainHandler.post {
//                 val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
//                 methodChannel.invokeMethod("printerResult", message)
//             }
//         }

//         override fun onCompleted() {
//             println("Print completed successfully!")
//             sendMessageToFlutter("Success")
//         }

//         override fun onError(errorMessage: String) {
//             println("Error occurred during printing: $errorMessage")
//             sendMessageToFlutter("Error")
//         }
//     }
// }
