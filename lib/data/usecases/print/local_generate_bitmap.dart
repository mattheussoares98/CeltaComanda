import 'dart:ui' as ui;
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../ui/pages/pages.dart';

class LocalGenerateBitmap implements GenerateBitmap {
  final double _dpi = 203; // DPI típico de impressora térmica
  final double _mmPerPx = 25.4 / 203; // mm por pixel (aprox.)
  final double _paperWidthMm = 80; // largura do papel em mm

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
    // Converte largura em pixels usando o DPI
    final int width = (_paperWidthMm / _mmPerPx).round();

    // Configura gravador e canvas sem altura fixa (alteração)
    final recorder = ui.PictureRecorder();
// Usa Rect.largest para permitir qualquer altura
    final canvas = Canvas(recorder, Rect.largest);

    final int lineHeight =
        (_dpi * 0.18).round(); // px por linha com base em DPI (~12pt)
    final int margin = (_dpi * 0.06).round(); // px de margem (~5mm)

    // Função auxiliar para desenhar texto
    void drawText(
      String text,
      double x,
      double y, {
      bool rightAlign = false,
      bool? isTitle,
    }) {
      final double fontSizeMm = isTitle == true ? 4.5 : 3.5;
      final double fontSizePx = fontSizeMm / _mmPerPx;
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: fontSizePx,
            color: const Color(0xFF000000),
            fontFamily: isTitle == true
                ? "lib/ui/assets/fonts/Roboto-Bold.ttf"
                : "lib/ui/assets/fonts/Roboto-Regular.ttf",
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: width - margin * 2);
      final dx = rightAlign ? width - margin - tp.width : x;
      tp.paint(canvas, Offset(dx, y));
    }

    int y = margin;

    // 1) Cabeçalho
    drawText(
      '${R.string.conferenceOfTable} #${commandNumber.toString().padLeft(3, "0")}',
      margin.toDouble(),
      y / 2.toDouble(),
      isTitle: true,
    );
    y += lineHeight;

    // 2) Títulos de colunas
    final double col1X = margin.toDouble();
    final double col2X = margin + (width - margin * 2) * 7 / 12;
    drawText(R.string.products, col1X, y.toDouble(), isTitle: true);
    drawText('${R.string.price}/${R.string.quantityAbbreviated}', col2X,
        y.toDouble(),
        isTitle: true);
    drawText(
      R.string.total,
      margin.toDouble(),
      y.toDouble(),
      rightAlign: true,
      isTitle: true,
    );
    y += lineHeight;

    // 3) Lista de produtos com quebra em até 2 linhas e máximo de 40 caracteres
    for (var e in printed.Products) {
      String name = e.Product!.Name;
      if (name.length > 40) name = name.substring(0, 40);
      List<String> parts;
      if (name.length <= 20) {
        parts = [name];
      } else {
        parts = [name.substring(0, 20), name.substring(20)];
      }
      final priceQty =
          '${e.Product!.SaleRetailPraticed.toDouble().toStringAsFixed(2).replaceAll('.', ',')} x ${e.Quantity}';
      final totalItem =
          e.TotalLiquid?.toDouble().toStringAsFixed(2).replaceAll('.', ',');
      for (var line in parts) {
        drawText(line, col1X, y.toDouble());
        y += lineHeight;
      }
      y -= lineHeight;
      drawText(priceQty, col2X, y.toDouble());
      drawText(
        '$totalItem',
        margin.toDouble(),
        y.toDouble(),
        rightAlign: true,
      );
      y += lineHeight;
    }

    // 4) Subtotal
    y += lineHeight;
    drawText(R.string.subtotal, col1X, y.toDouble(), isTitle: true);
    drawText(
      subTotal.toStringAsFixed(2).replaceAll('.', ','),
      margin.toDouble(),
      y.toDouble(),
      rightAlign: true,
    );
    y += lineHeight;

    // 5) Taxa de serviço
    if (serviceChargeValue != null && serviceChargeValue > 0) {
      drawText(R.string.serviceCharge, col1X, y.toDouble(), isTitle: true);
      drawText(
        serviceChargeValue.toStringAsFixed(2).replaceAll('.', ','),
        margin.toDouble(),
        y.toDouble(),
        rightAlign: true,
      );
      y += lineHeight;
    }

    // 6) Total geral
    drawText(R.string.total, col1X, y.toDouble(), isTitle: true);
    drawText(
      totalLiquid.toStringAsFixed(2).replaceAll('.', ','),
      margin.toDouble(),
      y.toDouble(),
      rightAlign: true,
    );
    y += lineHeight;

    // 7) Total por pessoa
    if (peopleQuantity > 1) {
      final perPerson = (totalLiquid / peopleQuantity);
      drawText(R.string.totalByPerson, col1X, y.toDouble(), isTitle: true);
      drawText(
        perPerson.toStringAsFixed(2).replaceAll('.', ','),
        margin.toDouble(),
        y.toDouble(),
        rightAlign: true,
      );
      y += lineHeight;
    }

    // 8) Rodapé: PDV e data/hora
    final now = DateTime.now();
    final dtStr = '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
    drawText('PDV: $pdvNumber', col1X, y.toDouble());
    drawText(dtStr, margin.toDouble(), y.toDouble(), rightAlign: true);
    y += lineHeight;

    // 9) Rodapé centralizado
    final devBy = R.string.developedByCeltaware;
    final tp = TextPainter(
      text: TextSpan(
        text: devBy,
        style:
            TextStyle(fontSize: 2.5 / (25.4 / 203), color: Color(0xFF000000)),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width - margin * 2);
    tp.paint(canvas, Offset((width - tp.width) / 2, y.toDouble()));
    y += lineHeight;

    // Finaliza e converte em imagem usando altura dinâmica (alteração)
    final picture = recorder.endRecording();
    final int actualHeight = y + margin; // calcula altura real
    final ui.Image finalImage = await picture.toImage(width, actualHeight);
    final byteData = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return byteData!.buffer.asUint8List();
  }
}
