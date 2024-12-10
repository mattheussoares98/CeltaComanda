// ignore_for_file: use_build_context_synchronously

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
  PrintedProductsPresenter? printedProductsPresenter;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        printedProductsPresenter = Provider.of(context, listen: false);
        HomePresenter homePresenter = Provider.of(context, listen: false);
        printedProductsPresenter?.initPrinterResultHandler(
          homePresenter: homePresenter,
          closePage: () {
            Navigator.of(context).pop();
          },
        );
        await Future.delayed(Duration.zero);
        await print();
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    printedProductsPresenter?.disposePrinterHandler();
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
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "${R.string.conferenceOfTable} ${homePresenter.commandEntity!.commandNumber!.toInt()}",
                style: textStyle(context),
              ),
              Divider(thickness: 0.2),
              PrintProductsItems(),
              Divider(thickness: 0.2),
              SizedBox(height: 5),
              TotalSummary(),
              Divider(thickness: 0.2),
              PrintDate(),
              SizedBox(height: 10),
              DevelopedByCeltaware(),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle textStyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: getStringSize(context) * 1.2,
    );
