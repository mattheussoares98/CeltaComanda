import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/helpers.dart';
import '../../../../pages.dart';

class UpdateConfigurationsButton extends StatelessWidget {
  final Future<void> Function(HomePresenter, PrintedProductsPresenter)
      updateCommand;
  const UpdateConfigurationsButton({
    required this.updateCommand,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        await updateCommand(homePresenter, printedProductsPresenter);
      },
      child: FittedBox(
        child: Padding(
          padding: EdgeInsets.all(hasMinWidth(context) ? 8.0 : 0),
          child: Text(
            R.string.updateConfigurations,
            style: TextStyle(
              fontSize: getStringSize(context),
            ),
          ),
        ),
      ),
    );
  }
}
