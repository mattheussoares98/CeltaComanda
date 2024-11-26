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
  initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_)async {
      
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
    }
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return RepaintBoundary(
      key: repaintBoundaryKey,
      child: Scaffold(
        body: Column(
          children: [
            PrintProductsItems(),
            Divider(thickness: 0.2),
            Text(
              "${R.string.table} ${homePresenter.commandNumber!.toInt()}",
              style: textStyle(),
            ),
            SizedBox(height: 5),
            TotalSummary(),
          ],
        ),
      ),
    );
  }
}

TextStyle textStyle() => TextStyle(fontWeight: FontWeight.bold);
