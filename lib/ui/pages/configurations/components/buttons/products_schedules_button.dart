import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class ProductsSchedulesButton extends StatelessWidget {
  const ProductsSchedulesButton({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return DefaultButton(
        name: R.string.productsSchedules,
        permissionName: PermissionName.agendamentoDeProdutos,
        function: () async {
          await configurationsPresenter.goToSchedulesPage();
        });
  }
}
