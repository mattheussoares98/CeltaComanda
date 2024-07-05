import '../../../helpers/helpers.dart';
import '../enterprise_validation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterpriseValidateButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool useFixedCommandNumber;
  const EnterpriseValidateButton({
    required this.formKey,
    required this.useFixedCommandNumber,
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
                : () {
                    if (!useFixedCommandNumber) {
                      presenter.validateApiSaleRequest();
                    }

                    if (formKey.currentState == null ||
                        !formKey.currentState!.validate()) {
                      return;
                    }

                    presenter.validateApiSaleRequest();
                  },
            child: Text(R.string.validateEnterprise.toUpperCase()),
          );
        });
  }
}
