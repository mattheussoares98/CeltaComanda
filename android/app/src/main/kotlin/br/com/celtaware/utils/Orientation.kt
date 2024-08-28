package br.com.celtaware.comanda.utils

import android.content.pm.ActivityInfo
import android.app.Activity
import android.util.DisplayMetrics

object OrientationUtils {
    fun doOrientation(activity: Activity) {
        // Obtém as dimensões da tela
        val displayMetrics = DisplayMetrics()
        activity.windowManager.defaultDisplay.getRealMetrics(displayMetrics)
        val widthPixels = displayMetrics.widthPixels
        val heightPixels = displayMetrics.heightPixels

        // Calcula a densidade da tela
        val density = displayMetrics.densityDpi

        // Converte pixels para dp (density-independent pixels)
        val widthDp = widthPixels / (density / DisplayMetrics.DENSITY_DEFAULT)
        val heightDp = heightPixels / (density / DisplayMetrics.DENSITY_DEFAULT)

        // Calcula a área em dp
        val areaDp = widthDp * heightDp

        // Define a orientação com base na área da tela e na orientação atual
        if (areaDp > 400000) { // Ajuste o valor conforme necessário
            activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE
        } else {
            activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        }
    }
}
