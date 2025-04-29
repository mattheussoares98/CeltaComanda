// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class CloseCommandButton extends StatefulWidget {
  const CloseCommandButton({super.key});

  @override
  State<CloseCommandButton> createState() => _CloseCommandButtonState();
}

class _CloseCommandButtonState extends State<CloseCommandButton> {
  final commandNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    commandNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return DefaultButton(
      name: R.string.closeTable,
      permissionName: Permissions.fecharMesa,
      function: () async {
        await notificationDialog(
            context: context,
            titleMessage: R.string.msgWantCloseTable,
            closeDialogOnConfirmPress: false,
            content: Form(
              key: formKey,
              child: CommandField(
                commandNumberController: commandNumberController,
              ),
            ),
            onPress: () async {
              bool? isValid = formKey.currentState?.validate();

              if (isValid == true) {
                bool confirmed = await configurationsPresenter
                    .closeCommand(commandNumberController.text.toInt());

                Navigator.of(context).pop();

                if (confirmed) {
                  snackBarMessage(context, R.string.msgTableClosedSuccessfully);
                }
              }
            });
        commandNumberController.text = "";
      },
    );
  }
}
