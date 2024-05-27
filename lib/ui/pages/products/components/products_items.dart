import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/ui/helpers/convert/convert.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../ui/pages/pages.dart';
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
    required ProductsPresenter productsPresenter,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required ProductsViewModel productsViewModel,
  }) async {
    try {
      await productsPresenter.updateSaleRequest(
          productsViewModel: productsViewModel,
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
      e;
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
    ProductsPresenter productsPresenter = Provider.of(context, listen: false);
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

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
                productsPresenter: productsPresenter,
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
              productsPresenter.goToComboxPage(productsViewModel);
            },
            productsViewModel: productsViewModel,
          );
        },
      ),
    );
  }
}
