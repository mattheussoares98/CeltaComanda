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
  const CommentAndAddProductButtons({
    required this.isExpansibleGroups,
    required this.productsViewModel,
    required this.updateSelectedIndex,
    required this.index,
    required this.selectedIndex,
    required this.commentTextController,
    required this.changeFocusToCommentFocusNode,
    super.key,
  });

  @override
  State<CommentAndAddProductButtons> createState() =>
      _CommentAndAddProductButtonsState();
}

class _CommentAndAddProductButtonsState
    extends State<CommentAndAddProductButtons> {
  bool isConfirmedComment = false;

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
        setState(() {
          isConfirmedComment = false;
        });
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
        setState(() {
          isConfirmedComment = false;
        });
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
      children: [
        IconButton(
          onPressed: () async {
            widget.updateSelectedIndex();

            if (widget.index != widget.selectedIndex) {
              widget.commentTextController.clear();

              await widget.changeFocusToCommentFocusNode();
            }
          },
          icon: Icon(
            isConfirmedComment ? Icons.edit : Icons.add_comment,
            color: Colors.green,
            size: 37,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            maximumSize: const Size(33, 33),
            minimumSize: const Size(33, 33),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(0),
          ),
          onPressed: () async {
            if (widget.commentTextController.text.isNotEmpty &&
                !isConfirmedComment) {
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
          child: const FittedBox(
              child: Text("+1", style: TextStyle(fontSize: 15))),
        ),
      ],
    );
  }
}
