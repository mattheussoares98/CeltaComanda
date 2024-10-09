package br.com.celtaware.comanda.Printer

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Bitmap.Config.ARGB_8888
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface.createFromAsset

private const val DEFAULT_LINE_MARGIN = 6
private const val DEFAULT_HALF_LINE_MARGIN = DEFAULT_LINE_MARGIN / 2
private const val MAX_CHAR_PER_LINE = 42f
private const val WIDTH = 384
private const val CHARACTER_SIZE = WIDTH.toFloat() / MAX_CHAR_PER_LINE
private const val SMALL_SIZE = 18f
private const val MEDIUM_SIZE = 22f
private const val LARGE_SIZE = 32f

class PrinterFormatter(private val context: Context) {
    private val xScaleMap = hashMapOf<FontSize, Float>()

    init {
        setXScaleMap()
    }

    fun createBitmap(
        printableLines: List<PrintableLine>,
        canvas: Canvas = Canvas()
    ): Bitmap {
        val bitmaps = printableLines.map { line -> formatToBitmap(line) }
        val width = bitmaps.maxOf { it.width }
        val height = bitmaps.fold(0) { h, bitmap -> (h + bitmap.height) }
        val bitmap = Bitmap.createBitmap(width, height, ARGB_8888)
        canvas.setBitmap(bitmap)
        var curTop = 0f
        bitmaps.forEach {
            canvas.drawBitmap(it, 0f, curTop, null)
            curTop += it.height
        }
        return bitmap
    }

    private fun formatToBitmap(
        printableLine: PrintableLine,
        canvas: Canvas = Canvas(),
        paint: Paint = Paint()
    ): Bitmap {
        val text: String = printableLine.text
        loadPaint(printableLine, paint)

        val height = getDefaultHeight(printableLine.fontSize)
        val verticalAlignPosition = (height - DEFAULT_HALF_LINE_MARGIN).toFloat()

        val horizontalAlignPosition = getHorizontalAlign(printableLine, text)
        val bitmap = Bitmap.createBitmap(WIDTH, height, ARGB_8888)

        configureCanvas(canvas, bitmap, text, horizontalAlignPosition, verticalAlignPosition, paint)

        return bitmap
    }

    private fun configureCanvas(
        canvas: Canvas,
        bitmap: Bitmap?,
        text: String,
        horizontalAlignPosition: Float,
        verticalAlignPosition: Float,
        paint: Paint
    ) {
        canvas.run {
            setBitmap(bitmap)
            drawARGB(255, 255, 255, 255)
            drawText(text, horizontalAlignPosition, verticalAlignPosition, paint)
        }
    }

    private fun getHorizontalAlign(
        printableLine: PrintableLine,
        text: String
    ) = when (printableLine.alignment) {
        Alignment.Left -> 0f
        Alignment.Center -> (WIDTH - (text.length * CHARACTER_SIZE)) / 2
        Alignment.Right -> WIDTH - (text.length * CHARACTER_SIZE)
    }

    private fun loadPaint(printableLine: PrintableLine, paint: Paint) {
        paint.apply {
            textSize = convertSize(printableLine.fontSize)
            textAlign = Paint.Align.LEFT
            color = Color.BLACK
            textScaleX = xScaleMap[printableLine.fontSize]!!
        }
    }

    private fun getDefaultHeight(fontSize: FontSize): Int {
        return when (fontSize) {
            FontSize.Small -> 13 + DEFAULT_LINE_MARGIN
            FontSize.Medium -> 16 + DEFAULT_LINE_MARGIN
            FontSize.Large -> 23 + DEFAULT_LINE_MARGIN
        }
    }

    private fun convertSize(fontSize: FontSize): Float {
        return when (fontSize) {
            FontSize.Small -> SMALL_SIZE
            FontSize.Medium -> MEDIUM_SIZE
            FontSize.Large -> LARGE_SIZE
        }
    }

    private fun setXScaleMap(scalePaint: Paint = Paint()) {
        scalePaint.typeface = createFromAsset(context.assets, "fonts/RobotoMono-Medium.ttf")
        for (size: FontSize in FontSize.values()) {
            scalePaint.textSize = convertSize(size)
            xScaleMap[size] = CHARACTER_SIZE / scalePaint.measureText(" ")
        }
    }
}
