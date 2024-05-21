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
  final int index;
  final int selectedIndex;
  final bool isExpansibleGroups;

  const ProductItemWidget({
    required this.productsViewModel,
    required this.goToComboxPage,
    required this.index,
    required this.selectedIndex,
    required this.updateSelectedIndex,
    required this.isExpansibleGroups,
    super.key,
  });

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  final commentTextController = TextEditingController();
  FocusNode commentFocusNode = FocusNode();
  String confirmedComment = "";
  double productQuantity = 1.0;

  void _clearDataOnSuccess() {
    setState(() {
      productQuantity = 1;
    });
  }

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
    SaleRequestTempPresenter saleRequestTempPresenter = Provider.of(context);

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
                      onPressedReduceQuantity: productQuantity <= 1
                          ? null
                          : () {
                              setState(() {
                                productQuantity--;
                              });
                            },
                      onPressedAddQuantity: () {
                        setState(() {
                          productQuantity++;
                        });
                      },
                      productQuantity: productQuantity,
                      price: widget.productsViewModel.SaleRetailPraticed
                          .toDouble(),
                      totalLiquid: (widget.productsViewModel.SaleRetailPraticed
                                  .toDouble() *
                              productQuantity)
                          .toString()
                          .toDouble(),
                    ),
                    if (widget.productsViewModel.IsPromoCombox == "true")
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 35, 39, 35),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(3),
                        ),
                        onPressed: widget.goToComboxPage,
                        child: const Text("Montar\ncombo"),
                      ),
                  ],
                ),
              ],
            ),
            if (widget.productsViewModel.IsPromoCombox == "false")
              CommentAndAddProductButtons(
                isExpansibleGroups: widget.isExpansibleGroups,
                productsViewModel: widget.productsViewModel,
                updateSelectedIndex: widget.updateSelectedIndex,
                index: widget.index,
                selectedIndex: widget.selectedIndex,
                changeFocusToCommentFocusNode: () async {
                  await changeFocusToCommentFocusNode();
                },
                productQuantity: productQuantity,
                commentTextController: commentTextController,
                isConfirmedComment: confirmedComment != "",
                updateIsConfirmendCommentToFalse: () {
                  commentTextController.clear();
                  confirmedComment = "";
                  widget.updateSelectedIndex();
                },
                clearProductQuantity: _clearDataOnSuccess,
              ),
            CommentWidget(
              index: widget.index,
              selectedIndex: widget.selectedIndex,
              commentFocusNode: commentFocusNode,
              commentTextController: commentTextController,
              confirmedComment: confirmedComment,
              changeFocusToCommentFocusNode: () async {
                await changeFocusToCommentFocusNode();
              },
              updateConfirmedComment: () {
                confirmedComment = commentTextController.text;
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
