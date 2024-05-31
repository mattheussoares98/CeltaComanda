import 'package:flutter/material.dart';

import '../../main/builders/builders.dart';

class ImageWidget extends StatelessWidget {
  final String? ean;
  final String plu;
  final double height;
  final double width;
  final bool showLargeImageInShowDialog;
  const ImageWidget({
    this.height = 65,
    this.width = 65,
    required this.ean,
    required this.plu,
    required this.showLargeImageInShowDialog,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: GestureDetector(
        onTap: () {
          if (!showLargeImageInShowDialog) return;
          showDialog(
              context: context,
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: AlertDialog(
                    insetPadding: const EdgeInsets.symmetric(horizontal: 8),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: _getImageNetwork(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.7,
                        ean: ean,
                        plu: plu,
                      ),
                    ),
                  ),
                );
              });
        },
        child: _getImageNetwork(
          width: width,
          height: height,
          ean: ean,
          plu: plu,
        ),
      ),
    );
  }
}

Image _getImageNetwork({
  required double width,
  required double height,
  required String? ean,
  required String plu,
}) {
  return Image.network(
    "${EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl!}/Images/${ean ?? plu}.PNG",
    width: width,
    height: height,
    fit: BoxFit.contain,
    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
      return SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey[350],
            ),
            const FittedBox(
                child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                "SEM IMAGEM",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            )),
          ],
        ),
      );
    },
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Aguarde..."),
            SizedBox(height: 8),
            CircularProgressIndicator(
              color: Colors.grey,
              strokeWidth: 2,
              strokeAlign: -5,
            ),
          ],
        ),
      );
    },
  );
}
