import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class ProductsSchedulesItems extends StatelessWidget {
  final List<ProductsViewModel> products;
  const ProductsSchedulesItems({
    required this.products,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, productIndex) {
        final product = products[productIndex];
        return InkWell(
          onTap: () {
            notificationDialog(
              context: context,
              titleMessage: R.string.productsSchedules,
              cancelMessage: R.string.cancel,
              confirmMessage: R.string.confirm,
              content: Column(
                children: [
                  Text(product.Name),
                ],
              ),
              onPress: () async {},
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            color: productIndex % 2 == 0
                ? Theme.of(context).primaryColorLight.withAlpha(50)
                : Colors.white,
            child: GestureDetector(
              child: Row(
                children: [
                  Expanded(child: Text(product.Name)),
                  ProductScheduleEnabledDays(productSchedule: product.Schedule),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
