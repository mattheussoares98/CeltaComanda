package br.com.celtaware.comanda.utils

import android.content.pm.ActivityInfo
import android.app.Activity
import android.util.DisplayMetrics

object OrientationUtils {
    fun doOrientation(activity: Activity) {
        // Obtém as dimensões da tela
        val displayMetrics = DisplayMetrics()
        activity.windowManager.defaultDisplay.getRealMetrics(displayMetrics)
        var widthPixels = displayMetrics.widthPixels
        var heightPixels = displayMetrics.heightPixels

        // Verifica a orientação atual do dispositivo
        val orientation = activity.resources.configuration.orientation
        if (orientation == android.content.res.Configuration.ORIENTATION_LANDSCAPE) {
            // Se estiver em modo paisagem, inverte largura e altura
            val temp = widthPixels
            widthPixels = heightPixels
            heightPixels = temp
        }

        // Calcula a densidade da tela
        val density = displayMetrics.densityDpi

        // Converte pixels para dp (density-independent pixels)
        val widthDp = widthPixels / (density / DisplayMetrics.DENSITY_DEFAULT)
        val heightDp = heightPixels / (density / DisplayMetrics.DENSITY_DEFAULT)

        // Define a orientação com base na largura da tela
        if (widthDp >= 600) { // Considera 600 dp como o tamanho mínimo de um tablet
            activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE
        } else {
            activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        }
    }
}
