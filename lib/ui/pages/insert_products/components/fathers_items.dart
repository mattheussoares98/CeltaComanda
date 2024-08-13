import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class FathersItems extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfSelectedFather;
  final bool showComments;
  final bool productHasComments;
  final bool productHasObligatoryOptions;
  const FathersItems({
    required this.selectedProduct,
    required this.indexOfSelectedFather,
    required this.showComments,
    required this.productHasComments,
    required this.productHasObligatoryOptions,
    super.key,
  });

  @override
  State<FathersItems> createState() => _FathersItemsState();
}

class _FathersItemsState extends State<FathersItems> {
  final _scrollController = ScrollController();

  Color getItemColor(int index, BuildContext context) {
    if (index < widget.indexOfSelectedFather) {
      return Theme.of(context).primaryColorDark;
    } else if (index == widget.indexOfSelectedFather) {
      return Theme.of(context).secondaryHeaderColor;
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
      if (widget.productHasComments && widget.productHasObligatoryOptions) {
        return 3;
      } else if (widget.productHasComments) {
        return 2;
      } else if (widget.productHasObligatoryOptions) {
        return 2;
      } else {
        return 1;
      }
    } else {
      return widget.selectedProduct.childsComposition!.length + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    return Container(
      height: getItemsCount() * 42,
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        controller: _scrollController,
        itemExtent: 42,
        shrinkWrap: true,
        itemCount: getItemsCount(),
        itemBuilder: (context, index) {
          if (index + 1 == getItemsCount()) {
            return StreamBuilder<bool>(
                stream: insertProductPresenter.doScrollStream,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    // Verifique se a função ainda não foi chamada
                    if (!_doScrollExecuted) {
                      doScroll(
                        index: index,
                        scrollController: _scrollController,
                        viewportHeight: MediaQuery.of(context).size.height,
                      );
                      _doScrollExecuted = true;
                    }
                  } else {
                    // Se o valor da stream não for mais true, redefina a variável de controle
                    _doScrollExecuted = false;
                  }
                  return FatherItem(
                    indexOfLeftSelectedItem: index,
                    selectedProduct: widget.selectedProduct,
                    father: null,
                    itemColor: getItemColor(index, context),
                    showComments: widget.showComments &&
                        index == widget.indexOfSelectedFather,
                  );
                });
          }

          final father = widget.selectedProduct.childsComposition?[index];

          return FatherItem(
            father: father,
            indexOfLeftSelectedItem: index,
            selectedProduct: widget.selectedProduct,
            itemColor: getItemColor(index, context),
            showComments:
                widget.showComments && index == widget.indexOfSelectedFather,
          );
        },
      ),
    );
  }
}
