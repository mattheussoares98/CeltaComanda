import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../data/models/models.dart';
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
  final int timeFlex;
  final PrintedViewModel printedVieModel;
  const ProductItem({
    required this.product,
    required this.index,
    required this.productFlex,
    required this.totalFlex,
    required this.quantityFlex,
    required this.commandNumber,
    required this.deleteButtonSize,
    required this.timeFlex,
    required this.printedVieModel,
    super.key,
  });

  Color getColor(BuildContext context) {
    if (product.IsCancelled == "true") {
      return Colors.red.withAlpha(250);
    } else if (index % 2 == 1) {
      return Theme.of(context).primaryColorLight.withAlpha(30);
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    CancelProductsPresenter cancelProductsPresenter =
        Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      color: getColor(context),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: timeFlex,
                child: RequestedAt(printedProduct: product),
              ),
              Expanded(
                flex: productFlex,
                child: ProductName(product: product),
              ),
              Expanded(
                flex: quantityFlex,
                child: Text(
                  product.Quantity.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: StringSize.size,
                  ),
                ),
              ),
              Expanded(
                flex: totalFlex,
                child: Column(
                  children: [
                    Text(
                      product.TotalLiquid!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: StringSize.size,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: deleteButtonSize,
                height: deleteButtonSize,
                child: IconButton(
                  onPressed: product.IsCancelled == "true"
                      ? null
                      : () async {
                          notificationDialog(
                            context: context,
                            titleMessage: "${R.string.cancelProduct}?",
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    product.Product!.Name,
                                    style: TextStyle(
                                      fontSize: StringSize.size,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    product.TotalLiquid!
                                        .toDouble()
                                        .toString()
                                        .toBrazilianNumber()
                                        .addBrazilianCoin(),
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: StringSize.size,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPress: () async {
                              await cancelProductsPresenter.newCancelProduct(
                                  UserIdOfCancellation: configurationsPresenter
                                      .loggedUser!.UserId!,
                                  printedModel: PrintedModel.fromViewModel(
                                    printedVieModel,
                                  ),
                                  cartPresenter: cartPresenter,
                                  homePresenter: homePresenter,
                                  product: product,
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
                    color: product.IsCancelled == "true"
                        ? Theme.of(context).primaryColorLight
                        : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          if (product.childs.isNotEmpty)
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: product.childs.length,
              itemBuilder: (context, index) {
                final child = product.childs[index];

                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: child.Product!.Name,
                          style: TextStyle(
                            fontSize: StringSize.size * 0.9,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          ),
                          children: child.Comments == null
                              ? []
                              : <TextSpan>[
                                  TextSpan(
                                    text: "   (${child.Comments})",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontStyle: FontStyle.italic,
                                      fontSize: StringSize.size * 0.9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
        ],
      ),
    );
  }
}
