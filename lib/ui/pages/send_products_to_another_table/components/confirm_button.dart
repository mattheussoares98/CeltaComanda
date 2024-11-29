import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ConfirmButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final int? oldPersonalizedCode;
  final int? newPersonalizedCode;
  const ConfirmButton({
    required this.formKey,
    required this.oldPersonalizedCode,
    required this.newPersonalizedCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SendProductsToAnotherTablePresenter sendProductsToAnotherTablePresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: () async {
          bool? isValid = formKey.currentState?.validate();

          if (isValid == true) {
            notificationDialog(
                context: context,
                titleMessage: "Confirm send itens to another table?" + "",
                content: null,
                onPress: () async {
                  await sendProductsToAnotherTablePresenter
                      .sendProductsToAnotherTable(
                    oldPersonalizedCode: oldPersonalizedCode!,
                    newPersonalizedCode: newPersonalizedCode!,
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
