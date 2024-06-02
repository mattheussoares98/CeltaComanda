import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class SaleRequestProductsItems extends StatelessWidget {
  final List<CartProductsViewModel> cartProducts;
  const SaleRequestProductsItems({
    required this.cartProducts,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SaleRequestTempPresenter saleRequestTempPresenter = Provider.of(context);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2))
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    final cartProduct = cartProducts[index];

                    return SaleRequestTempProductItem(
                      cartProduct: cartProduct,
                      index: index,
                    );
                  },
                ),
                RequestSummary(
                  totalLiquid:
                      saleRequestTempPresenter.totalSaleRequestTempPrice,
                  comments:
                      "Agora eu posso adicionar um comentário qualquer aqui, por exemplo o número da mesa pra ficar mais fácil pro cliente. Aí eu deixo ele adicionar somente comentário no produto",
                ),
              ],
            ),
          ),
        ),
        if (saleRequestTempPresenter.cartProducts.isNotEmpty)
          const SaveSaleRequestButton(),
      ],
    );
  }
}
