import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class ProductsAndCommentsButtons extends StatelessWidget {
  final bool productHasComment;
  final int indexOfSelectedFather;
  final ScrollController scrollController;
  final bool showComments;
  const ProductsAndCommentsButtons({
    required this.productHasComment,
    required this.indexOfSelectedFather,
    required this.scrollController,
    required this.showComments,
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
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
      child: Column(
        children: [
          productOrCommentButton(
            context: context,
            onPressed: !showComments
                ? null
                : () {
                    productCompositionPresenter
                        .updateSelectedFatherIndex(indexOfSelectedFather);
                    productCompositionPresenter.scrollToIndex(scrollController);
                  },
            isSelected: !showComments,
            text: "Produtos",
          ),
          const SizedBox(height: 10),
          if (productHasComment)
            productOrCommentButton(
              context: context,
              onPressed: showComments
                  ? null
                  : () {
                      productCompositionPresenter
                          .advanceFatherIndex(commentsPresenter);
                      productCompositionPresenter
                          .scrollToIndex(scrollController);
                    },
              isSelected: showComments,
              text: "Comentários",
            ),
        ],
      ),
    );
  }
}
