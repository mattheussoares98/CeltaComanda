import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';

class ProductsItems extends StatefulWidget {
  final List<ProductsViewModel> products;
  final int itensPerLine;
  const ProductsItems({
    required this.products,
    required this.itensPerLine,
    super.key,
  });

  @override
  State<ProductsItems> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  int indexOfSelectedProductCommentIcon = -1;
  final commentTextController = TextEditingController();

  Future<void> _addProductInCart({
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required ProductsViewModel productsViewModel,
  }) async {
    try {
      //addProductInCart
      _updateSelectedIndex(-1);
    } catch (e) {
      Future.delayed(Duration.zero, () {
        showErrorMessage(context, R.string.msgUnexpectedError);
      });
    }
  }

  void _addProductQuantity(ProductsViewModel productsViewModel) {
    setState(() {
      productsViewModel.productQuantity++;
    });
  }

  void _subtractProductQuantity(ProductsViewModel productsViewModel) {
    setState(() {
      productsViewModel.productQuantity--;
    });
  }

  void _clearProductQuantity(ProductsViewModel productsViewModel) {
    setState(() {
      productsViewModel.productQuantity = 1;
    });
  }

  void _updateSelectedIndex(int index) {
    if (indexOfSelectedProductCommentIcon == index) {
      setState(() {
        indexOfSelectedProductCommentIcon = -1;
      });
    } else {
      setState(() {
        indexOfSelectedProductCommentIcon = index;
      });
    }
  }

  Widget product({
    required int index,
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 5, 0),
        child: ProductItemWidget(
          productsViewModel: widget.products[index],
          addProductQuantity: () {
            _addProductQuantity(widget.products[index]);
          },
          clearProductQuantity: () {
            _clearProductQuantity(widget.products[index]);
          },
          subtractProductQuantity: () {
            _subtractProductQuantity(widget.products[index]);
          },
          updateSaleRequest: () async {
            await _addProductInCart(
              menuPresenter: menuPresenter,
              homePresenter: homePresenter,
              saleRequestTempPresenter: saleRequestTempPresenter,
              productsViewModel: widget.products[index],
            );
          },
          productQuantity: widget.products[index].productQuantity,
          commentTextController: commentTextController,
          index: index,
          selectedIndex: indexOfSelectedProductCommentIcon,
          updateSelectedIndex: () {
            _updateSelectedIndex(index);
          },
          goToComboxPage: () {
            menuPresenter.goToComboxPage(widget.products[index]);
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return ListView.builder(
      itemCount: (widget.products.length / widget.itensPerLine).ceil(),
      itemBuilder: (context, rowIndex) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = rowIndex * widget.itensPerLine;
                  i < (rowIndex + 1) * widget.itensPerLine;
                  i++)
                if (i < widget.products.length)
                  Expanded(
                    child: product(
                      index: i,
                      menuPresenter: menuPresenter,
                      homePresenter: homePresenter,
                      saleRequestTempPresenter: saleRequestTempPresenter,
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
