import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class OptionItems extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int insertProductIndex;
  final List<InsertProductsViewModel> insertProductsViewModel;
  const OptionItems({
    required this.selectedProduct,
    required this.insertProductIndex,
    required this.insertProductsViewModel,
    super.key,
  });

  @override
  State<OptionItems> createState() => _OptionItemsState();
}

class _OptionItemsState extends State<OptionItems> {
  final _scrollController = ScrollController();

  Color getItemColor(int index, BuildContext context) {
    if (index < widget.insertProductIndex) {
      return Theme.of(context).primaryColorDark;
    } else if (index == widget.insertProductIndex) {
      return Theme.of(context).secondaryHeaderColor;
    } else {
      return Theme.of(context).primaryColor;
    }
  }

  void doScroll({
    required ScrollController scrollController,
    required double itemExtent,
  }) {
    if (!scrollController.hasClients) {
      return;
    }
    final target = itemExtent * (widget.insertProductIndex - 0.33);

    scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
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
    final double itemExtent = hasMinWidth(context) ? 82 : 42;

    return Container(
      height: widget.insertProductsViewModel.length * itemExtent,
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        controller: _scrollController,
        itemExtent: itemExtent,
        shrinkWrap: true,
        itemCount: widget.insertProductsViewModel.length,
        itemBuilder: (context, optionIndex) {
          final insertProductViewModel =
              widget.insertProductsViewModel[optionIndex];

          return StreamBuilder<bool>(
              stream: insertProductPresenter.doScrollStream,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  if (!_doScrollExecuted) {
                    doScroll(
                      itemExtent: itemExtent,
                      scrollController: _scrollController,
                    );
                    _doScrollExecuted = true;
                  }
                } else {
                  // Se o valor da stream não for mais true, redefina a variável de controle
                  _doScrollExecuted = false;
                }
                return OptionItem(
                  insertProductViewModel: insertProductViewModel,
                  optionIndex: optionIndex,
                  insertProductIndex: widget.insertProductIndex,
                  lastSelectedFather:
                      insertProductPresenter.getLastSelectedFather(optionIndex),
                  itemExtent: itemExtent,
                );
              });
        },
      ),
    );
  }
}
