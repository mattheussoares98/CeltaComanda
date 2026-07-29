package br.com.celtaware.comanda.cielo_channel

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.Settings
import android.util.Base64
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import org.json.JSONArray
import org.json.JSONObject

class CieloPrinter(
    private val activity: Activity,
    private val flutterEngine: FlutterEngine,
) {
    companion object {
        private const val REQUEST_WRITE_EXTERNAL_STORAGE = 7101
        private const val REQUEST_MANAGE_EXTERNAL_STORAGE = 7102
    }

    private val channel: String = "printer"
    private val TAG = "CieloPrinter"
    private var methodChannel: MethodChannel? = null
    private var printStartTime: Long = 0
    private var pendingBitmapBytes: ByteArray? = null
    private var pendingPrintResult: MethodChannel.Result? = null
    private var activePrintFile: File? = null

    fun setupMethodChannel() {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "printBitmap" -> {
                    // Cielo does not support direct bitmap printing via deep link.
                    // The approach is to save the bitmap to a file and use PRINT_IMAGE.
                    val bitmapBytes = call.argument<ByteArray>("bitmap")
                    if (bitmapBytes != null) {
                        handlePrintBitmap(bitmapBytes, result)
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

    private fun handlePrintBitmap(
        bitmapBytes: ByteArray,
        result: MethodChannel.Result,
    ) {
        if (pendingPrintResult != null) {
            result.error(
                "PRINTER_PERMISSION_REQUEST_IN_PROGRESS",
                "A printer storage permission request is already in progress.",
                diagnosticDetails(stage = "request_permission"),
            )
            return
        }

        if (requestStorageAccessIfNeeded(bitmapBytes, result)) {
            return
        }

        executePrintBitmap(bitmapBytes, result)
    }

    private fun requestStorageAccessIfNeeded(
        bitmapBytes: ByteArray,
        result: MethodChannel.Result,
    ): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R &&
            !Environment.isExternalStorageManager()
        ) {
            pendingBitmapBytes = bitmapBytes
            pendingPrintResult = result

            try {
                val intent = Intent(
                    Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION,
                    Uri.parse("package:${activity.packageName}"),
                )
                activity.startActivityForResult(intent, REQUEST_MANAGE_EXTERNAL_STORAGE)
            } catch (e: Exception) {
                pendingBitmapBytes = null
                pendingPrintResult = null
                result.error(
                    "PRINTER_PERMISSION_REQUEST_ERROR",
                    "Could not open the All files access settings: ${e.message ?: e.javaClass.name}",
                    diagnosticDetails(
                        stage = "request_manage_external_storage",
                        exception = e,
                    ),
                )
            }
            return true
        }

        if (Build.VERSION.SDK_INT in Build.VERSION_CODES.M..Build.VERSION_CODES.Q &&
            activity.checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            pendingBitmapBytes = bitmapBytes
            pendingPrintResult = result
            activity.requestPermissions(
                arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                REQUEST_WRITE_EXTERNAL_STORAGE,
            )
            return true
        }

        return false
    }

    private fun executePrintBitmap(
        bitmapBytes: ByteArray,
        result: MethodChannel.Result,
    ) {
        try {
            val filePath = saveBitmapToFile(bitmapBytes)
            activePrintFile = File(filePath)
            printImage(filePath)
            result.success(null)
        } catch (e: PrinterException) {
            deleteActivePrintFile()
            Log.e(TAG, e.message, e)
            result.error(e.code, e.message, e.details)
        } catch (e: Exception) {
            deleteActivePrintFile()
            val details = diagnosticDetails(
                stage = "unexpected",
                exception = e,
            )
            Log.e(TAG, "Unexpected error printing bitmap", e)
            result.error(
                "PRINTER_UNEXPECTED_ERROR",
                "Unexpected error printing bitmap: ${e.message ?: e.javaClass.name}",
                details,
            )
        }
    }

    private fun saveBitmapToFile(bitmapBytes: ByteArray): String {
        validateStorageAccess()

        val savedImagesDir = File(
            Environment.getExternalStorageDirectory(),
            "saved_images",
        )

        if (!savedImagesDir.exists() && !savedImagesDir.mkdirs()) {
            throw printerException(
                code = "PRINTER_DIRECTORY_ERROR",
                stage = "create_directory",
                message = "Could not create the Cielo image directory.",
                path = savedImagesDir.absolutePath,
            )
        }
        if (!savedImagesDir.isDirectory) {
            throw printerException(
                code = "PRINTER_DIRECTORY_ERROR",
                stage = "validate_directory",
                message = "The Cielo image path exists but is not a directory.",
                path = savedImagesDir.absolutePath,
            )
        }

        cleanStalePrintFiles(savedImagesDir)

        val bitmap = BitmapFactory.decodeByteArray(bitmapBytes, 0, bitmapBytes.size)
            ?: throw printerException(
                code = "PRINTER_BITMAP_DECODE_ERROR",
                stage = "decode_bitmap",
                message = "Android could not decode the ${bitmapBytes.size}-byte image.",
                path = savedImagesDir.absolutePath,
            )

        val file = File(
            savedImagesDir,
            "cielo_print_${System.currentTimeMillis()}.png",
        )

        try {
            FileOutputStream(file).use { output ->
                val compressed = bitmap.compress(
                    android.graphics.Bitmap.CompressFormat.PNG,
                    100,
                    output,
                )
                if (!compressed) {
                    throw printerException(
                        code = "PRINTER_BITMAP_COMPRESSION_ERROR",
                        stage = "compress_bitmap",
                        message = "Android failed to compress the bitmap as PNG.",
                        path = file.absolutePath,
                    )
                }
            }
        } catch (e: PrinterException) {
            throw e
        } catch (e: Exception) {
            throw printerException(
                code = "PRINTER_FILE_WRITE_ERROR",
                stage = "write_file",
                message = "Could not write the bitmap file: ${e.message ?: e.javaClass.name}",
                path = file.absolutePath,
                cause = e,
            )
        } finally {
            bitmap.recycle()
        }

        if (!file.exists() || !file.isFile || file.length() == 0L || !file.canRead()) {
            throw printerException(
                code = "PRINTER_FILE_VALIDATION_ERROR",
                stage = "validate_file",
                message = "The bitmap file was created but is missing, empty, or unreadable.",
                path = file.absolutePath,
            )
        }

        Log.d(TAG, "Bitmap saved to: ${file.absolutePath} (${file.length()} bytes)")
        return file.absolutePath
    }

    private fun cleanStalePrintFiles(savedImagesDir: File) {
        savedImagesDir.listFiles()
            ?.filter {
                it.isFile &&
                    it.name.startsWith("cielo_print_") &&
                    it.name.endsWith(".png") &&
                    it.absolutePath != activePrintFile?.absolutePath
            }
            ?.forEach { staleFile ->
                if (!staleFile.delete()) {
                    Log.w(TAG, "Could not delete stale print file: ${staleFile.absolutePath}")
                }
            }
    }

    private fun deleteActivePrintFile() {
        val file = activePrintFile ?: return
        if (file.exists() && !file.delete()) {
            Log.w(TAG, "Could not delete print file: ${file.absolutePath}")
        }
        activePrintFile = null
    }

    private fun validateStorageAccess() {
        if (Environment.getExternalStorageState() != Environment.MEDIA_MOUNTED) {
            throw printerException(
                code = "PRINTER_STORAGE_UNAVAILABLE",
                stage = "validate_storage",
                message = "Shared external storage is not mounted for writing.",
            )
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R &&
            !Environment.isExternalStorageManager()
        ) {
            throw printerException(
                code = "PRINTER_STORAGE_PERMISSION_REQUIRED",
                stage = "validate_permission",
                message = "All files access is not granted. Enable it for Celta Comanda in Android settings.",
            )
        }

        if (Build.VERSION.SDK_INT in Build.VERSION_CODES.M..Build.VERSION_CODES.Q &&
            activity.checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            throw printerException(
                code = "PRINTER_STORAGE_PERMISSION_REQUIRED",
                stage = "validate_permission",
                message = "Storage permission is not granted. Grant it to Celta Comanda and try again.",
            )
        }
    }

    private fun printerException(
        code: String,
        stage: String,
        message: String,
        path: String? = null,
        cause: Throwable? = null,
    ) = PrinterException(
        code = code,
        message = "$message Stage: $stage.",
        details = diagnosticDetails(stage, path, cause),
        cause = cause,
    )

    private fun diagnosticDetails(
        stage: String,
        path: String? = null,
        exception: Throwable? = null,
    ): Map<String, Any?> = mapOf(
        "stage" to stage,
        "path" to path,
        "androidSdk" to Build.VERSION.SDK_INT,
        "storageState" to Environment.getExternalStorageState(),
        "isExternalStorageManager" to
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                Environment.isExternalStorageManager()
            } else {
                null
            },
        "hasWriteExternalStoragePermission" to
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                activity.checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) ==
                    PackageManager.PERMISSION_GRANTED
            } else {
                true
            },
        "exceptionType" to exception?.javaClass?.name,
        "exceptionMessage" to exception?.message,
    )

    private class PrinterException(
        val code: String,
        override val message: String,
        val details: Map<String, Any?>,
        cause: Throwable? = null,
    ) : Exception(message, cause)

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
            printStartTime = System.currentTimeMillis()
            activity.startActivity(intent)
        } catch (e: Exception) {
            throw printerException(
                code = "PRINTER_INTENT_ERROR",
                stage = "launch_print_intent",
                message = "Could not launch the Cielo printer: ${e.message ?: e.javaClass.name}",
                cause = e,
            )
        }
    }

    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQUEST_MANAGE_EXTERNAL_STORAGE) {
            resumePendingPrint(
                granted = Build.VERSION.SDK_INT >= Build.VERSION_CODES.R &&
                    Environment.isExternalStorageManager(),
                denialMessage = "All files access was not granted.",
            )
        }
    }

    fun onRequestPermissionsResult(
        requestCode: Int,
        grantResults: IntArray,
    ) {
        if (requestCode == REQUEST_WRITE_EXTERNAL_STORAGE) {
            resumePendingPrint(
                granted = grantResults.isNotEmpty() &&
                    grantResults[0] == PackageManager.PERMISSION_GRANTED,
                denialMessage = "Storage permission was denied.",
            )
        }
    }

    private fun resumePendingPrint(
        granted: Boolean,
        denialMessage: String,
    ) {
        val bitmapBytes = pendingBitmapBytes
        val result = pendingPrintResult
        pendingBitmapBytes = null
        pendingPrintResult = null

        if (bitmapBytes == null || result == null) {
            return
        }

        if (granted) {
            executePrintBitmap(bitmapBytes, result)
        } else {
            val error = printerException(
                code = "PRINTER_STORAGE_PERMISSION_REQUIRED",
                stage = "request_permission",
                message = denialMessage,
            )
            result.error(error.code, error.message, error.details)
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
                    try {
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
                    } finally {
                        deleteActivePrintFile()
                    }
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
