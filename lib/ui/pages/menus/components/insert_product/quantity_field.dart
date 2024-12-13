import 'package:flutter/material.dart';

import '../../../../../ui/helpers/helpers.dart';
import '../../../../components/components.dart';
import '../../../pages.dart';

class QuantityField extends StatelessWidget {
  final ProductsViewModel product;
  final TextEditingController quantityController;
  final FocusNode commentFocusNode;
  const QuantityField({
    required this.product,
    required this.quantityController,
    required this.commentFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: product.IsPromoCombox != "true",
      controller: quantityController,
      validator: (value) {
        if (value == null || value.toDouble() == -1) {
          return R.string.msgInvalidNumber;
        }
        return null;
      },
      onFieldSubmitted: (_) {
        commentFocusNode.requestFocus();
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
