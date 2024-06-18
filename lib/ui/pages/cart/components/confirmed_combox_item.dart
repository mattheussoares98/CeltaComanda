import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/pages.dart';
import '../../../components/components.dart';

class ConfirmedComboxItem extends StatelessWidget {
  final ConfirmedComboxViewModel confirmedCombox;
  final int index;
  const ConfirmedComboxItem({
    required this.confirmedCombox,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    void onPressedAddQuantity({
      required CartPresenter cartPresenter,
    }) {
      cartPresenter.addCartProductQuantity(index);
    }

    void onPressedReduceQuantity({
      required CartPresenter cartPresenter,
    }) {
      if (confirmedCombox.quantity <= 1) {
        notificationDialog(
          context: context,
          titleMessage: "Remover produto do carrinho?",
          content: null,
          onPress: () async {
            cartPresenter.reduceCartProductQuantity(index);
          },
        );
      } else {
        cartPresenter.reduceCartProductQuantity(index);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageWidget(
              ean: confirmedCombox.father.EanCode,
              plu: confirmedCombox.father.PriceLookupCode,
              showLargeImageInShowDialog: true,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                confirmedCombox.father.Name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            PriceAndUpdateProductQuantity(
              showDeleteIcon: confirmedCombox.quantity <= 1,
              showUpdateProductQuantity: true,
              price: confirmedCombox.totalPrice,
              totalLiquid:
                  confirmedCombox.quantity * confirmedCombox.totalPrice,
              onPressedReduceQuantity: () {
                onPressedReduceQuantity(
                  cartPresenter: cartPresenter,
                );
              },
              onPressedAddQuantity: () {
                onPressedAddQuantity(
                  cartPresenter: cartPresenter,
                );
              },
              productQuantity: confirmedCombox.quantity,
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: confirmedCombox.products.length,
          itemBuilder: (context, index) {
            final combox = confirmedCombox.products[index];

            ProductCompositionViewModel product;
            if (combox.childs?.isNotEmpty == true) {
              product = combox.childs![combox.indexOfSelectedChild!];
            } else {
              product = combox;
            }

            return Column(
              children: [
                Text(product.ChildName!),
                Text((productCompositionPresenter.calculateTotalLiquid(
                            product: combox,
                            itemPrice: productCompositionPresenter
                                .calculateProductPrice(combox)) *
                        combox.Quantity.toString().toDouble())
                    .toString()),
                Text(combox.Quantity.toString())
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        const Divider(
          thickness: 0.2,
        )
      ],
    );
  }
}
