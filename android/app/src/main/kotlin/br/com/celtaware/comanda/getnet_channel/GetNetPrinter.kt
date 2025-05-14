package br.com.celtaware.comanda.getnet_channel

import android.app.Activity
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.RemoteException
import android.util.Log
import com.getnet.posdigital.PosDigital
import com.getnet.posdigital.printer.AlignMode
import com.getnet.posdigital.printer.IPrinterCallback
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class GetNetPrinter(
    private val activity: Activity,
    private val flutterEngine: FlutterEngine,
) {
    private val channel: String = "printer"


    private val bindCallback: PosDigital.BindCallback
        get() = object : PosDigital.BindCallback {
            override fun onError(e: Exception) {
                if (PosDigital.getInstance().isInitiated)
                    PosDigital.unregister(activity.applicationContext)

                connectPosDigitalService()
            }

            override fun onConnected() {}
            override fun onDisconnected() {
                //TODO send message indicating to try again or automatically try again 3 times
            }
        }

    private fun connectPosDigitalService() {
        PosDigital.register(activity.applicationContext, bindCallback)
    }


    fun setupMethodChannel() {
        connectPosDigitalService()
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, channel
        ).setMethodCallHandler { call, result ->
            if (call.method == "printBitmap") {
                val bitmapBytes = call.argument<ByteArray>("bitmap")
                if (bitmapBytes != null) {
                    val bitmap = BitmapFactory.decodeByteArray(
                        bitmapBytes, 0, bitmapBytes.size
                    )
                    Log.d("MainActivity", "Bitmap received: ${bitmap.height}x${bitmap.width}")

                    try {
                        printReceipt(bitmap);
                    } catch (e: Exception) {
                        Log.e("MainActivity", "Error sending bitmap to printer: ${e.message}")
                    }
                } else {
                    Log.e("MainActivity", "Bitmap bytes are null")
                }
            }
        }
    }

    fun printReceipt(bitmap: Bitmap) {
        if (PosDigital.getInstance().isInitiated) {
            try {
                PosDigital.getInstance().printer.init()
                PosDigital.getInstance().printer.addImageBitmap(AlignMode.CENTER, bitmap)
                PosDigital.getInstance().printer.print(getPrinterCallback())
            } catch (e: Exception) {
                sendMessageToFlutter("Error");
            }
        } else {
            // falha no service de impressão
            // refaça o start da activity que
            // extende a BaseActivity para reconectar o service
            sendMessageToFlutter("Error");
        }
    }


    private fun getPrinterCallback(): IPrinterCallback.Stub {
        return object : IPrinterCallback.Stub() {
            @Throws(RemoteException::class)

            override fun onSuccess() {
                sendMessageToFlutter("Success");
            }

            @Throws(RemoteException::class)

            override fun onError(cause: Int) {
                sendMessageToFlutter("Error");
            }
        }
    }

    fun onDestroy() {
        val tag = javaClass.name
        try {
            if (PosDigital.getInstance().isInitiated)
                PosDigital.unregister(activity.applicationContext)
        } catch (e: Exception) {
            Log.e(tag, "Erro de exception no Destroy da Activity")
        }
    }


    private fun sendMessageToFlutter(message: Any) {
        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        methodChannel.invokeMethod("paymentResult", message)
    }
}
