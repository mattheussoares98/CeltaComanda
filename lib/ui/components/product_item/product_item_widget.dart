import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../main/builders/builders.dart';
import '../../../ui/components/components.dart';
import '../../pages/pages.dart';

class ProductItemWidget extends StatefulWidget {
  final ProductsViewModel productsViewModel;
  final void Function()? goToComboxPage;
  final void Function() updateSelectedIndex;
  final Function() updateSaleRequest;
  final Function() addProductQuantity;
  final Function() subtractProductQuantity;
  final Function() clearProductQuantity;
  final double productQuantity;
  final int index;
  final int selectedIndex;
  final TextEditingController commentTextController;

  const ProductItemWidget({
    required this.productsViewModel,
    required this.goToComboxPage,
    required this.index,
    required this.selectedIndex,
    required this.updateSelectedIndex,
    required this.updateSaleRequest,
    required this.addProductQuantity,
    required this.subtractProductQuantity,
    required this.productQuantity,
    required this.clearProductQuantity,
    required this.commentTextController,
    super.key,
  });

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  FocusNode commentFocusNode = FocusNode();
  String confirmedComment = "";

  Future<void> changeFocusToCommentFocusNode() async {
    if (commentFocusNode.hasFocus &&
        MediaQuery.of(NavigatorKey.navigatorKey.currentState!.context)
                .viewInsets
                .bottom ==
            0) {
      await Future.delayed(Duration.zero);
      commentFocusNode.unfocus();
    }
    await Future.delayed(Duration.zero);
    commentFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(3, 5, 8, 0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x411D2429),
              offset: Offset(
                0.0,
                1,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageWidget(
                  ean: widget.productsViewModel.EanCode,
                  plu: widget.productsViewModel.PriceLookupCode,
                ),
                const SizedBox(width: 5),
                PluAndEan(productsViewModel: widget.productsViewModel),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PendingProductQuantity(
                      saleRequestTempPresenter: saleRequestTempPresenter,
                      productsViewModel: widget.productsViewModel,
                    ),
                    PriceAndUpdateProductQuantity(
                      showUpdateProductQuantity:
                          widget.productsViewModel.IsPromoCombox == "false",
                      onPressedReduceQuantity: widget.productQuantity <= 1
                          ? null
                          : widget.subtractProductQuantity,
                      onPressedAddQuantity: widget.addProductQuantity,
                      productQuantity: widget.productQuantity,
                      price: widget.productsViewModel.SaleRetailPraticed
                          .toDouble(),
                      totalLiquid: (widget.productsViewModel.SaleRetailPraticed
                                  .toDouble() *
                              widget.productQuantity)
                          .toString()
                          .toDouble(),
                    ),
                    if (widget.productsViewModel.IsPromoCombox == "true")
                      GestureDetector(
                        onTap: widget.goToComboxPage,
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            "Montar\ncombo",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (widget.productsViewModel.IsPromoCombox == "false")
              CommentAndAddProductButtons(
                updateSelectedIndex: widget.updateSelectedIndex,
                index: widget.index,
                selectedIndex: widget.selectedIndex,
                changeFocusToCommentFocusNode: () async {
                  await changeFocusToCommentFocusNode();
                },
                updateSaleRequest: () async {
                  await widget.updateSaleRequest();
                },
                commentTextController: widget.commentTextController,
                isConfirmedComment: confirmedComment != "",
                updateIsConfirmendCommentToFalse: () {
                  widget.commentTextController.clear();
                  confirmedComment = "";
                  widget.updateSelectedIndex();
                },
                clearProductQuantity: widget.clearProductQuantity,
              ),
            CommentWidget(
              index: widget.index,
              selectedIndex: widget.selectedIndex,
              commentFocusNode: commentFocusNode,
              commentTextController: widget.commentTextController,
              confirmedComment: confirmedComment,
              changeFocusToCommentFocusNode: () async {
                await changeFocusToCommentFocusNode();
              },
              updateConfirmedComment: () {
                confirmedComment = widget.commentTextController.text;
              },
              updateSelectedIndex: () {
                widget.updateSelectedIndex();
              },
            ),
          ],
        ),
      ),
    );
  }
}
