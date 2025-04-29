import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SendProductsToAnotherTableButton extends StatelessWidget {
  const SendProductsToAnotherTableButton({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return DefaultButton(
      name: R.string.sendAllProductsToAnotherTable,
      permissionName: Permissions.trocarProdutosEntreComandas,
      function: () async {
        configurationsPresenter.goToSendProductsToAnotherTablePage();
      },
    );
  }
}
