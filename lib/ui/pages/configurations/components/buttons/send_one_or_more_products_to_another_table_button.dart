import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SendOneOrMoreProductsToAnotherTableButton extends StatelessWidget {
  const SendOneOrMoreProductsToAnotherTableButton({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return defaultButton(
      context: context,
      name: R.string.sendOneOrMoreProductsToAnotherTable,
      function: () async {
        configurationsPresenter.goToSendProductsToAnotherTablePage();
      },
    );
  }
}
