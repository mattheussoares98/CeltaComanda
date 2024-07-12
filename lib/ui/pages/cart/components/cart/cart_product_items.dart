import 'package:flutter/material.dart';

import '../../../pages.dart';

class CartProductsItems extends StatelessWidget {
  final List<CartProductsViewModel> cartProducts;
  final int itensPerLine;
  const CartProductsItems({
    required this.cartProducts,
    required this.itensPerLine,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: (cartProducts.length / itensPerLine).ceil(),
      itemBuilder: (context, rowIndex) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //essa lógica doida foi o chatGPT que gerou. Usando um gridView não estava dando certo
              for (int i = rowIndex * itensPerLine;
                  i < (rowIndex + 1) * itensPerLine;
                  i++)
                if (i < cartProducts.length)
                  CartProductItem(
                    cartProduct: cartProducts[i],
                    index: i,
                  ),
            ],
          ),
        );
      },
    );
  }
}
