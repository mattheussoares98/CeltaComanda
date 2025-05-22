// package br.com.celtaware.comanda.getnet

// import android.app.Activity
// import android.content.Intent
// import android.net.Uri
// import android.os.Bundle
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel
// import io.flutter.plugin.common.MethodChannel.MethodCallHandler
// import io.flutter.plugin.common.MethodChannel.Result

// class GetNetPaymentHandler(private val activity: Activity) : MethodCallHandler {

//     private val CHANNEL = "sample.android/deeplink"
//     private var channel: MethodChannel? = null
//     private var callback: Result? = null
//     private var requestCode: Int = -1

//     fun setupMethodChannel(flutterEngine: FlutterEngine) {
//         channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//         channel?.setMethodCallHandler(this)
//     }

//     override fun onMethodCall(call: MethodCall, result: Result) {
//         var action = ""
//         var deeplink = ""
//         val bundle = Bundle()

//         when (call.method) {
//             "startActivityForResult" -> {
//                 callback = result
//                 val params = call.arguments as? Map<String, Any>
//                 params?.forEach { (key, value) ->
//                     when (key) {
//                         "action" -> action = value.toString()
//                         "data" -> deeplink = value.toString()
//                         "requestCode" -> requestCode = value.toString().toInt()
//                         "arguments" -> {
//                             val args = value as Map<String, Any>
//                             args.forEach { (argKey, argValue) ->
//                                 when (argValue) {
//                                     is String -> bundle.putString(argKey, argValue)
//                                     is Int -> bundle.putInt(argKey, argValue)
//                                     is Boolean -> bundle.putBoolean(argKey, argValue)
//                                 }
//                             }
//                         }
//                     }
//                 }

//                 val intent = Intent(action, Uri.parse(deeplink)).apply {
//                     putExtras(bundle)
//                 }
//                 activity.startActivityForResult(intent, requestCode)
//             }

//             else -> result.notImplemented()
//         }
//     }

//     fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//         if (this.requestCode == requestCode) {
//             if (resultCode == Activity.RESULT_OK) {
//                 val extras = data?.extras
//                 if (extras != null) {
//                     val resultMap = HashMap<String, Any?>()
//                     for (key in extras.keySet()) {
//                         resultMap[key] = extras.get(key)
//                     }
//                     callback?.success(resultMap)
//                 }
//             } else {
//                 callback?.error("ERROR", "No valid return from DeepLink", null)
//             }
//         } else {
//             callback?.error("ERROR", "Activity result was not OK", null)
//         }
//     }
// }
