import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class ConfirmUpdateCommandDataButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const ConfirmUpdateCommandDataButton({
    required this.formKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();

          if (formKey.currentState?.validate() != true) {
            return;
          }

          final updated = await configurationsPresenter.updateCommandData(
            newFixedCommandNumber: configurationsPresenter.selectedCommand ??
                homePresenter.commandNumber!.toInt(),
            printedProductsPresenter: printedProductsPresenter,
            peoples: configurationsPresenter.selectedPeoples,
            sellerCode:
                configurationsPresenter.selectedSeller?.PersonalizedCode,
            homePresenter: homePresenter,
          );

          if (updated) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              Navigator.of(context).pop();
              FocusScope.of(context).unfocus();
              snackBarMessage(
                context,
                R.string.msgUpdatedTableConfigurationsSuccess,
              );
            });
          }
        },
        child: Text(
          R.string.confirm,
        ),
      ),
    );
  }
}
