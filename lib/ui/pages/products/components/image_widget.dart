import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String? ean;
  final String plu;
  final double height;
  final double width;
  const ImageWidget({
    this.height = 80,
    this.width = 80,
    required this.ean,
    required this.plu,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return GestureDetector(
                  onTap: (){
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
      return Image.asset(
        'lib/ui/assets/images/image_not_found.png',
        width: width,
        height: height,
        fit: BoxFit.cover,
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
