import 'package:flutter/material.dart';

import '../../../../main/builders/builders.dart';
import '../../pages.dart';

class ProductItem extends StatefulWidget {
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
  final bool productIsSelected;

  const ProductItem({
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
    required this.productIsSelected,
    super.key,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.productIsSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 3,
            color: Color(0x411D2429),
            offset: Offset(
              2,
              -2,
            ),
          ),
          BoxShadow(
            blurRadius: 3,
            color: Color(0x411D2429),
            offset: Offset(
              -2,
              2,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: NameImagePluAndEan(productsViewModel: widget.productsViewModel),
        // if (widget.productsViewModel.IsPromoCombox == "true")
        //   GestureDetector(
        //     onTap: widget.goToComboxPage,
        //     child: const Padding(
        //       padding: EdgeInsets.only(bottom: 5.0),
        //       child: Text(
        //         "Montar\ncombo",
        //         style: TextStyle(
        //           color: Colors.blue,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ),
      ),
    );
  }
}
