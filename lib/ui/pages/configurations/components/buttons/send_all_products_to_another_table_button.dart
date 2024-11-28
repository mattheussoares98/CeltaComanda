import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SendAllProductsToAnotherTableButton extends StatelessWidget {
  const SendAllProductsToAnotherTableButton({super.key});

  @override
  Widget build(BuildContext context) {
    return defaultButton(
        context: context,
        name: R.string.sendAllProductsToAnotherTable,
        function: () {
          notificationDialog(
              context: context,
              titleMessage: R.string.sendAllProductsToAnotherTable,
              showCancelAndConfirmMessage: false,
              showCloseAction: true,
              showLargeDialog: true,
              content: SizedBox(
                child: ChangeSaleRequestPersonalizedCodePage(),
              ),
              onPress: () async {});
        });
  }
}
