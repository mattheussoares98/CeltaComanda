import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class CloseCommandButton extends StatefulWidget {
  const CloseCommandButton({super.key});

  @override
  State<CloseCommandButton> createState() => _CloseCommandButtonState();
}

class _CloseCommandButtonState extends State<CloseCommandButton> {
  int? selectedCommandInDropDown;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return defaultButton(
      context: context,
      name: R.string.close,
      function: () async {
        notificationDialog(
            context: context,
            titleMessage: "R.string.confirmClose" + "",
            closeDialogOnConfirmPress: false,
            content: Form(
              key: formKey,
              child: SelectTableDropDown(
                selectedCommandInDropDown: selectedCommandInDropDown,
                updateSelectedCommandInDropDown: (value) {
                  setState(() {
                    selectedCommandInDropDown = value;
                  });
                },
                hintText: R.string.msgSelectCommand,
                validator: (value) {
                  if (value == null) {
                    return R.string.msgSelectCommand;
                  }
                  return null;
                },
              ),
            ),
            onPress: () async {
              bool? isValid = formKey.currentState?.validate();

              if (isValid == true) {
                await configurationsPresenter
                    .closeCommand(selectedCommandInDropDown!);
              }
            });
      },
    );
  }
}
