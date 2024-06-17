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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: confirmedCombox.products.length,
          itemBuilder: (context, index) {
            final combox = confirmedCombox.products[index];

            ProductCompositionViewModel product;
            if (combox.childs?.isNotEmpty == true) {
              product = combox.childs![combox.indexOfSelectedChild!];
            } else {
              product = combox;
            }

            return Column(
              children: [
                Text(product.ChildName!),
              ],
            );
          },
        ),
        Text(confirmedCombox.totalPrice.toString()),
      ],
    );
  }
}
