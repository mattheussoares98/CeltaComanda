import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../ui/pages/pages.dart';
import '../../../../components/components.dart';

class ImageFathernameAndPrice extends StatelessWidget {
  final ConfirmedComboxViewModel confirmedCombox;
  final int confirmedComboxIndex;
  const ImageFathernameAndPrice({
    required this.confirmedCombox,
    required this.confirmedComboxIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageWidget(
          ean: confirmedCombox.father.EanCode,
          plu: confirmedCombox.father.PriceLookupCode,
          productComplement: null,
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
          totalLiquid: confirmedCombox.quantity * confirmedCombox.totalPrice,
          onPressedReduceQuantity: () async {
            if (cartPresenter.confirmedCombox[confirmedComboxIndex].quantity <=
                1) {
              notificationDialog(
                context: context,
                titleMessage: "Remover combo do carrinho?",
                content: null,
                onPress: () async {
                  await cartPresenter
                      .reduceComboxQuantity(confirmedComboxIndex);
                },
              );
            } else {
              await cartPresenter.reduceComboxQuantity(confirmedComboxIndex);
            }
          },
          onPressedAddQuantity: () async {
            await cartPresenter.addComboxQuantity(confirmedComboxIndex);
          },
          productQuantity: confirmedCombox.quantity,
        ),
      ],
    );
  }
}
