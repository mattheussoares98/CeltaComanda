import 'dart:ui' as ui;
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../ui/pages/pages.dart';

class LocalGenerateBitmap implements GenerateBitmap {
  // --- Constants for an 80mm thermal printer ---
  final double _dpi = 203; // Typical thermal printer DPI (Dots Per Inch)
  final double _paperWidthMm = 80; // Paper width in millimeters

  // --- Calculated values ---
  // Calculates how many millimeters each pixel represents.
  // Formula: 25.4mm (1 inch) / DPI
  final double _mmPerPx = 25.4 / 203;

  @override
  Future<Uint8List> generate({
    required int commandNumber,
    required int pdvNumber,
    required PrintedViewModel printed,
    required double subTotal,
    required double? serviceChargeValue,
    required double totalLiquid,
    required int peopleQuantity,
  }) async {
    // --- Canvas and Layout Setup ---

    // Convert paper width from mm to pixels.
    final int width = (_paperWidthMm / _mmPerPx).round();

    // The PictureRecorder records the drawing commands.
    final recorder = ui.PictureRecorder();

    // The Canvas is created with the recorder and a boundless rectangle (Rect.largest),
    // allowing the height to grow dynamically with the content.
    final canvas = Canvas(recorder, Rect.largest);

    // --- Layout Metrics ---

    // Line height in pixels, based on a font size of ~12pt.
    final int lineHeight = (_dpi * 0.18).round();

    // **CHANGE 1: Correct Margin Calculation**
    // Margin is now calculated to be precisely 5mm.
    final int margin = (5 / _mmPerPx).round(); // Approx. 5mm margin in pixels

    // Current vertical position for drawing, starts at the top margin.
    double y = margin.toDouble();

    // --- Helper function for drawing text ---
    void drawText(
      String text,
      double x,
      double y, {
      bool rightAlign = false,
      bool isTitle = false,
    }) {
      // Font size in mm, then converted to pixels.
      final double fontSizeMm = isTitle ? 4.5 : 3.5;
      final double fontSizePx = fontSizeMm / _mmPerPx;

      final textStyle = TextStyle(
        fontSize: fontSizePx,
        color: const Color(0xFF000000),
        fontFamily: "Roboto",
        fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
      );

      final textSpan = TextSpan(text: text, style: textStyle);

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: (width - margin * 2).toDouble());

      // Adjust x position for right-aligned text.
      final dx = rightAlign ? width - margin - textPainter.width : x;

      textPainter.paint(canvas, Offset(dx, y));
    }

    // --- Receipt Content Drawing ---

    // 1) Header
    drawText(
      '${R.string.conferenceOfTable} #${commandNumber.toString().padLeft(3, "0")}',
      margin.toDouble(),
      y / 2, // Positioned slightly higher
      isTitle: true,
    );
    y += lineHeight * 1.5; // Extra space after title

    // 2) Column Titles
    final double col1X = margin.toDouble();
    final double col2X =
        margin + (width - margin * 2) * 0.6; // Adjusted column position
    drawText(R.string.products, col1X, y, isTitle: true);
    drawText('${R.string.price}/${R.string.quantityAbbreviated}', col2X, y,
        isTitle: true);
    drawText(R.string.total, margin.toDouble(), y,
        rightAlign: true, isTitle: true);
    y += lineHeight * 1.5;

    // 3) Product List
    for (var e in printed.Products) {
      String name = e.Product!.Name;

      // **CHANGE 3: Safe String Truncation**
      // Uses runes to safely handle multi-byte characters and prevent corruption.
      if (name.runes.length > 40) {
        name = String.fromCharCodes(name.runes.take(40));
      }

      // Simple word wrapping logic (splits at 20 chars)
      List<String> nameLines;
      if (name.length <= 20) {
        nameLines = [name];
      } else {
        // A more robust word wrap could be implemented here if needed.
        nameLines = [name.substring(0, 20), name.substring(20)];
      }

      final priceQty =
          '${e.Product!.SaleRetailPraticed.toDouble().toStringAsFixed(2).replaceAll('.', ',')} x ${e.Quantity}';
      final totalItem =
          e.TotalLiquid?.toDouble().toStringAsFixed(2).replaceAll('.', ',');

      // Draw the first line of the product name
      drawText(nameLines[0], col1X, y);

      // Draw the price/total on the same line as the first line of the name
      drawText(priceQty, col2X, y);
      drawText('$totalItem', margin.toDouble(), y, rightAlign: true);
      y += lineHeight;

      // If the name has a second line, draw it below
      if (nameLines.length > 1) {
        drawText(nameLines[1], col1X, y);
        y += lineHeight;
      }
    }

    // 4) Subtotal
    y += lineHeight; // Add some space before totals
    drawText(R.string.subtotal, col1X, y, isTitle: true);
    drawText(
        subTotal.toStringAsFixed(2).replaceAll('.', ','), margin.toDouble(), y,
        rightAlign: true);
    y += lineHeight;

    // 5) Service Charge
    if (serviceChargeValue != null && serviceChargeValue > 0) {
      drawText(R.string.serviceCharge, col1X, y, isTitle: true);
      drawText(serviceChargeValue.toStringAsFixed(2).replaceAll('.', ','),
          margin.toDouble(), y,
          rightAlign: true);
      y += lineHeight;
    }

    // 6) Grand Total
    drawText(R.string.total, col1X, y, isTitle: true);
    drawText(totalLiquid.toStringAsFixed(2).replaceAll('.', ','),
        margin.toDouble(), y,
        rightAlign: true);
    y += lineHeight * 1.5; // Extra space

    // 7) Total Per Person
    if (peopleQuantity > 1) {
      final perPerson = (totalLiquid / peopleQuantity);
      drawText(R.string.totalByPerson, col1X, y, isTitle: true);
      drawText(perPerson.toStringAsFixed(2).replaceAll('.', ','),
          margin.toDouble(), y,
          rightAlign: true);
      y += lineHeight;
    }

    // 8) Footer: PDV and Date/Time
    y += lineHeight;
    final now = DateTime.now();
    final dtStr = '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
    drawText('PDV: $pdvNumber', col1X, y);
    drawText(dtStr, margin.toDouble(), y, rightAlign: true);
    y += lineHeight;

    // 9) Centered Footer
    final devBy = R.string.developedByCeltaware;
    final footerPainter = TextPainter(
      text: TextSpan(
        text: devBy,
        style: TextStyle(
            fontSize: 2.5 / _mmPerPx,
            color: Color(0xFF000000),
            fontFamily: 'Roboto'),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: (width - margin * 2).toDouble());
    footerPainter.paint(canvas, Offset((width - footerPainter.width) / 2, y));
    y += lineHeight;

    // --- Image Conversion ---

    // End recording to get the final Picture object.
    final picture = recorder.endRecording();

    // Calculate the actual height based on the content drawn.
    final int actualHeight = y.round() + margin;

    // Convert the Picture to an Image with the calculated dimensions.
    final ui.Image finalImage = await picture.toImage(width, actualHeight);

    // Convert the Image to a PNG byte buffer.
    final byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }
}
