import '../../../helpers/helpers.dart';
import '../enterprise_validation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterpriseValidateButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CommandViewModel commandViewModel;
  const EnterpriseValidateButton({
    required this.formKey,
    required this.commandViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<EnterpriseValidationPresenter>(context);
    return StreamBuilder<bool>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.data == false
                ? null
                : () async {
                    if (commandViewModel.isFixedCommandNumber != "true") {
                      await presenter.getEnterpriseAndValidateApiIsAvailable(
                        commandEntity: commandViewModel.toEntity(),
                      );
                    }

                    if (formKey.currentState == null ||
                        !formKey.currentState!.validate()) {
                      return;
                    }

                    await presenter.getEnterpriseAndValidateApiIsAvailable(
                      commandEntity: commandViewModel.toEntity(),
                    );
                  },
            child: Text(R.string.validateEnterprise.toUpperCase()),
          );
        });
  }
}
