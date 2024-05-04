// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import '../pages/pages.dart';

class ProductDetails extends StatelessWidget {
  final ProductsViewModel Product;
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  final void Function()? onPressedRemoveProduct;
  final String quantity;
  final String value;
  final String totalLiquid;
  final String? comments;
  final bool isPrintedProducts;
  final bool showFormFieldUpdateComment;
  final void Function()? onTapCommentIcon;
  final TextEditingController? commentsController;
  final FocusNode? commentsFocusNode;

  const ProductDetails({
    required this.Product,
    required this.onPressedReduceQuantity,
    required this.onPressedAddQuantity,
    required this.onPressedRemoveProduct,
    required this.quantity,
    required this.value,
    required this.totalLiquid,
    required this.isPrintedProducts,
    required this.showFormFieldUpdateComment,
    required this.onTapCommentIcon,
    required this.commentsController,
    required this.commentsFocusNode,
    this.comments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Product.NameComplete != null
                        ? Product.NameComplete!
                        : Product.Name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Column(
                    children: [
                      if (Product.EanCode != null)
                        Text(
                          "EAN: ${Product.EanCode!}",
                        ),
                      Text(
                        "PLU: ${Product.PriceLookupCode}",
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: onTapCommentIcon,
                    child: Icon(
                      color: Theme.of(context).colorScheme.primary,
                      comments != null ? Icons.edit : Icons.add_comment,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Preço $value R\$"),
                _UpdateQuantity(
                  onPressedReduceQuantity: onPressedReduceQuantity,
                  quantity: quantity,
                  onPressedAddQuantity: onPressedAddQuantity,
                  isPrintedProducts: isPrintedProducts,
                  onPressedRemoveProduct: onPressedRemoveProduct,
                ),
                Text("Total $totalLiquid R\$"),
              ],
            ),
          ],
        ),
        if (comments != null) Text("Comentário: $comments"),
        if (showFormFieldUpdateComment)
          TextField(
            focusNode: commentsFocusNode,
            controller: commentsController,
            maxLines: null,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            ),
          ),
        const Divider(
          thickness: 0.2,
        )
      ],
    );
  }
}

class _UpdateQuantity extends StatelessWidget {
  final String quantity;
  final bool isPrintedProducts;
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  final void Function()? onPressedRemoveProduct;

  const _UpdateQuantity({
    required this.onPressedReduceQuantity,
    required this.quantity,
    required this.onPressedAddQuantity,
    required this.isPrintedProducts,
    required this.onPressedRemoveProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isPrintedProducts)
          Row(
            children: [
              Text("Qtd: $quantity"),
              SizedBox(
                height: 35,
                width: 35,
                child: FittedBox(
                  child: IconButton(
                    onPressed: onPressedRemoveProduct,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],
          ),
        if (!isPrintedProducts)
          Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
            child: Row(
              children: [
                IconButton(
                  key: const Key("IconButtonSubtractQuantity"),
                  icon: Icon(
                    double.parse(quantity.replaceAll(RegExp(r','), '.')) <= 1
                        ? Icons.delete
                        : Icons.remove,
                  ),
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  onPressed: onPressedReduceQuantity,
                  color: const Color(0xFFFF5963),
                ),
                Text(quantity),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                  ),
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  onPressed: onPressedAddQuantity,
                  color: const Color(0xFFFF5963),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
