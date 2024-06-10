import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class SaveSaleRequestButton extends StatelessWidget {
  const SaveSaleRequestButton({super.key});

  static _addProducts({
    required CartPresenter cartPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required String commandNumber,
    required BuildContext context,
  }) async {
    bool isUpdated = await cartPresenter.saveProducts(
      printedProductsPresenter,
    );

    if (isUpdated) {
      Future.delayed(Duration.zero, () {
        showAlertMessage(
          context,
          "Os produtos foram inseridos na comanda com sucesso",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    TextEditingController commandNumberController = TextEditingController();

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ElevatedButton(
          onPressed: () async {
            await _addProducts(
              cartPresenter: cartPresenter,
              commandNumber: commandNumberController.text,
              context: context,
              printedProductsPresenter: printedProductsPresenter,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Confirmar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(cartPresenter.totalSaleRequestTempPrice),
            ],
          ),
        ),
      ),
    );
  }
}
