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
    return TextFormField(
      enabled: product.IsPromoCombox != "true",
      controller: quantityController,
      focusNode: quantityFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.toDouble() == -1) {
          return R.string.msgInvalidNumber;
        } else if (value.toDouble() < 0.001) {
          return R.string.msgInvalidNumber;
        }
        return null;
      },
      onFieldSubmitted: (_) {
        if (quantityController.text.isNotEmpty) {
          commentFocusNode.requestFocus();
        } else {
          quantityFocusNode.requestFocus();
        }
      },
      decoration: formFieldDecoration(
        context: context,
        hintText: R.string.quantity,
        labelText: R.string.quantity,
        errorText: null,
      ),
    );
  }
}
