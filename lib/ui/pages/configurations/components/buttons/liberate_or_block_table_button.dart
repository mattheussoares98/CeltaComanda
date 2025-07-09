import 'package:flutter/material.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../components.dart';

class LiberateOrBlockTableButton extends StatelessWidget {
  const LiberateOrBlockTableButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultButton(
        name: R.string.liberateOrBlockTable,
        permissionName: Permissions.liberarBloquearMesa,
        function: () {
          notificationDialog(
              context: context,
              titleMessage: R.string.liberateOrBlockTable,
              showCancelAndConfirmMessage: false,
              showCloseAction: true,
              showLargeDialog: true,
              content: const SizedBox(
                child: BlockOrLiberateCommandPage(),
              ),
              onPress: () async {});
        });
  }
}
