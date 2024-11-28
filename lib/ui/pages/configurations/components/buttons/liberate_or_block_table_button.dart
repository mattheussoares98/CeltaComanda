import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../components.dart';

class LiberateOrBlockTableButton extends StatelessWidget {
  const LiberateOrBlockTableButton({super.key});

  @override
  Widget build(BuildContext context) {
    return defaultButton(
        context: context,
        name: R.string.liberateOrBlockTable,
        function: () {
          notificationDialog(
              context: context,
              titleMessage: R.string.liberateOrBlockTable,
              showCancelAndConfirmMessage: false,
              showCloseAction: true,
              showLargeDialog: true,
              content: SizedBox(
                child: BlockOrLiberateCommandPage(),
              ),
              onPress: () async {});
        });
  }
}
