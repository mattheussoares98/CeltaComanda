package br.com.celtaware.comanda

import android.content.Intent
import android.os.Bundle
import android.util.Log
// [GETNET-IMPORTS-START]
// import br.com.celtaware.comanda.getnet.GetNetPaymentHandler
// import br.com.celtaware.comanda.getnet_channel.GetNetPrinter
// [GETNET-IMPORTS-END]
// [REDE-IMPORTS-START]
// import br.com.celtaware.comanda.rede_channel.RedePayment
// import br.com.celtaware.comanda.rede_channel.RedePrinter
// import org.koin.android.ext.android.inject
// import rede.smartrede.commons.contract.ITerminalFunctions
// import rede.smartrede.sdk.RedePayments
// [REDE-IMPORTS-END]
// [CIELO-IMPORTS-START]
// import br.com.celtaware.comanda.cielo_channel.CieloPayment
// import br.com.celtaware.comanda.cielo_channel.CieloPrinter
// [CIELO-IMPORTS-END]
import br.com.celtaware.comanda.utils.AppUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    // [REDE-VARS-START]
   // private val redePayments: RedePayments by inject()
   // private val terminalFunctions: ITerminalFunctions by inject()
   // private lateinit var redePrinter: RedePrinter
   // private lateinit var redePaymentHandler: RedePayment
    // [REDE-VARS-END]

    // [GETNET-VARS-START]
    // private lateinit var getnetPaymentHandler: GetNetPaymentHandler
    // private lateinit var getnetPrinter: GetNetPrinter
    // [GETNET-VARS-END]

    // [CIELO-VARS-START]
    // private lateinit var cieloPaymentHandler: CieloPayment
    // private lateinit var cieloPrinter: CieloPrinter
    // [CIELO-VARS-END]

    private var engine: FlutterEngine? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        engine = flutterEngine
        super.configureFlutterEngine(flutterEngine)

        // [REDE-SETUP-START]
       // redePaymentHandler = RedePayment(this, redePayments, flutterEngine)
       // redePaymentHandler.setupMethodChannel()
// 
       // redePrinter = RedePrinter(flutterEngine, terminalFunctions.getConnectorPrinter())
       // redePrinter.setupMethodChannel()
        // [REDE-SETUP-END]

        // [GETNET-SETUP-START]
        // getnetPaymentHandler = GetNetPaymentHandler(this)
        // getnetPaymentHandler.setupMethodChannel(flutterEngine)
        // getnetPrinter = GetNetPrinter(this, flutterEngine)
        // getnetPrinter.setupMethodChannel()
        // [GETNET-SETUP-END]

        // [CIELO-SETUP-START]
        // cieloPaymentHandler = CieloPayment(this)
        // cieloPaymentHandler.setupMethodChannel(flutterEngine)
// 
        // cieloPrinter = CieloPrinter(this, flutterEngine)
        // cieloPrinter.setupMethodChannel()
        // [CIELO-SETUP-END]
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        // [REDE-RESULT-START]
       // redePaymentHandler.handleActivityResult(requestCode, resultCode, data)
        // [REDE-RESULT-END]
        // [GETNET-RESULT-START]
        // getnetPaymentHandler.handleActivityResult(requestCode, resultCode, data)
        // [GETNET-RESULT-END]
        // [CIELO-RESULT-START]
        // cieloPaymentHandler.handleActivityResult(requestCode, resultCode, data)
        // cieloPrinter.handleActivityResult(requestCode, resultCode, data)
        // [CIELO-RESULT-END]
    }

    // [CIELO-PERMISSION-RESULT-START]
    // override fun onRequestPermissionsResult(
        // requestCode: Int,
        // permissions: Array<out String>,
        // grantResults: IntArray,
    // ) {
        // super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        // cieloPrinter.onRequestPermissionsResult(requestCode, grantResults)
    // }
    // [CIELO-PERMISSION-RESULT-END]

    override fun onNewIntent(intent: Intent) {
        // [CIELO-INTENT-START]
        // if (Intent.ACTION_VIEW == intent.action) {
            // val scheme = intent.data?.scheme
            // val host = intent.data?.host
            // if (scheme == "order" && host == "response") {
                // cieloPaymentHandler.handleDeepLinkResponse(intent)
                // cieloPrinter.handleDeepLinkResponse(intent)
                // return
            // }
        // }
        // [CIELO-INTENT-END]

        super.onNewIntent(intent)
    }


    override fun onDestroy() {
        super.onDestroy()
        // [GETNET-DESTROY-START]
        // getnetPrinter.onDestroy()
        // [GETNET-DESTROY-END]
    }
}
