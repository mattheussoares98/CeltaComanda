package br.com.celtaware.comanda.getnet_channel

import android.app.Activity
import android.app.Activity.RESULT_OK
import android.content.Intent
import android.net.Uri
import android.os.Bundle


class GetNetPayment(
    private val activity: Activity,
) {
    private val REQUEST_CODE = 10001

    fun startIntent(bundle: Bundle?, deeplink: String) {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(deeplink))
        if (bundle != null) {
            intent.putExtras(bundle)
        }
        activity.startActivityForResult(intent, REQUEST_CODE)
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        onActivityResult(requestCode, resultCode, data)
        if (RESULT_OK === resultCode && REQUEST_CODE === requestCode) {
            foo()
        }
    }

    private fun foo() {
        // Your implementation for foo()
    }
}
