// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  late PrintedProductsPresenter printedProductsPresenter;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      printedProductsPresenter =
          Provider.of<PrintedProductsPresenter>(context, listen: false);
      HomePresenter homePresenter =
          Provider.of<HomePresenter>(context, listen: false);

      printedProductsPresenter.initPrinterResultHandler(
        homePresenter: homePresenter,
        closePageForOldPrintWay: () {
          if (mounted) Navigator.of(context).pop();
        },
      );

      // Espera um pequeno tempo para evitar problemas de renderização
      await Future.delayed(const Duration(milliseconds: 100));

      // Captura o bitmap após a renderização
      await _print();
    });
  }

  @override
  void dispose() {
    printedProductsPresenter.disposePrinterHandler();
    super.dispose();
  }

  Future<void> _print() async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));

      if (_repaintBoundaryKey.currentContext == null) return;

      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // Faz a tela expandir para capturar todo o conteúdo
      setState(() {});

      // Garante que o frame foi atualizado
      await Future.delayed(const Duration(milliseconds: 100));

      // Captura a imagem do widget inteiro
      ui.Image rawImage = await boundary.toImage(pixelRatio: 3.0);

      // Converte para bytes sem inverter
      final byteData =
          await rawImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      Uint8List bitmap = byteData.buffer.asUint8List();

      // Restaura o estado original
      setState(() {});

      // Mostra a imagem antes de imprimir
      // await _showPreview(bitmap);

      await printedProductsPresenter.oldPrintPrintedProducts(
        bitmap: bitmap,
        closePage: () {
          if (mounted) Navigator.of(context).pop();
        },
      );
    } catch (e) {
      debugPrint("Erro ao capturar bitmap: $e");
      if (mounted) Navigator.of(context).pop();
    }
  }

// corrected the orientation, but no longer corrects it
  // Future<Uint8List> _invertImageToBeCorrectly(ui.Image rawImage) async {
  //   final ByteData? byteData =
  //       await rawImage.toByteData(format: ui.ImageByteFormat.rawRgba);
  //   if (byteData == null) return Uint8List(0);

  //   final int width = rawImage.width;
  //   final int height = rawImage.height;

  //   final ui.PictureRecorder recorder = ui.PictureRecorder();
  //   final Canvas canvas = Canvas(recorder);

  //   final Paint paint = Paint();

  //   canvas.translate(0, height.toDouble());
  //   canvas.scale(1, -1);

  //   final ui.Rect rect =
  //       ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
  //   final ui.Image newImage = rawImage.clone();

  //   canvas.drawImageRect(newImage, rect, rect, paint);

  //   final ui.Image correctedImage =
  //       await recorder.endRecording().toImage(width, height);

  //   final ByteData? newByteData =
  //       await correctedImage.toByteData(format: ui.ImageByteFormat.png);
  //   return newByteData!.buffer.asUint8List();
  // }

  // Future<void> _showPreview(Uint8List bitmap) async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Pré-visualização"),
  //         content: Image.memory(bitmap),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text("Fechar"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter =
        Provider.of<HomePresenter>(context, listen: false);

    return RepaintBoundary(
      key: _repaintBoundaryKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "${R.string.conferenceOfTable} ${homePresenter.commandEntity!.commandNumber!.toInt()}",
                style: textStyle(context),
              ),
              const Divider(thickness: 0.2),
              const PrintProductsItems(),
              const Divider(thickness: 0.2),
              const SizedBox(height: 5),
              const TotalSummary(),
              const Divider(thickness: 0.2),
              const PrintDate(),
              const SizedBox(height: 10),
              const DevelopedByCeltaware(),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle textStyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: StringSize.size * 1.2,
    );
