import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';

class ProductsItems extends StatefulWidget {
  final List<ProductsViewModel> products;
  const ProductsItems({
    required this.products,
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

  @override
  Widget build(BuildContext context) {
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.15,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
          ),
          itemBuilder: (context, index) {
            final productsViewModel = widget.products[index];

            return ProductItemWidget(
              addProductQuantity: () {
                _addProductQuantity(productsViewModel);
              },
              clearProductQuantity: () {
                _clearProductQuantity(productsViewModel);
              },
              subtractProductQuantity: () {
                _subtractProductQuantity(productsViewModel);
              },
              updateSaleRequest: () async {
                await _addProductInCart(
                  menuPresenter: menuPresenter,
                  homePresenter: homePresenter,
                  saleRequestTempPresenter: saleRequestTempPresenter,
                  productsViewModel: productsViewModel,
                );
              },
              productQuantity: productsViewModel.productQuantity,
              commentTextController: commentTextController,
              index: index,
              selectedIndex: indexOfSelectedProductCommentIcon,
              updateSelectedIndex: () {
                _updateSelectedIndex(index);
              },
              goToComboxPage: () {
                menuPresenter.goToComboxPage(productsViewModel);
              },
              productsViewModel: productsViewModel,
            );
          },
        );
      },
    );
  }
}
