import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class ProductsItems extends StatefulWidget {
  final List<ProductsViewModel> products;
  final int itensPerLine;
  final bool updateSelectedProductWhenClick;
  final ProductsViewModel? selectedProduct;
  const ProductsItems({
    required this.products,
    required this.itensPerLine,
    required this.updateSelectedProductWhenClick,
    required this.selectedProduct,
    super.key,
  });

  @override
  State<ProductsItems> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  int indexOfSelectedProductCommentIcon = -1;
  final commentTextController = TextEditingController();

  Widget product({
    required int index,
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) =>
      GestureDetector(
        onLongPress: () {
          ImageWidget.showLargeImage(
            context: context,
            ean: widget.products[index].EanCode,
            plu: widget.products[index].PriceLookupCode,
          );
        },
        onTap: () {
          if (widget.products[index].IsPromoCombox == "true") {
            menuPresenter.goToComboxPage(widget.products[index]);
          } else {
            menuPresenter.updateSelectedProduct(widget.products[index]);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: ProductItem(
            productIsSelected: widget.products[index] == widget.selectedProduct,
            productsViewModel: widget.products[index],
          ),
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
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
          ),
        );
      },
    );
  }
}
