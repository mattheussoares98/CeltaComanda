package br.com.celtaware.comanda.printer

import android.graphics.Bitmap
import org.apache.commons.lang3.StringUtils
import rede.smartrede.sdk.Receipt
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols.getInstance
import java.util.*

private const val MONEY_PATTERN = "###,###,##0.00"

class ReceiptCreator(private val receipt: Receipt) {

    private val moneyFormat by lazy {
        DecimalFormat(MONEY_PATTERN, getInstance(Locale("pt", "BR")))
    }

    fun generateReceiptBitmap(
        printerFormatter: PrinterFormatter
    ): Bitmap {
        val printableLines = arrayListOf<PrintableLine>().also { fillPrintableLineList(it) }
        return printerFormatter.createBitmap(printableLines)
    }

    private fun fillPrintableLineList(printableLines: ArrayList<PrintableLine>) {
        with(printableLines) {
            add(headerLine())
            add(merchantLine())
            add(cnpjLine())
            add(transactionTypeLine())
            add(valueLine())
            add(nsuLine())
            add(installmentsLine())
            add(installmentsValue())
        }
    }

    private fun headerLine() = getPrintableLine("COMPROVANTE DE VENDA")

    private fun merchantLine() = getPrintableLine(generateText("Nome Loja", receipt.storeName))

    private fun cnpjLine() = getPrintableLine(generateText("CNPJ Estab", receipt.cnpj))

    private fun transactionTypeLine() =
        getPrintableLine(generateText("Tipo transação", receipt.operationType))

    private fun valueLine() =
        getPrintableLine(generateText("Valor", moneyFormat.format(receipt.value)))

    private fun nsuLine() = getPrintableLine(generateText("NSU", receipt.nsu))

    private fun installmentsLine() =
        getPrintableLine(generateText("Qtd. Parcelas", receipt.installments.toString()))

    private fun installmentsValue() =
        getPrintableLine(generateText("Vlr. Parcela", moneyFormat.format(receipt.installmentValue)))

    private fun getPrintableLine(text: String) = PrintableLine(Alignment.Left, FontSize.Medium, text)

    private fun generateText(label: String, value: String, maxLength: Int = 42) =
        StringBuilder().also {
            it.append(label)
            it.append(StringUtils.leftPad(" ", maxLength - (label.length + value.length)))
            it.append(value)
        }.toString()
}