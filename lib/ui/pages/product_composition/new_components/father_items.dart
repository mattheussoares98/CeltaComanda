import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class FathersItems extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfSelectedFather;
  const FathersItems({
    required this.selectedProduct,
    required this.indexOfSelectedFather,
    super.key,
  });

  Color getItemColor(int index, BuildContext context) {
    if (index <= indexOfSelectedFather) {
      return Theme.of(context).primaryColorDark;
    } else {
      return Theme.of(context).primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: selectedProduct.childsComposition!.length + 1,
                itemBuilder: (context, index) {
                  if (index + 1 ==
                      selectedProduct.childsComposition!.length + 1) {
                    return FatherItem(
                      indexOfSelectedFather: index,
                      selectedProduct: selectedProduct,
                      father: null,
                      itemColor: getItemColor(index, context),
                    );
                  }

                  final father = selectedProduct.childsComposition![index];

                  return FatherItem(
                    father: father,
                    indexOfSelectedFather: index,
                    selectedProduct: selectedProduct,
                    itemColor: getItemColor(index, context),
                  );
                },
              ),
            ),
          ),
          StreamBuilder<double>(
              stream: productCompositionPresenter.totalPriceComboxStream,
              builder: (context, snapshot) {
                Future.delayed(Duration.zero, () {
                  productCompositionPresenter.updateTotalLiquidCombox(
                      selectedProduct.childsComposition!);
                });

                double total = snapshot.data ?? 0;
                return Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          total
                              .toString()
                              .toBrazilianNumber()
                              .addBrazilianCoin(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: getStringSize(context) * 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
