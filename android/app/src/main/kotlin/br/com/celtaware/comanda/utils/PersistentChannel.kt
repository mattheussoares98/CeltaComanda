package br.com.celtaware.comanda.utils

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.system.exitProcess

class PersistentChannelManager(private val flutterEngine: FlutterEngine) {

    private val channelName = "persistent"
    private var persistApp: Boolean = false

    init {
        setupChannel()
    }

    private fun setupChannel() {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "closeApp" -> {
                    closeApp()
                    result.success("App fechado")
                }
                "persistApp" -> {
                    persistApp = true
                    result.success("Persistência ativada")
                }
                "notPersistApp" -> {
                    persistApp = false
                    result.success("Persistência desativada")
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun closeApp() {
       exitProcess(-1)
    }

    fun isPersistApp(): Boolean {
        return persistApp
    }
}
