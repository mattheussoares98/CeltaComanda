import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../presentation/presenters/presenters.dart';

class SaveSaleRequestButton extends StatelessWidget {
  const SaveSaleRequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color(0xFFE0E3E7),
          ),
        ),
      ),
      onPressed: () async {
        await saleRequestTempPresenter.finishSaleRequest(
          saleRequestTempEntity:
              saleRequestTempPresenter.saleRequestTemp!.toEntity(),
        );
      },
      child: const Text(
        'Salvar/imprimir produtos',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
