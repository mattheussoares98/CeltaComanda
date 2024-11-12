import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class GoToBlockOrLiberateCommandPageButton extends StatelessWidget {
  const GoToBlockOrLiberateCommandPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () {
        configurationsPresenter.goToBlockOrLiberateCommandPage();
      },
      child: FittedBox(
        child: Text(
          R.string.liberateOrBlockTable,
        ),
      ),
    );
  }
}
