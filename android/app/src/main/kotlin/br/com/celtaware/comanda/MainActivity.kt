// package br.com.celtaware.comanda

// import android.content.Intent
// import android.os.Bundle
// import android.util.Log
// // import br.com.celtaware.comanda.getnet_channel.GetNetPayment
// // import br.com.celtaware.comanda.getnet_channel.GetNetPrinter
// //import br.com.celtaware.comanda.rede_channel.RedePayment
// //import br.com.celtaware.comanda.rede_channel.RedePrinter
// import br.com.celtaware.comanda.utils.AppUtils
// import br.com.celtaware.comanda.utils.OrientationUtils
// import br.com.celtaware.comanda.utils.PersistentChannelManager
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine

// //import org.koin.android.ext.android.inject
// //import rede.smartrede.commons.contract.ITerminalFunctions
// //import rede.smartrede.sdk.RedePayments

// class MainActivity : FlutterActivity() {
// //    private val redePayments: RedePayments by inject()
// //    private val terminalFunctions: ITerminalFunctions by inject()

//     //    private lateinit var redePrinter: RedePrinter
//     private lateinit var persistentChannelManager: PersistentChannelManager

//     //    private lateinit var redePaymentHandler: RedePayment
//     // private lateinit var getnetPayment: GetNetPayment
//     // private lateinit var getnetPrinter: GetNetPrinter
//     private var engine: FlutterEngine? = null

//     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//         engine = flutterEngine
//         super.configureFlutterEngine(flutterEngine)
//         persistentChannelManager = PersistentChannelManager(flutterEngine)

// //        redePaymentHandler = RedePayment(this, redePayments, flutterEngine)
// //        redePaymentHandler.setupMethodChannel()

// //        redePrinter = RedePrinter(flutterEngine, terminalFunctions.getConnectorPrinter())
// //        redePrinter.setupMethodChannel()

//         // getnetPayment = GetNetPayment(this, flutterEngine)
//         // getnetPayment.setupMethodChannel()

//         // getnetPrinter = GetNetPrinter(this, flutterEngine)
//         // getnetPrinter.setupMethodChannel()
//     }

//     override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//         super.onActivityResult(requestCode, resultCode, data)
// //        redePaymentHandler.handleActivityResult(requestCode, resultCode, data)
//         // getnetPayment.handleActivityResult(requestCode, resultCode, data)
//     }

//     override fun onCreate(savedInstanceState: Bundle?) {
//         super.onCreate(savedInstanceState)

//         OrientationUtils.doOrientation(this)
//     }

//     override fun onPause() {
//         super.onPause()
//         if (persistentChannelManager.isPersistApp()) {
//             AppUtils.bringAppToFront(this)
//         }
//     }

//     override fun onStop() {
//         super.onStop()
//         if (persistentChannelManager.isPersistApp()) {
//             AppUtils.bringAppToFront(this)
//         }
//     }

//     override fun onNewIntent(intent: Intent) {
//         super.onNewIntent(intent)
//         if (Intent.ACTION_MAIN == intent.action && persistentChannelManager.isPersistApp()) {
//             Log.i("MyLauncher", "onNewIntent: HOME Key")
//         }
//     }


//     override fun onDestroy() {
//         super.onDestroy()
//         // getnetPayment.onDestroy()
//         // getnetPrinter.onDestroy()
//     }
// }
