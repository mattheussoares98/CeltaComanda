import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';

class LocalGenerateBitmap implements GenerateBitmap {
  final double _dpi = 203;
  final double _paperWidthMm = 80;
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
    final int width = (_paperWidthMm / _mmPerPx).round();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.largest);
    final int lineHeight = (_dpi * 0.18).round();
    final int margin = (5 / _mmPerPx).round();
    double y = margin.toDouble();

    void drawText(
      String text,
      double x,
      double y, {
      bool rightAlign = false,
      bool isTitle = false,
    }) {
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
      final dx = rightAlign ? width - margin - textPainter.width : x;
      textPainter.paint(canvas, Offset(dx, y));
    }

    // --- Receipt Content Drawing Logic ---
    // (Your existing drawing logic remains here)
    // 1) Header
    drawText(
      '${R.string.conferenceOfTable} #${commandNumber.toString().padLeft(3, "0")}',
      margin.toDouble(),
      y / 2,
      isTitle: true,
    );
    y += lineHeight * 1.5;

    // 2) Column Titles
    final double col1X = margin.toDouble();
    final double col2X = margin + (width - margin * 2) * 0.6;
    drawText(R.string.products, col1X, y, isTitle: true);
    drawText('UN ${R.string.quantityAbbreviated}', col2X, y, isTitle: true);
    drawText(R.string.total, margin.toDouble(), y,
        rightAlign: true, isTitle: true);
    y += lineHeight * 1.5;

    // 3) Product List
    for (var e in printed.Products) {
      String name = e.Product!.Name;
      if (name.runes.length > 40) {
        name = String.fromCharCodes(name.runes.take(40));
      }
      List<String> nameLines = (name.length <= 20)
          ? [name]
          : [name.substring(0, 20), name.substring(20)];
      final priceQty =
          '${e.Product!.SaleRetailPraticed.toDouble().toStringAsFixed(2).replaceAll('.', ',')} x ${e.Quantity?.toDouble().toString().toBrazilianNumber((e.Quantity?.toDouble() ?? 0) % 1 == 0 ? 0 : 2)}';
      final totalItem =
          e.TotalLiquid?.toDouble().toStringAsFixed(2).replaceAll('.', ',');
      drawText(nameLines[0], col1X, y);
      drawText(priceQty, col2X, y);
      drawText('$totalItem', margin.toDouble(), y, rightAlign: true);
      y += lineHeight;
      if (nameLines.length > 1) {
        drawText(nameLines[1], col1X, y);
        y += lineHeight;
      }
    }

    // 4) Subtotal, Service Charge, Total, etc.
    y += lineHeight;
    drawText(R.string.subtotal, col1X, y, isTitle: true);
    drawText(
        subTotal.toStringAsFixed(2).replaceAll('.', ','), margin.toDouble(), y,
        rightAlign: true);
    y += lineHeight;

    if (serviceChargeValue != null && serviceChargeValue > 0) {
      drawText(R.string.serviceCharge, col1X, y, isTitle: true);
      drawText(serviceChargeValue.toStringAsFixed(2).replaceAll('.', ','),
          margin.toDouble(), y,
          rightAlign: true);
      y += lineHeight;
    }
    drawText(R.string.total, col1X, y, isTitle: true);
    drawText(totalLiquid.toStringAsFixed(2).replaceAll('.', ','),
        margin.toDouble(), y,
        rightAlign: true);
    y += lineHeight * 1.5;
    if (peopleQuantity > 1) {
      final perPerson = (totalLiquid / peopleQuantity);
      drawText(R.string.totalByPerson, col1X, y, isTitle: true);
      drawText(perPerson.toStringAsFixed(2).replaceAll('.', ','),
          margin.toDouble(), y,
          rightAlign: true);
      y += lineHeight;
    }
    y += lineHeight;
    final now = DateTime.now();
    final dtStr =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    drawText('PDV: $pdvNumber', col1X, y);
    drawText(dtStr, margin.toDouble(), y, rightAlign: true);
    y += lineHeight;
    final devBy = R.string.developedByCeltaware;
    final footerPainter = TextPainter(
      text: TextSpan(
          text: devBy,
          style: TextStyle(
              fontSize: 2.5 / _mmPerPx,
              color: const Color(0xFF000000),
              fontFamily: 'Roboto')),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: (width - margin * 2).toDouble());
    footerPainter.paint(canvas, Offset((width - footerPainter.width) / 2, y));
    y += lineHeight;

    // --- Image Conversion and Validation ---
    final picture = recorder.endRecording();
    final int actualHeight = y.round() + margin;

    // Validate the calculated dimensions before attempting to create an image.
    debugPrint(
        '[LocalGenerateBitmap] Calculated dimensions: width=$width, height=$actualHeight');
    if (width <= 0 || actualHeight <= 0) {
      final error =
          'Invalid bitmap dimensions: width=$width, height=$actualHeight. Cannot generate image.';
      debugPrint('[LocalGenerateBitmap] ERROR: $error');
      throw Exception(error);
    }

    final pictureImage = await picture.toImage(width, actualHeight);

    // Composite onto a white background to remove transparency.
    final finalRecorder = ui.PictureRecorder();
    final finalCanvas = Canvas(finalRecorder);
    final whitePaint = Paint()..color = const Color(0xFFFFFFFF);
    finalCanvas.drawRect(
        Rect.fromLTWH(0, 0, width.toDouble(), actualHeight.toDouble()),
        whitePaint);
    finalCanvas.drawImage(pictureImage, Offset.zero, Paint());
    final finalPicture = finalRecorder.endRecording();
    final ui.Image finalImage = await finalPicture.toImage(width, actualHeight);

    // Convert the final image to byte data.
    final byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);

    // Check if byteData is null and throw a clear exception instead of returning an empty list.
    if (byteData == null) {
      const error =
          'Failed to convert image to byte data (toByteData returned null).';
      debugPrint('[LocalGenerateBitmap] ERROR: $error');
      throw Exception(error);
    }

    debugPrint(
        '[LocalGenerateBitmap] Successfully generated bitmap with ${byteData.lengthInBytes} bytes.');
    return byteData.buffer.asUint8List();
  }
}
