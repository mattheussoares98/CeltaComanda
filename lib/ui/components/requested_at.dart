import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import '../pages/pages.dart';

class RequestedAt extends StatelessWidget {
  final PrintedProductsViewModel printedProduct;
  const RequestedAt({
    required this.printedProduct,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ScreenSize.hasMinWidth ? 5 : 3),
      child: Text(
        "${DateTime.parse(printedProduct.DateHourOfCreation!).hour.toString().padLeft(2, "0")}:${DateTime.parse(printedProduct.DateHourOfCreation!).minute.toString().padLeft(2, "0")}",
        style: TextStyle(
          fontSize: StringSize.size * 0.8,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
