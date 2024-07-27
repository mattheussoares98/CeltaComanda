import 'package:flutter/material.dart';

class ProductsAndCommentsButtons extends StatelessWidget {
  final bool productHasComment;
  final int indexOfSelectedFather;
  final bool showComments;
  final Function() advanceSelectedIndex;
  const ProductsAndCommentsButtons({
    required this.productHasComment,
    required this.indexOfSelectedFather,
    required this.showComments,
    required this.advanceSelectedIndex,
    super.key,
  });

  static Widget productOrCommentButton({
    required bool isSelected,
    required String text,
    required void Function()? onPressed,
    required BuildContext context,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor:
            isSelected ? Theme.of(context).primaryColorDark : Colors.white,
        foregroundColor: isSelected
            ? Theme.of(context).primaryColorDark
            : Theme.of(context).primaryColorLight,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color:
              isSelected ? Colors.white : Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
      child: Column(
        children: [
          productOrCommentButton(
            context: context,
            onPressed: !showComments ? null : advanceSelectedIndex,
            isSelected: !showComments,
            text: "Produtos",
          ),
          const SizedBox(height: 10),
          if (productHasComment)
            productOrCommentButton(
              context: context,
              onPressed: showComments ? null : advanceSelectedIndex,
              isSelected: showComments,
              text: "Comentários",
            ),
        ],
      ),
    );
  }
}
