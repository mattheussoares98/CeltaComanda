import 'package:clean_celta_mobile/ui/components/components.dart';

import '../../helpers/helpers.dart';
import 'package:flutter/material.dart';

class PriceAndUpdateProductQuantity extends StatefulWidget {
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  final double productQuantity;
  final double price;
  final double totalLiquid;
  final bool showUpdateProductQuantity;
  const PriceAndUpdateProductQuantity({
    required this.onPressedReduceQuantity,
    required this.onPressedAddQuantity,
    required this.productQuantity,
    required this.price,
    required this.totalLiquid,
    required this.showUpdateProductQuantity,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("${widget.price.toString().toBrazilianNumber()} R\$"),
        if (widget.showUpdateProductQuantity)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: UpdateQuantity(
                  productQuantity: widget.productQuantity,
                  onPressedReduceQuantity: widget.onPressedReduceQuantity,
                  onPressedAddQuantity: widget.onPressedAddQuantity,
                ),
              ),
              Text(widget.totalLiquid
                  .toString()
                  .toBrazilianNumber()
                  .addBrazilianCoin()),
            ],
          ),
      ],
    );
  }
}
