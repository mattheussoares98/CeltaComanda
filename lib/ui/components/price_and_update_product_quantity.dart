import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/helpers.dart';
import '../pages/pages.dart';

class PriceAndUpdateProductQuantity extends StatefulWidget {
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  final int productQuantity;
  final ProductsViewModel product;
  const PriceAndUpdateProductQuantity({
    required this.onPressedReduceQuantity,
    required this.onPressedAddQuantity,
    required this.productQuantity,
    required this.product,
    super.key,
  });

  @override
  State<PriceAndUpdateProductQuantity> createState() =>
      _PriceAndUpdateProductQuantityState();
}

class _PriceAndUpdateProductQuantityState
    extends State<PriceAndUpdateProductQuantity> {
  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    double totalLiquid =
        insertProductPresenter.calculateProductTotalLiquid(widget.product);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    color: Theme.of(context).primaryColor,
                    onPressed: widget.onPressedReduceQuantity,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      widget.productQuantity.toString().toBrazilianNumber(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: hasMinWidth(context) ? 20 : 15,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    color: Theme.of(context).primaryColor,
                    onPressed: widget.onPressedAddQuantity,
                  ),
                ],
              ),
            ),
          ),
        ),
        FittedBox(
          child: Text(
            widget.product.childsComposition == null
                ? (totalLiquid * widget.productQuantity)
                    .toString()
                    .toBrazilianNumber()
                    .addBrazilianCoin()
                : totalLiquid.toString().toBrazilianNumber().addBrazilianCoin(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: getStringSize(context),
            ),
          ),
        ),
      ],
    );
  }
}
