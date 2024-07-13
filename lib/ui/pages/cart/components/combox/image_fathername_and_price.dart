import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../../ui/helpers/helpers.dart';
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
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showLargeImage(
                context: context,
                ean: confirmedCombox.father.EanCode,
                plu: confirmedCombox.father.PriceLookupCode,
                productComplement: confirmedCombox.father.ProductComplement,
                menuPresenter: menuPresenter,
                productName: confirmedCombox.father.Name,
              );
            },
            child: SizedBox(
              height: 70,
              width: 70,
              child: ImageWidget(
                ean: confirmedCombox.father.EanCode,
                plu: confirmedCombox.father.PriceLookupCode,
                height: 70,
                width: 70,
                isAlcoholic: false,
              ),
            ),
          ),
        ),
        const SizedBox(width: 3),
        Expanded(
          flex: 2,
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "(COMBO) ",
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontStyle: FontStyle.italic,
                    fontSize: getStringSize(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: confirmedCombox.father.Name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getStringSize(context),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 3),
        Expanded(
          child: PriceAndUpdateProductQuantity(
            showItemPrice: false,
            showDeleteIcon: confirmedCombox.quantity <= 1,
            showUpdateProductQuantity: true,
            price: confirmedCombox.totalPrice,
            totalLiquid: confirmedCombox.quantity * confirmedCombox.totalPrice,
            onPressedReduceQuantity: () async {
              if (cartPresenter
                      .confirmedCombox[confirmedComboxIndex].quantity <=
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
        ),
      ],
    );
  }
}
