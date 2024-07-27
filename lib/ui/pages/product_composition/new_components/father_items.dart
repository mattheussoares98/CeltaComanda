import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class FathersItems extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfSelectedFather;
  const FathersItems({
    required this.selectedProduct,
    required this.indexOfSelectedFather,
    super.key,
  });

  @override
  State<FathersItems> createState() => _FathersItemsState();
}

class _FathersItemsState extends State<FathersItems> {
  final ScrollController _scrollController = ScrollController();

  Color getItemColor(int index, BuildContext context) {
    if (index <= widget.indexOfSelectedFather) {
      return Theme.of(context).primaryColorDark;
    } else {
      return Theme.of(context).primaryColor;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _scrollToIndex(int index) {
    final double viewportHeight = MediaQuery.of(context).size.height;

    final proportion = ((42 / 2) * index) / viewportHeight;

    final double targetPosition = viewportHeight * proportion;

    final double scrollOffset =
        targetPosition.clamp(0.0, _scrollController.position.maxScrollExtent);

    _scrollController.animateTo(
      scrollOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
                controller: _scrollController,
                itemExtent: 42,
                shrinkWrap: true,
                itemCount: widget.selectedProduct.childsComposition!.length + 1,
                itemBuilder: (context, index) {
                  if (index + 1 ==
                      widget.selectedProduct.childsComposition!.length + 1) {
                    return FatherItem(
                      scrollToIndex: () {
                        _scrollToIndex(index);
                      },
                      indexOfSelectedFather: index,
                      selectedProduct: widget.selectedProduct,
                      father: null,
                      itemColor: getItemColor(index, context),
                    );
                  }

                  final father =
                      widget.selectedProduct.childsComposition![index];

                  return FatherItem(
                    scrollToIndex: () {
                      _scrollToIndex(index);
                    },
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
