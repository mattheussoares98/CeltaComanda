import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../domain/entities/entities.dart';
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

  Future<void> _updateSaleRequest({
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required ProductsViewModel productsViewModel,
  }) async {
    try {
      await menuPresenter.updateSaleRequest(
          homePresenter: homePresenter,
          saleRequestTempPresenter: saleRequestTempPresenter,
          products: [
            UpdateSaleRequestTempProductEntity(
              ProductInternalCodeOnErp:
                  productsViewModel.InternalCodeOnERP.toString().toInt(),
              ProductPriceLookUpCode: productsViewModel.PriceLookupCode,
              Quantity: productsViewModel.productQuantity,
              SaleRequestTempId: saleRequestTempPresenter
                  .saleRequestTemp!.SaleRequestTempId
                  .toInt(),
              TotalLiquid: productsViewModel.SaleRetailPraticed.toDouble() *
                  productsViewModel.productQuantity,
              Value: productsViewModel.SaleRetailPraticed.toDouble(),
              Comments: commentTextController.text.isEmpty == true
                  ? null
                  : commentTextController.text,
            )
          ]);
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

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.products.length,
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
              await _updateSaleRequest(
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
      ),
    );
  }
}
