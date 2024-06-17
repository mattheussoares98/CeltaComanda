import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';

class ConfirmedComboxItem extends StatelessWidget {
  final ConfirmedComboxViewModel confirmedCombox;
  const ConfirmedComboxItem({
    required this.confirmedCombox,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(confirmedCombox.father.Name),
        Text(confirmedCombox.products[0].ChildName.toString()),
        Text(
          confirmedCombox.totalPrice.toString(),
        )
      ],
    );
  }
}
