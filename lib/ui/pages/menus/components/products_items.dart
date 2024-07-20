import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ProductsItems extends StatefulWidget {
  final List<ProductsViewModel> products;
  final ProductsViewModel? selectedProduct;
  const ProductsItems({
    required this.products,
    required this.selectedProduct,
    super.key,
  });

  @override
  State<ProductsItems> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  final _controller = ScrollController();
  Future<void> _scrollUp() async {
    final currentPosition = _controller.position.pixels;
    final minScrollExtent = _controller.position.minScrollExtent;

    if (currentPosition >= minScrollExtent) {
      await _controller.animateTo(
        _controller.position.minScrollExtent,
        duration: Duration(milliseconds: widget.products.length * 10),
        curve: Curves.linear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      await _scrollUp();
    });
    final itensPerLine = hasMinWidth(context)
        ? 1
        : 2; //no eatAsia pediram pra colocar somente 1 produto por linha, 2 por página. Como somente o tablet vai ter a largura mínima, é tranquilo exibir somente 1 produto por linha nesse caso

    return ListView.builder(
      controller: _controller,
      itemCount: (widget.products.length / itensPerLine).ceil(),
      itemBuilder: (context, rowIndex) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //essa lógica doida foi o chatGPT que gerou. Usando um gridView não estava dando certo
              for (int i = rowIndex * itensPerLine;
                  i < (rowIndex + 1) * itensPerLine;
                  i++)
                if (i < widget.products.length)
                  ProductItem(
                    productsViewModel: widget.products[i],
                    productIsSelected:
                        widget.products[i] == widget.selectedProduct,
                  ),
            ],
          ),
        );
      },
    );
  }
}
