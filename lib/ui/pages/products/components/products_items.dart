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
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    ProductsPresenter productsPresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final productViewModel = widget.products[index];

          return ProductItemWidget(
            isExpansibleGroups: false,
            index: index,
            selectedIndex: selectedIndex,
            updateSelectedIndex: () {
              if (selectedIndex == index) {
                setState(() {
                  selectedIndex = -1;
                });
              } else {
                setState(() {
                  selectedIndex = index;
                });
              }
            },
            goToComboxPage: () {
              productsPresenter.goToComboxPage(productViewModel);
            },
            productsViewModel: productViewModel,
          );
        },
      ),
    );
  }
}
