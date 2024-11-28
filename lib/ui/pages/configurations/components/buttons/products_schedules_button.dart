import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class ProductsSchedulesButton extends StatelessWidget {
  const ProductsSchedulesButton({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return defaultButton(
        context: context,
        name: R.string.productsSchedules,
        function: () async {
          await configurationsPresenter.goToSchedulesPage();
        });
  }
}
