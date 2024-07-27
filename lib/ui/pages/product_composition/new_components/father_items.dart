import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class FathersItems extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfSelectedFather;
  final ScrollController scrollController;
  const FathersItems({
    required this.selectedProduct,
    required this.indexOfSelectedFather,
    required this.scrollController,
    super.key,
  });

  @override
  State<FathersItems> createState() => _FathersItemsState();
}

class _FathersItemsState extends State<FathersItems> {
  Color getItemColor(int index, BuildContext context) {
    if (index <= widget.indexOfSelectedFather) {
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
                controller: widget.scrollController,
                itemExtent: 42,
                shrinkWrap: true,
                itemCount: widget.selectedProduct.childsComposition!.length + 1,
                itemBuilder: (context, index) {
                  productCompositionPresenter.viewportHeight =
                      MediaQuery.of(context).size.height;

                  if (index + 1 ==
                      widget.selectedProduct.childsComposition!.length + 1) {
                    return FatherItem(
                      scrollController: widget.scrollController,
                      indexOfSelectedFather: index,
                      selectedProduct: widget.selectedProduct,
                      father: null,
                      itemColor: getItemColor(index, context),
                    );
                  }

                  final father =
                      widget.selectedProduct.childsComposition![index];

                  return FatherItem(
                    scrollController: widget.scrollController,
                    father: father,
                    indexOfSelectedFather: index,
                    selectedProduct: widget.selectedProduct,
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
                      widget.selectedProduct.childsComposition!);
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
