import '../../../../domain/entities/entities.dart';
import '../../../helpers/helpers.dart';
import '../enterprise_validation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterpriseValidateButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CommandEntity commandEntity;
  const EnterpriseValidateButton({
    required this.formKey,
    required this.commandEntity,
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
                    if (!commandEntity.isFixedCommandNumber) {
                      await presenter.getEnterpriseAndValidateApiIsAvailable(
                        commandEntity: commandEntity,
                      );
                    }

                    if (formKey.currentState == null ||
                        !formKey.currentState!.validate()) {
                      return;
                    }

                    await presenter.getEnterpriseAndValidateApiIsAvailable(
                      commandEntity: commandEntity,
                    );
                  },
            child: Text(R.string.validateEnterprise.toUpperCase()),
          );
        });
  }
}
