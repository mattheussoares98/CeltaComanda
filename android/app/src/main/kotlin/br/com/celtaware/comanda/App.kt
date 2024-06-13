package br.com.celtaware.comanda

import android.content.ActivityNotFoundException
import android.content.Intent
import android.app.Activity
import android.app.Application
import android.os.Bundle
import android.widget.Toast
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import rede.smartrede.sdk.RedePaymentValidationError
import rede.smartrede.sdk.RedePayments
import rede.smartrede.sdk.FlexTipoPagamento
import rede.smartrede.sdk.api.IRedeSdk
import rede.smartrede.sdk.PaymentStatus
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.androidx.viewmodel.dsl.viewModel
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
