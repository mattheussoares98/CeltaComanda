package br.com.celtaware.comanda


import android.app.Application
import rede.smartrede.sdk.api.IRedeSdk
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.context.GlobalContext.startKoin
import org.koin.dsl.module

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        startKoin {
            androidLogger()
            androidContext(this@App)
            modules(appModule)
        }
    }

    private val appModule = module {
        single { IRedeSdk.newInstance(androidContext()) }
        single { get<IRedeSdk>().getRedePayments(androidContext()) }
        single { get<IRedeSdk>().getTerminalFunctions() }
    }
}
