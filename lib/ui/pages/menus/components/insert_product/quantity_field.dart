import 'package:flutter/material.dart';

import '../../../../../ui/helpers/helpers.dart';
import '../../../../components/components.dart';
import '../../../pages.dart';

class QuantityField extends StatelessWidget {
  final ProductsViewModel product;
  final TextEditingController quantityController;
  final FocusNode commentFocusNode;
  final FocusNode quantityFocusNode;
  const QuantityField({
    required this.product,
    required this.quantityController,
    required this.commentFocusNode,
    required this.quantityFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double? maximumQuantity = product.MaximumQuantityForSale == null ||
            product.MaximumQuantityForSale!.toDouble() == 0
        ? 100
        : product.MaximumQuantityForSale!.toDouble();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${R.string.maximumAbbreviated}: ${maximumQuantity.toString().toBrazilianNumber(0)}",
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: quantityController,
                    textAlign: TextAlign.center,
                    focusNode: quantityFocusNode,
                    enabled: product.IsPromoCombox != "true",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onTap: () {
                      quantityController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: quantityController.text.length,
                      );
                    },
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                    onFieldSubmitted: (_) async {
                      if (quantityController.text.isNotEmpty) {
                        commentFocusNode.requestFocus();
                      } else {
                        quantityFocusNode.requestFocus();
                      }
                    },
                    validator: (value) {
                      double? valueInNumber = value?.toDouble();
                      if (valueInNumber == null || valueInNumber == -1) {
                        return R.string.msgInvalidNumber;
                      } else if (valueInNumber < 0.001) {
                        return R.string.msgInvalidNumber;
                      } else if (valueInNumber > maximumQuantity.toDouble()) {
                        return R.string.msgMaximumQuantityAchieved;
                      }

                      return null;
                    },
                    decoration: formFieldDecoration(
                      context: context,
                      hintText: R.string.quantity,
                      labelText: R.string.quantity,
                      errorText: null,
                      prefixIcon: IconButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          double value = quantityController.text.toDouble();

                          if (value != -1 && value > 1) {
                            quantityController.text = (value - 1)
                                .toString()
                                .toDouble()
                                .toStringAsFixed(3)
                                .toBrazilianNumber(3);
                          }
                        },
                        icon: Icon(Icons.remove),
                      ),
                      suffixIcon: IconButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (quantityController.text.isEmpty) {
                            quantityController.text = "1";
                            return;
                          }

                          double value = quantityController.text.toDouble();

                          if (value == -1) {
                            return;
                          } else if (value + 1 < maximumQuantity) {
                            quantityController.text =
                                (value + 1).toString().toBrazilianNumber(3);
                          } else {
                            quantityController.text =
                                maximumQuantity.toString().toBrazilianNumber(3);
                          }
                        },
                        icon: Icon(Icons.add),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
