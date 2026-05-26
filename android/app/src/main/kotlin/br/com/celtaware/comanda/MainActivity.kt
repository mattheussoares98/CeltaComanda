package br.com.celtaware.comanda

import android.content.Intent
import android.os.Bundle
import android.util.Log
// import br.com.celtaware.comanda.getnet.GetNetPaymentHandler
// import br.com.celtaware.comanda.getnet_channel.GetNetPrinter
//import br.com.celtaware.comanda.rede_channel.RedePayment
//import br.com.celtaware.comanda.rede_channel.RedePrinter
import br.com.celtaware.comanda.cielo_channel.CieloPayment
import br.com.celtaware.comanda.cielo_channel.CieloPrinter
import br.com.celtaware.comanda.utils.AppUtils
import br.com.celtaware.comanda.utils.PersistentChannelManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

//import org.koin.android.ext.android.inject
//import rede.smartrede.commons.contract.ITerminalFunctions
//import rede.smartrede.sdk.RedePayments

class MainActivity : FlutterActivity() {
//    private val redePayments: RedePayments by inject()
//    private val terminalFunctions: ITerminalFunctions by inject()

    //    private lateinit var redePrinter: RedePrinter
    private lateinit var persistentChannelManager: PersistentChannelManager

    //    private lateinit var redePaymentHandler: RedePayment
    // private lateinit var getnetPaymentHandler: GetNetPaymentHandler

    // private lateinit var getnetPrinter: GetNetPrinter

    private lateinit var cieloPaymentHandler: CieloPayment
    private lateinit var cieloPrinter: CieloPrinter

    private var engine: FlutterEngine? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        engine = flutterEngine
        super.configureFlutterEngine(flutterEngine)
        persistentChannelManager = PersistentChannelManager(flutterEngine)

//        redePaymentHandler = RedePayment(this, redePayments, flutterEngine)
//        redePaymentHandler.setupMethodChannel()

//        redePrinter = RedePrinter(flutterEngine, terminalFunctions.getConnectorPrinter())
//        redePrinter.setupMethodChannel()

        // getnetPaymentHandler = GetNetPaymentHandler(this)
        // getnetPaymentHandler.setupMethodChannel(flutterEngine)

        // getnetPrinter = GetNetPrinter(this, flutterEngine)
        // getnetPrinter.setupMethodChannel()

        cieloPaymentHandler = CieloPayment(this)
        cieloPaymentHandler.setupMethodChannel(flutterEngine)

        cieloPrinter = CieloPrinter(this, flutterEngine)
        cieloPrinter.setupMethodChannel()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
//        redePaymentHandler.handleActivityResult(requestCode, resultCode, data)
        // getnetPaymentHandler.handleActivityResult(requestCode, resultCode, data)
        cieloPaymentHandler.handleActivityResult(requestCode, resultCode, data)
        cieloPrinter.handleActivityResult(requestCode, resultCode, data)
    }

    override fun onPause() {
        super.onPause()
        if (persistentChannelManager.isPersistApp()) {
            AppUtils.bringAppToFront(this)
        }
    }

    override fun onStop() {
        super.onStop()
        if (persistentChannelManager.isPersistApp()) {
            AppUtils.bringAppToFront(this)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        // Handle Cielo deep link responses (order://response)
        if (Intent.ACTION_VIEW == intent.action) {
            val scheme = intent.data?.scheme
            val host = intent.data?.host
            if (scheme == "order" && host == "response") {
                cieloPaymentHandler.handleDeepLinkResponse(intent)
                cieloPrinter.handleDeepLinkResponse(intent)
            }
        }

        if (Intent.ACTION_MAIN == intent.action && persistentChannelManager.isPersistApp()) {
            Log.i("MyLauncher", "onNewIntent: HOME Key")
        }
    }


    override fun onDestroy() {
        super.onDestroy()
        // getnetPrinter.onDestroy()
    }
}
