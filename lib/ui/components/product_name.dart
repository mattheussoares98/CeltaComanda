import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/helpers.dart';
import '../pages/pages.dart';

class ProductName extends StatelessWidget {
  final PrintedProductsViewModel product;

  const ProductName({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);
    final canceledBy = configurationsPresenter.loadedUsers
        ?.where((e) => e.UserId == product.UserIdOfCancellation)
        .toList();

    return Row(
      children: [
        Expanded(
          child: Text(
            "${product.Product?.Name} ${product.IsCancelled == "true" ? " (cancelado)" : ""}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: StringSize.size,
            ),
          ),
        ),
        if (product.IsCancelled == "true" &&
            canceledBy != null &&
            canceledBy.isNotEmpty)
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.info, color: Colors.black),
            tooltip: "${R.string.canceledBy}: ${canceledBy.first.Name}",
          )
      ],
    );
  }
}
