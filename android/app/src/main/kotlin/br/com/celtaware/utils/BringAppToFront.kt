package br.com.celtaware.comanda.utils

import android.content.Context
import android.content.Intent
import android.util.Log

object AppUtils {
    fun bringAppToFront(context: Context) {
        try {
            val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            if (intent != null) {
                intent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
                context.startActivity(intent)
            } else {
                Log.e("AppUtils", "Intent para o pacote não encontrada")
            }
        } catch (e: Exception) {
            Log.e("AppUtils", "Erro ao tentar trazer o aplicativo para o primeiro plano", e)
        }
    }
}
