import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/helpers.dart';
import '../pages/pages.dart';

class PriceAndUpdateProductQuantity extends StatefulWidget {
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  final ProductsViewModel product;
  const PriceAndUpdateProductQuantity({
    required this.onPressedReduceQuantity,
    required this.onPressedAddQuantity,
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
              padding: const EdgeInsets.all(0),
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
                      widget.product.productQuantity
                          .toString()
                          .toBrazilianNumber(
                              widget.product.productQuantity < 0.01 ? 3 : 2),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: StringSize.size,
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
            totalLiquid.toString().toBrazilianNumber().addBrazilianCoin(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: StringSize.size,
            ),
          ),
        ),
      ],
    );
  }
}
