import 'package:flutter/material.dart';

class LiquidateSaleRequest extends StatelessWidget {
  const LiquidateSaleRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () async {},
          child: const Text("Liquidar pedido"),
        ),
        const Text(
            "Essa comanda foi paga mas deu erro pra finalizar o pedido dela. Clique no botão para tentar finalizar novamente"),
      ],
    );
  }
}
