import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ConfirmButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController originCommandNumberController;
  final TextEditingController destinyCommandNumberController;
  const ConfirmButton({
    required this.formKey,
    required this.originCommandNumberController,
    required this.destinyCommandNumberController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SendProductsToAnotherTablePresenter sendProductsToAnotherTablePresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        bool? isValid = formKey.currentState?.validate();

        if (isValid == true) {
          notificationDialog(
              context: context,
              titleMessage: R.string.msgConfirmSendProducts,
              content: null,
              onPress: () async {
                await sendProductsToAnotherTablePresenter
                    .sendProductsToAnotherTable(
                  oldPersonalizedCode:
                      originCommandNumberController.text.toInt(),
                  newPersonalizedCode:
                      destinyCommandNumberController.text.toInt(),
                  cartPresenter: cartPresenter,
                  homePresenter: homePresenter,
                );
              });
        }
      },
      child: Text(R.string.sendAllProducts),
    );
  }
}
