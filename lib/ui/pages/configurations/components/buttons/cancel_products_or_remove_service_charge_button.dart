import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class CancelProductsOrRemoveServiceChargeButton extends StatelessWidget {
  const CancelProductsOrRemoveServiceChargeButton({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return DefaultButton(
        name: R.string.cancelProductsOrRemoveServiceCharge,
        permissionName: PermissionName.cancelarItens,
        function: () async {
          await configurationsPresenter.goToCancelProductsPage();
        });
  }
}
