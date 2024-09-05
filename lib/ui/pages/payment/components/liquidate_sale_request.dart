import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class LiquidateSaleRequest extends StatelessWidget {
  const LiquidateSaleRequest({super.key});

  @override
  Widget build(BuildContext context) {
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Column(
      children: [
        Text(
          "Essa comanda foi paga mas deu erro pra finalizar o pedido dela. Clique no botão para tentar finalizar novamente",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: getStringSize(context),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            await paymentPresenter.tryPayAgain(
              homePresenter.commandNumber!.toInt(),
            );
          },
          child: Text(
            "Liquidar pedido",
            style: TextStyle(
              fontSize: getStringSize(context) * 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
