import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import '../../../pages.dart';

class CartProductsItems extends StatelessWidget {
  final List<CartProductsViewModel> cartProducts;
  const CartProductsItems({
    required this.cartProducts,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: (cartProducts.length / getItensPerLine(context)).ceil(),
        itemBuilder: (context, rowIndex) {
          return IntrinsicHeight(
            child: Row(
              children: [
                //essa lógica doida foi o chatGPT que gerou. Usando um gridView não estava dando certo
                for (int i = rowIndex * getItensPerLine(context);
                    i < (rowIndex + 1) * getItensPerLine(context);
                    i++)
                  if (i < cartProducts.length)
                    CartProductItem(
                      cartProduct: cartProducts[i],
                      index: i,
                      maxWidth: constraints.maxWidth,
                    ),
              ],
            ),
          );
        },
      );
    });
  }
}
