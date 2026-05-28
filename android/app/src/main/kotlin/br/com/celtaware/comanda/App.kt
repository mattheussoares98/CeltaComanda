package br.com.celtaware.comanda


import android.app.Application
// [REDE-IMPORTS-START]
// import rede.smartrede.sdk.api.IRedeSdk
// import org.koin.android.ext.koin.androidContext
// import org.koin.android.ext.koin.androidLogger
// import org.koin.core.context.GlobalContext.startKoin
// import org.koin.dsl.module
// import rede.smartrede.commons.contract.ITerminalFunctions
// [REDE-IMPORTS-END]

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        // [REDE-SETUP-START]
       // startKoin {
           // androidLogger()
           // androidContext(this@App)
           // modules(appModule)
       // }
        // [REDE-SETUP-END]
    }

    // [REDE-MODULE-START]
   // private val appModule = module {
       // single { IRedeSdk.newInstance(androidContext()) }
       // single { get<IRedeSdk>().getRedePayments(androidContext()) }
       // single { get<IRedeSdk>().getTerminalFunctions() }
       // single { get<ITerminalFunctions>().getConnectorPrinter() }
   // }
    // [REDE-MODULE-END]
}
