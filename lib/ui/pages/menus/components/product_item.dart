import 'package:clean_celta_mobile/ui/helpers/sizes/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class ProductItem extends StatefulWidget {
  final ProductsViewModel productsViewModel;

  const ProductItem({
    required this.productsViewModel,
    super.key,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  double getItemHeight() {
    if (hasMinWidth(context)) {
      return (MediaQuery.of(context).size.height -
              AppBar().preferredSize.height) /
          2.5;
    } else {
      return (MediaQuery.of(context).size.height -
              AppBar().preferredSize.height) /
          3.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductsPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

    return GestureDetector(
      onTap: () async {
        await insertProductsPresenter.updateSelectedProduct(
          product: widget.productsViewModel,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );
        menuPresenter.goToInsertProductPage(widget.productsViewModel);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 2, 2, 3),
        child: Container(
          height: getItemHeight(),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
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
          child: LayoutBuilder(builder: (context, constraints) {
            return NameImagePriceComboxAndComplement(
              productsViewModel: widget.productsViewModel,
              itemHeight: constraints.maxHeight,
              itemWidth: constraints.maxWidth,
            );
          }),
        ),
      ),
    );
  }
}
