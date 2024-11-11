import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages.dart';
import '../../../../../ui/helpers/helpers.dart';

class ProductItem extends StatelessWidget {
  final PrintedProductsViewModel product;
  final int index;
  final int productFlex;
  final int totalFlex;
  final int quantityFlex;
  final int? commandNumber;
  final double deleteButtonSize;
  const ProductItem({
    required this.product,
    required this.index,
    required this.productFlex,
    required this.totalFlex,
    required this.quantityFlex,
    required this.commandNumber,
    required this.deleteButtonSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CancelProductsPresenter cancelProductsPresenter =
        Provider.of(context, listen: false);

    return Container(
      color: index % 2 == 1
          ? Theme.of(context).primaryColorLight.withAlpha(30)
          : Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: productFlex,
            child: Text(
              product.Products.Name,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: quantityFlex,
            child: Text(
              product.Products.productQuantity.toString().toBrazilianNumber(0),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: totalFlex,
            child: Column(
              children: [
                Text(
                  product.TotalLiquid,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(
            width: deleteButtonSize,
            height: deleteButtonSize,
            child: IconButton(
              onPressed: () async {
                notificationDialog(
                  context: context,
                  titleMessage: "${R.string.cancelProduct}?",
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.Products.Name,
                          style: TextStyle(
                            fontSize: getStringSize(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product.TotalLiquid.toDouble()
                              .toString()
                              .toBrazilianNumber()
                              .addBrazilianCoin(),
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: getStringSize(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPress: () async {
                    await cancelProductsPresenter.cancelProduct(
                        productId: product.SaleRequestProductId,
                        commandNumber: commandNumber!,
                        showSuccessMessage: () {
                          snackBarMessage(
                            context,
                            R.string.msgSuccessToCancelProducts,
                          );
                        });
                  },
                );
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
