import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class GoToCancelProductsPageButton extends StatelessWidget {
  const GoToCancelProductsPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        await configurationsPresenter.goToCancelProductsPage();
      },
      child: Text(R.string.cancelProducts),
    );
  }
}
