import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../pages/pages.dart';
import '../components.dart';

class CommentAndAddProductButtons extends StatefulWidget {
  final bool isExpansibleGroups;
  final ProductsViewModel productsViewModel;
  final Function() updateSelectedIndex;
  final int index;
  final int selectedIndex;
  final TextEditingController commentTextController;
  final Function() changeFocusToCommentFocusNode;
  final bool isConfirmedComment;
  final Function() updateIsConfirmendCommentToFalse;

  const CommentAndAddProductButtons({
    required this.isExpansibleGroups,
    required this.productsViewModel,
    required this.updateSelectedIndex,
    required this.index,
    required this.selectedIndex,
    required this.commentTextController,
    required this.changeFocusToCommentFocusNode,
    required this.isConfirmedComment,
    required this.updateIsConfirmendCommentToFalse,
    super.key,
  });

  @override
  State<CommentAndAddProductButtons> createState() =>
      _CommentAndAddProductButtonsState();
}

class _CommentAndAddProductButtonsState
    extends State<CommentAndAddProductButtons> {
  Future<void> updateSaleRequestTemp({
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required ProductsPresenter productsPresenter,
  }) async {
    if (widget.isExpansibleGroups) {
      try {
        await expansibleGroupsPresenter.updateSaleRequest(
          productsViewModel: widget.productsViewModel,
          homePresenter: homePresenter,
          saleRequestTempPresenter: saleRequestTempPresenter,
          productComment: widget.commentTextController.text,
        );
        widget.commentTextController.clear();
        widget.updateIsConfirmendCommentToFalse();
        widget.updateSelectedIndex();
      } catch (e) {
        e;
      }
    } else {
      try {
        await productsPresenter.updateSaleRequest(
          productsViewModel: widget.productsViewModel,
          homePresenter: homePresenter,
          saleRequestTempPresenter: saleRequestTempPresenter,
          productComment: widget.commentTextController.text,
        );
        widget.updateIsConfirmendCommentToFalse();
        widget.updateSelectedIndex();
      } catch (e) {
        e;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestTempPresenter saleRequestTempPresenter = Provider.of(context);
    ExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context, listen: widget.isExpansibleGroups);
    ProductsPresenter productsPresenter =
        Provider.of(context, listen: !widget.isExpansibleGroups);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            widget.updateSelectedIndex();

            if (widget.index != widget.selectedIndex) {
              widget.commentTextController.clear();

              await widget.changeFocusToCommentFocusNode();
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 3, 0, 3),
            child: Row(
              children: [
                Icon(
                  widget.isConfirmedComment ? Icons.edit : Icons.add_comment,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.isConfirmedComment
                      ? "Alterar comentário"
                      : "Inserir comentário",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          child: Text(
            "Adicionar",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () async {
            if (widget.commentTextController.text.isNotEmpty &&
                !widget.isConfirmedComment) {
              notificationDialog(
                context: context,
                titleMessage: "Inserir produto sem comentário",
                content: const Text(
                    "Deseja realmente inserir o produto sem confirmar o comentário?"),
                onPress: () async {
                  await updateSaleRequestTemp(
                    expansibleGroupsPresenter: expansibleGroupsPresenter,
                    homePresenter: homePresenter,
                    saleRequestTempPresenter: saleRequestTempPresenter,
                    productsPresenter: productsPresenter,
                  );
                },
              );
            } else {
              await updateSaleRequestTemp(
                expansibleGroupsPresenter: expansibleGroupsPresenter,
                homePresenter: homePresenter,
                saleRequestTempPresenter: saleRequestTempPresenter,
                productsPresenter: productsPresenter,
              );
            }
          },
        ),
      ],
    );
  }
}
