// package br.com.celtaware.comanda.rede_channel
//
// import android.graphics.Bitmap
// import android.graphics.BitmapFactory
// import android.graphics.Canvas
// import android.graphics.ColorMatrix
// import android.graphics.ColorMatrixColorFilter
// import android.graphics.Paint
// import android.os.Handler
// import android.os.Looper
// import android.util.Log
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel
// import rede.smartrede.commons.callback.IPrinterCallback
// import rede.smartrede.commons.contract.IConnectorPrinter
//
// class RedePrinter(
//     private val flutterEngine: FlutterEngine,
//     private val connectorPrinter: IConnectorPrinter,
// ) {
//     private val channel: String = "printer"
//     private val mainHandler = Handler(Looper.getMainLooper())
//
//     fun setupMethodChannel() {
//         MethodChannel(
//             flutterEngine.dartExecutor.binaryMessenger, channel
//         ).setMethodCallHandler { call, _ ->
//             if (call.method == "printBitmap") {
//                 val bitmapBytes = call.argument<ByteArray>("bitmap")
//                 if (bitmapBytes != null && bitmapBytes.isNotEmpty()) {
//                     try {
//                         // 1. Decode the bitmap from bytes in a memory-safe way, scaled to a standard printer width.
//
//                         val decodedBitmap = decodeSampledBitmapFromBytes(bitmapBytes, 576)
//
//                         if (decodedBitmap != null) {
//                             // 2. Create a mutable copy to ensure it can be drawn on. This is a critical step.
//
//                             val mutableBitmap = decodedBitmap.copy(Bitmap.Config.ARGB_8888, true)
//                             if (decodedBitmap != mutableBitmap) {
//                                 decodedBitmap.recycle() // Free up memory from the original.
//                             }
//
//                             // 3. Convert the mutable bitmap to the required 1-bit monochrome format.
//
//                             val monochromeBitmap = convertToMonochrome(mutableBitmap)
//
//                             Log.d("MainActivity", "Bitmap processed successfully: W=${monochromeBitmap.width}, H=${monochromeBitmap.height}")
//
//                             print(monochromeBitmap)
//                         } else {
//                             Log.e("MainActivity", "Failed to decode bitmap, data might be invalid.")
//                         }
//                     } catch (e: Exception) {
//                         Log.e("MainActivity", "Error processing bitmap: ${e.message}", e)
//                     }
//                 } else {
//                     Log.e("MainActivity", "Bitmap bytes from Flutter are null or empty.")
//                 }
//             }
//         }
//     }
//
//     /**
//      * Converts a bitmap to a true 1-bit black and white format using a hardware-accelerated
// ColorMatrix.
//      * This is fast and produces the correct format for thermal printers.
//      */
//     private fun convertToMonochrome(src: Bitmap): Bitmap {
//         val monochromeBitmap = Bitmap.createBitmap(src.width, src.height, Bitmap.Config.RGB_565)
//         val canvas = Canvas(monochromeBitmap)
//         val paint = Paint()
//
//         // This matrix converts the image to grayscale.
//         val matrixToGrayscale = ColorMatrix().apply {
//             setSaturation(0f)
//         }
//
//         // This matrix applies a high-contrast threshold, forcing pixels to be either pure black or pure white.
//
//         val scale = 255f
//         val translate = -128 * scale
//         val matrixToThreshold = ColorMatrix(floatArrayOf(
//             scale, 0f, 0f, 0f, translate,
//             scale, 0f, 0f, 0f, translate,
//             scale, 0f, 0f, 0f, translate,
//             0f, 0f, 0f, 1f, 0f
//         ))
//
//         // Chain the operations: first grayscale, then threshold.
//         matrixToGrayscale.postConcat(matrixToThreshold)
//         paint.colorFilter = ColorMatrixColorFilter(matrixToGrayscale)
//         canvas.drawBitmap(src, 0f, 0f, paint)
//
//         return monochromeBitmap
//     }
//
//     /**
//      * Decodes a bitmap from a byte array in a memory-efficient way by scaling it down
//      * during decoding to prevent OutOfMemoryErrors.
//      */
//     private fun decodeSampledBitmapFromBytes(bitmapBytes: ByteArray, reqWidth: Int): Bitmap? {
//         // First, decode with inJustDecodeBounds=true to check dimensions without allocating memory.
//
//         val options = BitmapFactory.Options().apply {
//             inJustDecodeBounds = true
//         }
//         BitmapFactory.decodeByteArray(bitmapBytes, 0, bitmapBytes.size, options)
//
//         val srcWidth = options.outWidth
//         if (srcWidth <= 0) return null // Invalid image data.
//
//         // Calculate the scaling factor (inSampleSize).
//         var inSampleSize = 1
//         if (srcWidth > reqWidth) {
//             inSampleSize = (srcWidth.toFloat() / reqWidth.toFloat()).toInt()
//         }
//         options.inSampleSize = if (inSampleSize > 1) inSampleSize else 1
//
//         // Decode the bitmap with the calculated sample size.
//         options.inJustDecodeBounds = false
//         return BitmapFactory.decodeByteArray(bitmapBytes, 0, bitmapBytes.size, options)
//     }
//
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
//
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
//
//     class PrinterCallbackImpl(
//         private val channel: String = "printer",
//         private val flutterEngine: FlutterEngine,
//     ) : IPrinterCallback {
//         private val mainHandler = Handler(Looper.getMainLooper())
//
//         private fun sendMessageToFlutter(message: String) {
//             mainHandler.post {
//                 try {
//                     val methodChannel =
//                         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
//                     methodChannel.invokeMethod("printerResult", message)
//                 }
//                 catch (e: Exception) {
//                     // Ignore exception
//                 }
//             }
//         }
//
//         override fun onCompleted() {
//             println("Print completed successfully!")
//             sendMessageToFlutter("Success")
//         }
//
//         override fun onError(errorMessage: String) {
//             println("Error occurred during printing: $errorMessage")
//             sendMessageToFlutter("Error")
//         }
//     }
// }
