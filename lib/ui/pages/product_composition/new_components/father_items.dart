import 'package:flutter/material.dart';

import '../../pages.dart';

class FathersItems extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfSelectedFather;
  final bool productHasComment;
  final Stream<bool> doScrollStream;
  const FathersItems({
    required this.selectedProduct,
    required this.indexOfSelectedFather,
    required this.productHasComment,
    required this.doScrollStream,
    super.key,
  });

  @override
  State<FathersItems> createState() => _FathersItemsState();
}

class _FathersItemsState extends State<FathersItems> {
  final _scrollController = ScrollController();

  Color getItemColor(int index, BuildContext context) {
    if (index <= widget.indexOfSelectedFather) {
      return Theme.of(context).primaryColorDark;
    } else {
      return Theme.of(context).primaryColor;
    }
  }

  void doScroll({
    required int index,
    required ScrollController scrollController,
    required double viewportHeight,
  }) {
    final proportion =
        ((40 / 2) * widget.indexOfSelectedFather) / viewportHeight;

    final double targetPosition = viewportHeight * proportion;

    final double scrollOffset =
        targetPosition.clamp(0.0, scrollController.position.maxScrollExtent);

    scrollController.animateTo(
      scrollOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  bool _doScrollExecuted = false;

  int getItemsCount() {
    if (widget.selectedProduct.childsComposition == null) {
      if (widget.productHasComment) {
        return 3;
      } else {
        return 2;
      }
    } else {
      return widget.selectedProduct.childsComposition!.length + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                itemCount: getItemsCount(),
                itemBuilder: (context, index) {
                  if (index + 1 == getItemsCount()) {
                    return StreamBuilder<bool>(
                        stream: widget.doScrollStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            // Verifique se a função ainda não foi chamada
                            if (!_doScrollExecuted) {
                              doScroll(
                                index: index,
                                scrollController: _scrollController,
                                viewportHeight:
                                    MediaQuery.of(context).size.height,
                              );
                              _doScrollExecuted = true;
                            }
                          } else {
                            // Se o valor da stream não for mais true, redefina a variável de controle
                            _doScrollExecuted = false;
                          }
                          return FatherItem(
                            indexOfSelectedFather: index,
                            selectedProduct: widget.selectedProduct,
                            father: null,
                            itemColor: getItemColor(index, context),
                          );
                        });
                  }

                  final father =
                      widget.selectedProduct.childsComposition![index];

                  return FatherItem(
                    father: father,
                    indexOfSelectedFather: index,
                    selectedProduct: widget.selectedProduct,
                    itemColor: getItemColor(index, context),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
