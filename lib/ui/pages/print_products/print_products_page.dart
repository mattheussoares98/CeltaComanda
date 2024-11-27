import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class PrintProductsPage extends StatefulWidget {
  const PrintProductsPage({super.key});

  @override
  State<PrintProductsPage> createState() => _PrintProductsPageState();
}

class _PrintProductsPageState extends State<PrintProductsPage> {
  final repaintBoundaryKey = GlobalKey();

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await Future.delayed(Duration.zero);
        await print();
      }
    });
  }

  Future<void> print() async {
    try {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        PrintedProductsPresenter printedProductsPresenter =
            Provider.of(context, listen: false);
        RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage();
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        final bitmap = byteData!.buffer.asUint8List();

        await printedProductsPresenter.printPrintedProducts(bitmap);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      });
    } catch (e) {
      debugPrint(e.toString());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return RepaintBoundary(
      key: repaintBoundaryKey,
      child: Scaffold(
        // appBar: AppBar(),
        body: Column(
          children: [
            Text(
                "" +
                    "CONFERÊNCIA DA MESA " +
                    "${homePresenter.commandNumber!.toInt()}",
                style: textStyle()),
            Divider(thickness: 0.2),
            PrintProductsItems(),
            Divider(thickness: 0.2),
            SizedBox(height: 5),
            TotalSummary(),
            SizedBox(height: 10),
            Stack(
              children: [
                Divider(thickness: 0.2),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    color: Colors.white,
                    child: Text(
                      "" + "Desenvolvido por Celtaware",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle textStyle() => TextStyle(fontWeight: FontWeight.bold);
