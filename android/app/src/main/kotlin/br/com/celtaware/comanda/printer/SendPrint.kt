package br.com.celtaware.comanda.printer

import android.util.Log
import br.com.positivo.printermodule.PrintAttributes.KEY_ALIGN
import br.com.positivo.printermodule.PrintAttributes.KEY_MARGINLEFT
import br.com.positivo.printermodule.PrintAttributes.KEY_TEXTSIZE
import br.com.positivo.printermodule.PrintAttributes.KEY_TYPEFACE
import br.com.positivo.printermodule.PrintAttributes.KEY_WEIGHT
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import rede.smartrede.commons.callback.IPrinterCallback
import rede.smartrede.commons.contract.IConnectorPrinter

class SendPrint(
    private val connectorPrinter: IConnectorPrinter,
) {
    private val channel: String = "print_channel"

    fun setupMethodChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->
            val argumentsWithFlutter = call.arguments as? Map<*, *>

            argumentsWithFlutter?.let {
                when (call.method) {
                    "print" -> {
                        val stringList = it["stringList"] as? List<*>

                        if (stringList != null) {
                            // Converta a lista para uma lista de strings
                            val stringListConverted = stringList.filterIsInstance<String>()
                            // Faça algo com a lista de strings
                            println(stringListConverted)
                            result.success(null)
                        } else {
                            result.error(
                                "INVALID_ARGUMENTS",
                                "A lista de strings fornecida não é válida.",
                                null
                            )
                        }
                    }

                    else -> result.notImplemented()
                }
            } ?: result.error(
                "INVALID_ARGUMENTS",
                "Os argumentos fornecidos não são válidos.",
                null
            )
        }
    }

    fun print(callback: IPrinterCallback) {
        val textArray2 = arrayOf("         CREDITO A VISTA - I          ")
        val textArray4 = arrayOf(" VIA - ESTABELECIMENTO / POS=69000163 ")
        val textArray5 = arrayOf("CNPJ: 00.000.000/0000-00              ")
        val textArray6 = arrayOf("MENSAGEM TBL F0                       ")
        val textArray7 = arrayOf("LOJA CRED SEM FIN                     ")
        val textArray8 =
            arrayOf("ENDERECO1 ENDERECO2 ENDERECO3         \n-ENDERECO4                            ")
        val textArray10 = arrayOf("0000000000000004  DOC=419019  AUT=095121")
        val textArray11 = arrayOf("19/11/19", "09:51", "ONL-X")
        val textArray12 = arrayOf("VENDA A CREDITO                       ")
        val textArray13 = arrayOf("VALOR:", "30,00")
        val textArray14 = arrayOf("MENSAGEM TBL D0                       ")

        val maptext1 = mutableMapOf(
            Pair(KEY_TEXTSIZE, 17),
            Pair(KEY_ALIGN, 0),
            Pair(KEY_TYPEFACE, 0)
        )
        val maptext2 = mutableMapOf(
            Pair(KEY_TEXTSIZE, 17),
            Pair(KEY_ALIGN, 1),
            Pair(KEY_TYPEFACE, 0),
            Pair(KEY_MARGINLEFT, 2)
        )
        val maptext3 = mutableMapOf(
            Pair(KEY_TEXTSIZE, 17),
            Pair(KEY_ALIGN, 1),
            Pair(KEY_TYPEFACE, 1),
            Pair(KEY_MARGINLEFT, 4)
        )
        val maptext4 = mutableMapOf(
            Pair(KEY_TEXTSIZE, 17),
            Pair(KEY_ALIGN, 1),
            Pair(KEY_TYPEFACE, 1),
            Pair(KEY_MARGINLEFT, 4),
            Pair(KEY_WEIGHT, 3)
        )
        val maptext5 = mutableMapOf(
            Pair(KEY_TEXTSIZE, 17),
            Pair(KEY_ALIGN, 1),
            Pair(KEY_TYPEFACE, 1),
            Pair(KEY_MARGINLEFT, 4),
            Pair(KEY_WEIGHT, 2)
        )
        val maptext6 = mutableMapOf(
            Pair(KEY_TEXTSIZE, 17),
            Pair(KEY_ALIGN, 2),
            Pair(KEY_TYPEFACE, 1),
            Pair(KEY_MARGINLEFT, 4),
            Pair(KEY_WEIGHT, 1)
        )
        val attrCols1 = getArrayList().also { it.add(maptext1) }
        val attrCols2 = getArrayList().also { it.add(maptext2) }
        val attrCols3 = getArrayList().also { it.add(maptext3) }
        val attrCols4 = getArrayList().also {
            it.add(maptext4)
            it.add(maptext5)
            it.add(maptext6)
        }

        val attrCols5 = getArrayList().also {
            it.add(maptext5)
            it.add(maptext6)
        }

        val listContent = listOf<Pair<Array<String>, List<Map<String, Int>>>>(
            Pair(textArray2, attrCols1),
            Pair(textArray4, attrCols1),
            Pair(textArray5, attrCols2),
            Pair(textArray6, attrCols2),
            Pair(textArray7, attrCols3),
            Pair(textArray8, attrCols2),
            Pair(textArray10, attrCols2),
            Pair(textArray11, attrCols4),
            Pair(textArray12, attrCols2),
            Pair(textArray13, attrCols5),
            Pair(textArray14, attrCols2),
        )

        postToWorkerThread {
            try {
                with(connectorPrinter) {
                    setPrinterCallback(callback)
//                    printBitmap(logo)
//                    printBitmapWithAttributes(logo, logoMap)
                    printArrayTextWithAttributes(listContent)
//                    printBlankLines(SPACE_AFTER_PRINT)
//                    printQRCode(CONTENT, VALUE_ALIGN_CENTER, 200)
//                    printBlankLines(SPACE_AFTER_PRINT)
//                    printBarCode(CONTENT, VALUE_ALIGN_CENTER, 150, 80, true)
//                    printBlankLines(4)
                }
            } catch (exception: Exception) {
                Log.e(javaClass.simpleName, exception.message.orEmpty())
            }
        }
    }

    private fun getArrayList() = ArrayList<MutableMap<String, Int>>()

    private fun postToWorkerThread(command: Runnable) {
        Thread(command).start()
    }
}