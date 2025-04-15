import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class ProductsItems extends StatelessWidget {
  final List<ProductsViewModel> products;
  final ScrollController productsScrollController;
  final double itemExtent;

  const ProductsItems({
    required this.products,
    required this.productsScrollController,
    required this.itemExtent,
    super.key,
  });

  Future<void> onTapInsertInCart({
    required InsertProductPresenter insertProductsPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required ProductsViewModel product,
    required MenuPresenter menuPresenter,
  }) async {
    await insertProductsPresenter.updateSelectedProduct(
      product: product,
      expansibleGroupFromProductPresenter: expansibleGroupFromProductPresenter,
    );
    menuPresenter.goToInsertProductPage(product);
    menuPresenter.updateSuggestionsProducts(product);
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductsPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

    return ListView.builder(
        controller: productsScrollController,
        itemCount: products.length,
        itemExtent: itemExtent,
        itemBuilder: (context, i) {
          final product = products[i];

          return GestureDetector(
            onTap: () async {
              await onTapInsertInCart(
                insertProductsPresenter: insertProductsPresenter,
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
                product: product,
                menuPresenter: menuPresenter,
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, 2, 3),
              child: Container(
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
                  return LandscapeProductItem(
                    productsViewModel: product,
                    itemHeight: constraints.maxHeight,
                    itemWidth: constraints.maxWidth,
                    onTapInsertInCart: () async {
                      await onTapInsertInCart(
                        insertProductsPresenter: insertProductsPresenter,
                        expansibleGroupFromProductPresenter:
                            expansibleGroupFromProductPresenter,
                        product: product,
                        menuPresenter: menuPresenter,
                      );
                    },
                  );
                }),
              ),
            ),
          );
        });
  }
}
