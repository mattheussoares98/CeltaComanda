import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class FathersItems extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfAtualOption;
  final List<InsertProductsViewModel> insertProductsViewModel;
  const FathersItems({
    required this.selectedProduct,
    required this.indexOfAtualOption,
    required this.insertProductsViewModel,
    super.key,
  });

  @override
  State<FathersItems> createState() => _FathersItemsState();
}

class _FathersItemsState extends State<FathersItems> {
  final _scrollController = ScrollController();

  Color getItemColor(int index, BuildContext context) {
    if (index < widget.indexOfAtualOption) {
      return Theme.of(context).primaryColorDark;
    } else if (index == widget.indexOfAtualOption) {
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
    final proportion = ((40 / 2) * widget.indexOfAtualOption) / viewportHeight;

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

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    return Container(
      height: widget.insertProductsViewModel.length * 42,
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        controller: _scrollController,
        itemExtent: 42,
        shrinkWrap: true,
        itemCount: widget.insertProductsViewModel.length,
        itemBuilder: (context, index) {
          if (index + 1 == widget.insertProductsViewModel.length) {
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
                    indexOfSelectedFather: widget.indexOfAtualOption,
                    atualIndex: index,
                    selectedProduct: widget.selectedProduct,
                    father: null,
                    itemColor: getItemColor(index, context),
                  );
                });
          }

          final father = widget.selectedProduct.childsComposition?[index];

          return FatherItem(
            father: father,
            indexOfSelectedFather: widget.indexOfAtualOption,
            atualIndex: index,
            selectedProduct: widget.selectedProduct,
            itemColor: getItemColor(index, context),
          );
        },
      ),
    );
  }
}
