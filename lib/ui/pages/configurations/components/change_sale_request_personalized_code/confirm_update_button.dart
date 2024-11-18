// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class ConfirmUpdateButton extends StatelessWidget {
  final int? oldPersonalizedCode;
  final int? newPersonalizedCode;
  final GlobalKey<FormState> formKey;
  const ConfirmUpdateButton({
    required this.oldPersonalizedCode,
    required this.newPersonalizedCode,
    required this.formKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        bool? isValid = formKey.currentState?.validate();

        if (isValid == true) {
          final updated =
              await configurationsPresenter.updateSaleRequestPersonalizedCode(
            oldPersonalizedCode: oldPersonalizedCode!,
            newPersonalizedCode: newPersonalizedCode!,
          );

          if (updated) {
            Navigator.of(context).pop();
            snackBarMessage(
              context,
              R.string.msgSuccessToUpdateCommandNumberProducts,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
            );
          }
        }
      },
      child: Text(R.string.confirm),
    );
  }
}
