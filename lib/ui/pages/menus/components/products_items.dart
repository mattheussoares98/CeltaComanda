import 'package:clean_celta_mobile/ui/helpers/sizes/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class ProductsItems extends StatelessWidget {
  final List<ProductsViewModel> products;
  final ScrollController scrollController;

  const ProductsItems({
    required this.products,
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductsPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

    return ListView.builder(
        controller: scrollController,
        itemCount: products.length,
        itemBuilder: (context, i) {
          final product = products[i];

          return GestureDetector(
            onTap: () async {
              await insertProductsPresenter.updateSelectedProduct(
                product: product,
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
              );
              menuPresenter.goToInsertProductPage(product);
              menuPresenter.updateSuggestionsProducts(product);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, 2, 3),
              child: Container(
                height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height) /
                    3.5,
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
                  if (hasMinWidth(context)) {
                    return LandscapeNameImagePriceComboxAndComplement(
                      productsViewModel: product,
                      itemHeight: constraints.maxHeight,
                      itemWidth: constraints.maxWidth,
                    );
                  } else {
                    return PortraitNameImagePriceComboxComplement(
                      productsViewModel: product,
                    );
                  }
                }),
              ),
            ),
          );
        });
  }
}
