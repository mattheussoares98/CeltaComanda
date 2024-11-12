import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class OpenBlockOrLiberateCommandPageButton extends StatelessWidget {
  const OpenBlockOrLiberateCommandPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
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
      },
      child: FittedBox(
        child: Text(
          R.string.liberateOrBlockTable,
        ),
      ),
    );
  }
}
