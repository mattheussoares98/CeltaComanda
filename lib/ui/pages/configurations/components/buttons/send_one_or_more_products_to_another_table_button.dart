import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SendOneOrMoreProductsToAnotherTableButton extends StatelessWidget {
  const SendOneOrMoreProductsToAnotherTableButton({super.key});

  @override
  Widget build(BuildContext context) {
    return defaultButton(
      context: context,
      name: R.string.sendOneOrMoreProductsToAnotherTable,
      function: () async {},
    );
  }
}
