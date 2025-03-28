import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';
import '../../helpers/sizes/sizes.dart';

class PepperBadge extends StatelessWidget {
  final ProductsViewModel? product;
  final double width;
  final double height;
  const PepperBadge({
    required this.product,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (_getPepperQuantity(product?.ProductComplement.toString()) == 0) {
      return const SizedBox();
    }

    return Positioned(
      right: ScreenSize.hasMinWidth ? width * 0.4 : 10,
      top: 5,
      child: CircleAvatar(
        minRadius: _getSize(height: height, width: width),
        maxRadius: _getSize(height: height, width: width),
        backgroundColor: Colors.grey.withAlpha(76),
        child: Row(
          children: List.generate(
            _getPepperQuantity(product?.ProductComplement),
            (_) => Flexible(child: _pepperImage()),
          ),
        ),
      ),
    );
  }
}

double _getSize({
  required double height,
  required double width,
}) {
  if (width > height) {
    return height * 0.5;
  } else {
    return width * 0.5;
  }
}

int _getPepperQuantity(String? complement) {
  String? lowerCaseComplement = complement?.toString().toLowerCase();

  if (lowerCaseComplement?.contains("(p)") == true) {
    return 1;
  } else if (lowerCaseComplement?.contains("(pp)") == true) {
    return 2;
  } else if (lowerCaseComplement?.contains("(ppp)") == true) {
    return 3;
  } else {
    return 0;
  }
}

Widget _pepperImage() {
  return Image.asset(
    "lib/ui/assets/images/pepper.png",
    fit: BoxFit.cover,
  );
}
