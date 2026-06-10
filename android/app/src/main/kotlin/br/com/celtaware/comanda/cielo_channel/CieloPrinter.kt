package br.com.celtaware.comanda.cielo_channel

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.util.Base64
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

class CieloPrinter(
    private val activity: Activity,
    private val flutterEngine: FlutterEngine,
) {
    private val channel: String = "printer"
    private val TAG = "CieloPrinter"
    private var methodChannel: MethodChannel? = null

    companion object {
        const val CIELO_PRINT_REQUEST_CODE = 20002
    }

    fun setupMethodChannel() {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "printBitmap" -> {
                    // Cielo does not support direct bitmap printing via deep link.
                    // The approach is to save the bitmap to a file and use PRINT_IMAGE.
                    val bitmapBytes = call.argument<ByteArray>("bitmap")
                    if (bitmapBytes != null) {
                        try {
                            val filePath = saveBitmapToFile(bitmapBytes)
                            if (filePath != null) {
                                printImage(filePath)
                                result.success(null)
                            } else {
                                result.error("PRINTER_ERROR", "Failed to save bitmap to file", null)
                            }
                        } catch (e: Exception) {
                            Log.e(TAG, "Error printing bitmap: ${e.message}")
                            result.error("PRINTER_ERROR", e.message, null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "Bitmap bytes are null", null)
                    }
                }
                "printText" -> {
                    val text = call.argument<String>("text")
                    if (text != null) {
                        try {
                            printText(text)
                            result.success(null)
                        } catch (e: Exception) {
                            Log.e(TAG, "Error printing text: ${e.message}")
                            result.error("PRINTER_ERROR", e.message, null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "Text is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun saveBitmapToFile(bitmapBytes: ByteArray): String? {
        return try {
            val file = java.io.File(
                activity.cacheDir,
                "cielo_print_${System.currentTimeMillis()}.png"
            )
            java.io.FileOutputStream(file).use { fos ->
                val bitmap = android.graphics.BitmapFactory.decodeByteArray(
                    bitmapBytes, 0, bitmapBytes.size
                )
                bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, fos)
                bitmap.recycle()
            }
            Log.d(TAG, "Bitmap saved to: ${file.absolutePath}")
            file.absolutePath
        } catch (e: Exception) {
            Log.e(TAG, "Error saving bitmap: ${e.message}")
            null
        }
    }

    private fun printImage(filePath: String) {
        val jsonObject = JSONObject().apply {
            put("operation", "PRINT_IMAGE")
            put("styles", JSONArray().put(JSONObject().apply {
                put("form_feed", 1)
            }))
            put("value", JSONArray().put(filePath))
        }

        launchPrintIntent(jsonObject)
    }

    private fun printText(text: String) {
        val jsonObject = JSONObject().apply {
            put("operation", "PRINT_TEXT")
            put("styles", JSONArray().put(JSONObject()))
            put("value", JSONArray().put(text))
        }

        launchPrintIntent(jsonObject)
    }

    private fun launchPrintIntent(jsonObject: JSONObject) {
        val jsonString = jsonObject.toString()
        val base64 = Base64.encodeToString(
            jsonString.toByteArray(Charsets.UTF_8),
            Base64.NO_WRAP
        )

        val printUri = "lio://print?request=$base64&urlCallback=order://response"

        Log.d(TAG, "Print URI: $printUri")

        try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(printUri))
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            activity.startActivityForResult(intent, CIELO_PRINT_REQUEST_CODE)
        } catch (e: Exception) {
            Log.e(TAG, "Error launching print intent: ${e.message}")
            sendMessageToFlutter("Error: ${e.message}")
        }
    }

    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode != CIELO_PRINT_REQUEST_CODE) return

        try {
            if (resultCode == Activity.RESULT_OK && data?.data != null) {
                val uri = data.data
                val response = uri?.getQueryParameter("response")

                if (response != null) {
                    val decodedBytes = Base64.decode(response, Base64.DEFAULT)
                    val jsonString = String(decodedBytes, Charsets.UTF_8)
                    Log.d(TAG, "Print response: $jsonString")

                    // Check if response contains an error
                    try {
                        val jsonResponse = JSONObject(jsonString)
                        if (jsonResponse.has("code")) {
                            val code = jsonResponse.getInt("code")
                            val reason = jsonResponse.optString("reason", "Unknown error")
                            if (code != 0) {
                                sendMessageToFlutter("Error: $reason")
                                return
                            }
                        }
                    } catch (e: Exception) {
                        // Not an error JSON, might be success
                    }
                    sendMessageToFlutter("Success")
                } else {
                    sendMessageToFlutter("Success")
                }
            } else if (resultCode == Activity.RESULT_CANCELED) {
                sendMessageToFlutter("Error: Print canceled")
            } else {
                sendMessageToFlutter("Error: Unexpected result")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling print result: ${e.message}")
            sendMessageToFlutter("Error: ${e.message}")
        }
    }

    /**
     * Handle deep link response for print callback.
     */
    fun handleDeepLinkResponse(intent: Intent) {
        try {
            if (Intent.ACTION_VIEW == intent.action) {
                val uri = intent.data
                val response = uri?.getQueryParameter("response")

                if (response != null) {
                    val decodedBytes = Base64.decode(response, Base64.DEFAULT)
                    val jsonString = String(decodedBytes, Charsets.UTF_8)
                    Log.d(TAG, "Deep link print response: $jsonString")

                    try {
                        val jsonResponse = JSONObject(jsonString)
                        if (jsonResponse.has("code")) {
                            val code = jsonResponse.getInt("code")
                            val reason = jsonResponse.optString("reason", "Unknown error")
                            if (code != 0) {
                                sendMessageToFlutter("Error: $reason")
                                return
                            }
                        }
                    } catch (e: Exception) {
                        // Not an error JSON
                    }
                    sendMessageToFlutter("Success")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling deep link print response: ${e.message}")
            sendMessageToFlutter("Error: ${e.message}")
        }
    }

    private fun sendMessageToFlutter(message: Any) {
        activity.runOnUiThread {
            methodChannel?.invokeMethod("printerResult", message)
        }
    }
}