import 'package:flutter/material.dart';

import '../products.dart';

class ImageWidget extends StatelessWidget {
  final ProductsViewModel product;
  final double height;
  final double width;
  const ImageWidget({
    this.height = 80,
    this.width = 80,
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        product.image,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.asset(
            'lib/ui/assets/images/image_not_found.png',
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
        },
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
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
      ),
    );
  }
}
