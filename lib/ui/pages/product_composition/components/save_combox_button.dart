import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class SaveComboxButton extends StatelessWidget {
  final List<ProductCompositionViewModel> productsCompositions;
  final ProductsViewModel product;
  const SaveComboxButton({
    required this.productsCompositions,
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    return StreamBuilder<double>(
        stream: productCompositionPresenter.totalPriceComboxStream,
        builder: (context, priceSnapshot) {
          Future.delayed(Duration.zero, () {
            productCompositionPresenter
                .updateTotalLiquidCombox(productsCompositions);
          });

          return StreamBuilder<bool>(
              stream: productCompositionPresenter.comboxIsValidStream,
              builder: (context, isValidComboxSnapshot) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    maximumSize: const Size(double.infinity, 45),
                    backgroundColor: isValidComboxSnapshot.data == true
                        ? Theme.of(context).primaryColorDark
                        : Theme.of(context).primaryColorLight.withAlpha(1),
                  ),
                  onPressed: () async {
                    try {
                      productCompositionPresenter
                          .certifyComboxIsValid(productsCompositions);

                      notificationDialog(
                        context: context,
                        titleMessage: "Salvar combo?",
                        cancelMessage: "Cancelar",
                        confirmMessage: "Confirmar",
                        content: ComboxSummaryNotification(
                          fatherName: product.Name,
                          productsCompositions: productsCompositions,
                          totalPrice: priceSnapshot.data!,
                        ),
                        onPress: () async {
                          bool updatedCombox =
                              await cartPresenter.addConfirmedCombox(
                            selectedChilds: productsCompositions,
                            totalPrice: priceSnapshot.data!,
                            father: product,
                            quantity:
                                productCompositionPresenter.totalComboxQuantity,
                          );

                          if (updatedCombox) {
                            Future.delayed(Duration.zero, () {
                              Navigator.of(context).pop();
                              showAlertMessage(
                                  context, "Combo adicionado com sucesso");
                            });
                          }
                        },
                      );
                    } catch (e) {
                      e;
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FittedBox(
                        child: Text(
                          isValidComboxSnapshot.data == true
                              ? "Conferir produtos selecionados"
                              : "Selecione todos produtos obrigatórios",
                          style: const TextStyle(
                            fontSize: 50,
                          ),
                        ),
                      ),
                      if (priceSnapshot.hasData)
                        FittedBox(
                          child: Text(
                            priceSnapshot.data
                                .toString()
                                .toBrazilianNumber()
                                .addBrazilianCoin(),
                            style: const TextStyle(
                              fontSize: 50,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              });
        });
  }
}
