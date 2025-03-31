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
    final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

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
          InkWell(
            onTap: () {
              _tooltipKey.currentState?.ensureTooltipVisible();
            },
            child: Tooltip(
              key: _tooltipKey,
              message: "${R.string.canceledBy}: ${canceledBy.first.Name}",
              child: Icon(
                Icons.info,
                color: Colors.black,
                shadows: [
                  Shadow(
                    color: Colors.white,
                    blurRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: Colors.white,
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
