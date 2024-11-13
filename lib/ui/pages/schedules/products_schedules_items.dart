import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../pages.dart';

class ProductsSchedulesItems extends StatefulWidget {
  final List<ProductsViewModel> products;
  const ProductsSchedulesItems({
    required this.products,
    super.key,
  });

  @override
  State<ProductsSchedulesItems> createState() => _ProductsSchedulesItemsState();
}

class _ProductsSchedulesItemsState extends State<ProductsSchedulesItems> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.products.length,
      itemBuilder: (context, productIndex) {
        final product = widget.products[productIndex];
        return InkWell(
          onTap: () {
            PersonalizedDialogPage.open(
              context: context,
              page: EnableOrDisableDays(product: product),
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
                  ScheduleEnabledDays(
                    allowMonday: product.Schedule?.AllowMonday != false,
                    alloTuesday: product.Schedule?.AlloTuesday != false,
                    allowWednesday: product.Schedule?.AllowWednesday != false,
                    allowThursday: product.Schedule?.AllowThursday != false,
                    allowFriday: product.Schedule?.AllowFriday != false,
                    allowSaturday: product.Schedule?.AllowSaturday != false,
                    allowSunday: product.Schedule?.AllowSunday != false,
                  ),
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
