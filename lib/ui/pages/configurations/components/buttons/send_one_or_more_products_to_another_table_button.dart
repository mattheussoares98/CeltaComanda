import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SendOneOrMoreProductsToAnotherTableButton extends StatelessWidget {
  const SendOneOrMoreProductsToAnotherTableButton({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return DefaultButton(
      name: R.string.sendOneOrMoreProductsToAnotherTable,
      permissionName: PermissionName.trocarProdutosEntreComandas,
      function: () async {
        configurationsPresenter.goToSendProductsToAnotherTablePage();
      },
    );
  }
}
