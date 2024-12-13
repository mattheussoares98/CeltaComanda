import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class CommentField extends StatelessWidget {
  final ProductsViewModel product;
  final FocusNode commentFocusNode;
  final TextEditingController commentController;
  final Future<void> Function() addProduct;
  const CommentField({
    required this.product,
    required this.commentFocusNode,
    required this.commentController,
    required this.addProduct,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: product.IsPromoCombox != "true",
      focusNode: commentFocusNode,
      controller: commentController,
      onFieldSubmitted: (_) async {
        await addProduct();
      },
      decoration: formFieldDecoration(
        context: context,
        hintText: R.string.comment,
        labelText: R.string.comment,
        errorText: null,
      ),
    );
  }
}
