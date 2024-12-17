import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class BlockOrLiberateButton extends StatelessWidget {
  final TextEditingController commandNumberController;
  final GlobalKey<FormState> formKey;
  final bool isLiberating;
  const BlockOrLiberateButton({
    required this.commandNumberController,
    required this.formKey,
    required this.isLiberating,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        bool? isValid = formKey.currentState?.validate();

        if (isValid != true) {
          return;
        }

        final updated = await configurationsPresenter.openOrBlockadeCommand(
          commandNumber: commandNumberController.text.toInt(),
          isOpen: isLiberating,
        );

        if (updated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            FocusScope.of(context).unfocus();
            snackBarMessage(
              context,
              isLiberating
                  ? R.string.msgReleasesCommand
                  : R.string.msgBlockedCommand,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
            );
          });
        }
      },
      child: Text(
        isLiberating ? R.string.liberateTable : R.string.blockTable,
      ),
    );
  }
}
