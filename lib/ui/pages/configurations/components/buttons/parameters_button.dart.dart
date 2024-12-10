import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class ParametersButton extends StatelessWidget {
  const ParametersButton({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return defaultButton(
      context: context,
      isNew: true,
      name: R.string.parameters,
      function: configurationsPresenter.goToParametersPage,
    );
  }
}
