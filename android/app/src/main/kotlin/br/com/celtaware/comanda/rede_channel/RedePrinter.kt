package br.com.celtaware.comanda.rede_channel

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import rede.smartrede.commons.callback.IPrinterCallback
import rede.smartrede.commons.contract.IConnectorPrinter


class RedePrinter(
    private val flutterEngine: FlutterEngine,
    private val connectorPrinter: IConnectorPrinter,
) {
    private val channel: String = "rede_printer"

    fun setupMethodChannel() {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, channel
        ).setMethodCallHandler { call, _ ->
            if (call.method == "sendBitmap") {
                val bitmapBytes = call.argument<ByteArray>("bitmap")
                if (bitmapBytes != null) {
                    val bitmap = BitmapFactory.decodeByteArray(
                        bitmapBytes, 0, bitmapBytes.size
                    )
                    Log.d("MainActivity", "Bitmap received: ${bitmap.height}x${bitmap.width}")

                    try {
                        print(bitmap)

                    } catch (e: Exception) {
                        Log.e("MainActivity", "Error sending bitmap to printer: ${e.message}")
                    }
                } else {
                    Log.e("MainActivity", "Bitmap bytes are null")
                }
            }
        }
    }

    private fun print(bitmap: Bitmap) {
        postToWorkerThread {
            try {
                val callback: IPrinterCallback = PrinterCallbackImpl()
                with(connectorPrinter) {
                    setPrinterCallback(callback)
                    printBitmap(bitmap)
                }
            } catch (exception: Exception) {
                Log.e(javaClass.simpleName, exception.message.orEmpty())
            }
        }
    }

    private fun postToWorkerThread(command: Runnable) {
        Thread(command).start()
    }

    class PrinterCallbackImpl : IPrinterCallback {
        override fun onCompleted() {
            println("Print completed successfully!")
        }

        override fun onError(errorMessage: String) {
            println("Error occurred during printing: $errorMessage")
        }
    }
}

