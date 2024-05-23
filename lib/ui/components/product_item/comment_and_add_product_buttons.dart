import 'package:clean_celta_mobile/ui/helpers/convert/convert.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
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
  final Function() clearProductQuantity;
  final double productQuantity;

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
    required this.clearProductQuantity,
    required this.productQuantity,
    super.key,
  });

  @override
  State<CommentAndAddProductButtons> createState() =>
      _CommentAndAddProductButtonsState();
}

class _CommentAndAddProductButtonsState
    extends State<CommentAndAddProductButtons> {
  void _clearDataOnSuccess() {
    widget.commentTextController.clear();
    widget.updateIsConfirmendCommentToFalse();
    widget.updateSelectedIndex();
    widget.clearProductQuantity();
  }

  Future<void> updateSaleRequestTemp({
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required ProductsPresenter productsPresenter,
    required double productQuantity,
  }) async {
    if (widget.isExpansibleGroups) {
      try {
        await expansibleGroupsPresenter.updateSaleRequest(
            saleRetailPraticed:
                widget.productsViewModel.SaleRetailPraticed.toDouble(),
            homePresenter: homePresenter,
            saleRequestTempPresenter: saleRequestTempPresenter,
            products: [
              UpdateSaleRequestTempProductEntity(
                ProductInternalCodeOnErp: widget
                    .productsViewModel.InternalCodeOnERP
                    .toString()
                    .toInt(),
                ProductPriceLookUpCode:
                    widget.productsViewModel.PriceLookupCode,
                Quantity: productQuantity,
                SaleRequestTempId: int.parse(saleRequestTempPresenter
                    .saleRequestTemp!.SaleRequestTempId),
                TotalLiquid:
                    widget.productsViewModel.SaleRetailPraticed.toDouble() *
                        productQuantity,
                Value: widget.productsViewModel.SaleRetailPraticed.toDouble(),
                Comments: widget.commentTextController.text.isEmpty == true
                    ? null
                    : widget.commentTextController.text,
              ),
            ]);
        _clearDataOnSuccess();
      } catch (e) {
        e;
      }
    } else {
      try {
        await productsPresenter.updateSaleRequest(
            productsViewModel: widget.productsViewModel,
            homePresenter: homePresenter,
            saleRequestTempPresenter: saleRequestTempPresenter,
            products: [
              UpdateSaleRequestTempProductEntity(
                ProductInternalCodeOnErp: widget
                    .productsViewModel.InternalCodeOnERP
                    .toString()
                    .toInt(),
                ProductPriceLookUpCode:
                    widget.productsViewModel.PriceLookupCode,
                Quantity: productQuantity,
                SaleRequestTempId: int.parse(saleRequestTempPresenter
                    .saleRequestTemp!.SaleRequestTempId),
                TotalLiquid:
                    widget.productsViewModel.SaleRetailPraticed.toDouble(),
                Value: widget.productsViewModel.SaleRetailPraticed.toDouble(),
                Comments: widget.commentTextController.text.isEmpty == true
                    ? null
                    : widget.commentTextController.text,
              )
            ]);
        _clearDataOnSuccess();
      } catch (e) {
        e;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context, listen: false);
    ProductsPresenter productsPresenter = Provider.of(context, listen: false);
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
                  "Comentário",
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
                    productQuantity: widget.productQuantity,
                  );
                },
              );
            } else {
              await updateSaleRequestTemp(
                expansibleGroupsPresenter: expansibleGroupsPresenter,
                homePresenter: homePresenter,
                saleRequestTempPresenter: saleRequestTempPresenter,
                productsPresenter: productsPresenter,
                productQuantity: widget.productQuantity,
              );
            }
          },
        ),
      ],
    );
  }
}
