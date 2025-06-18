import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';

class LocalGenerateBitmap implements GenerateBitmap {
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
    final robotoRegular = pw.Font.ttf(
        await rootBundle.load('lib/ui/assets/fonts/Roboto-Regular.ttf'));
    // final robotoMedium = pw.Font.ttf(
    //     await rootBundle.load('lib/ui/assets/fonts/Roboto-Medium.ttf'));
    final robotoBold = pw.Font.ttf(
        await rootBundle.load('lib/ui/assets/fonts/Roboto-Bold.ttf'));

    pw.TextStyle pwTextStyle(bool? isTitle) => pw.TextStyle(
          fontSize: isTitle == true ? 10 : 6,
          fontWeight:
              isTitle == true ? pw.FontWeight.bold : pw.FontWeight.normal,
          font: isTitle == true ? robotoBold : robotoRegular,
        );

    final doc = pw.Document();
    // final ttf = await printing.fontFromAssetBundle('assets/open-sans.ttf');
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(226.77, double.infinity),
        margin: pw.EdgeInsets.all(0),
        build: (pw.Context context) {
          return pw.Container(
            // color: PdfColors.amber100, only to show the page size
            child: pw.Column(
              children: [
                pw.Center(
                  child: pw.Column(children: [
                    pw.Text(
                      "${R.string.conferenceOfTable} $commandNumber",
                      textAlign: pw.TextAlign.center,
                      style: pwTextStyle(true),
                    ),
                  ]),
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Expanded(
                      child:
                          pw.Text(R.string.products, style: pwTextStyle(true)),
                    ),
                    pw.SizedBox(width: 2),
                    pw.Text("${R.string.price} ${R.string.quantityAbbreviated}",
                        style: pwTextStyle(true)),
                    pw.SizedBox(width: 5),
                    pw.Text(R.string.total, style: pwTextStyle(true)),
                  ],
                ),
                ...printed.Products.map((e) {
                  return pw.Padding(
                      padding: pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 66,
                            child: pw.Text(
                              e.Product!.Name,
                              style: pwTextStyle(false),
                            ),
                          ),
                          pw.SizedBox(width: 5),
                          pw.Expanded(
                            flex: 18,
                            child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  e.Product!.SaleRetailPraticed
                                      .toDouble()
                                      .toString()
                                      .toBrazilianNumber(2),
                                  // textAlign: pw.TextAlign.start,
                                  style: pwTextStyle(false),
                                ),
                                pw.Text(
                                  e.Quantity.toString()
                                      .toDouble()
                                      .toString()
                                      .toBrazilianNumber(2, true),
                                  textAlign: pw.TextAlign.end,
                                  style: pwTextStyle(false),
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(width: 2),
                          pw.Expanded(
                            flex: 14,
                            child: pw.Text(
                              e.TotalLiquid.toString(),
                              textAlign: pw.TextAlign.end,
                              style: pwTextStyle(false),
                            ),
                          ),
                        ],
                      ));
                }),
                pw.Divider(height: 10),
                pw.Column(
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (printed.IncrementType != null &&
                            printed.IncrementType!.isNotEmpty &&
                            printed.IncrementType != "0")
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  R.string.subtotal,
                                  style: pwTextStyle(true),
                                ),
                                pw.FittedBox(
                                  child: pw.Text(
                                    subTotal
                                        .toDouble()
                                        .toString()
                                        .toBrazilianNumber()
                                        .addBrazilianCoin(),
                                    textAlign: pw.TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (printed.IncrementType != null &&
                            printed.IncrementType!.isNotEmpty &&
                            printed.IncrementType != "0" &&
                            serviceChargeValue != null)
                          pw.Expanded(
                            child: pw.Column(
                              children: [
                                pw.Text(
                                  R.string.serviceChargeAbbreviated,
                                  style: pwTextStyle(true),
                                ),
                                pw.FittedBox(
                                  child: pw.Text(
                                    serviceChargeValue
                                        .toDouble()
                                        .toString()
                                        .toBrazilianNumber()
                                        .addBrazilianCoin(),
                                    textAlign: pw.TextAlign.end,
                                    style: pwTextStyle(false),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              if (printed.IncrementType != null &&
                                  printed.IncrementType!.isNotEmpty &&
                                  printed.IncrementType != "0")
                                pw.Text(
                                  R.string.total,
                                  style: pwTextStyle(true),
                                ),
                              pw.FittedBox(
                                child: pw.Text(
                                  totalLiquid
                                      .toString()
                                      .toBrazilianNumber()
                                      .addBrazilianCoin(),
                                  textAlign: pw.TextAlign.end,
                                  style: pwTextStyle(false),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (peopleQuantity > 1)
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                              "${R.string.totalByPerson} ($peopleQuantity)",
                              style: pwTextStyle(false),
                            ),
                          ),
                          pw.Text(
                            "${totalLiquid / peopleQuantity}"
                                .toDouble()
                                .toString()
                                .toBrazilianNumber()
                                .addBrazilianCoin(),
                            style: pwTextStyle(false),
                          ),
                        ],
                      ),
                  ],
                ),
                pw.Divider(height: 10),
                pw.Text(
                  "${R.string.pdv.toUpperCase()} $pdvNumber",
                  textAlign: pw.TextAlign.center,
                  style: pwTextStyle(false),
                ),
                pw.Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
                  textAlign: pw.TextAlign.center,
                  style: pwTextStyle(false),
                ),
                pw.Center(
                  child: pw.Text(
                    R.string.developedByCeltaware,
                    style: pwTextStyle(true),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    await Future.delayed(Duration.zero, () {});
    Uint8List? image;
    await for (var page
        in Printing.raster(await doc.save(), pages: [0], dpi: 203)) {
      image = await page.toPng();
    }

    return image!;
  }
}
