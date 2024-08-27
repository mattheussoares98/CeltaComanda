import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';

class PepperIndicator extends StatelessWidget {
  final ProductsViewModel product;
  const PepperIndicator({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String lowerCaseComplement =
        product.ProductComplement.toString().toLowerCase();

    if (lowerCaseComplement.contains("(p)") == true) {
      return _pepperImage();
    } else if (lowerCaseComplement.contains("(pp)") == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _pepperImage(),
          _pepperImage(),
        ],
      );
    } else if (lowerCaseComplement.contains("(ppp)") == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _pepperImage(),
          _pepperImage(),
          _pepperImage(),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

Widget _pepperImage() {
  return Image.asset(
    "lib/ui/assets/images/pepper.png",
    height: 20,
    width: 20,
    fit: BoxFit.cover,
  );
}
