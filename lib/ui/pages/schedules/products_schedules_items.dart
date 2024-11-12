import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
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
  bool? allowMonday = true;
  bool? allowTuesday = true;
  bool? allowWednesday = true;
  bool? allowThursday = true;
  bool? allowFriday = true;
  bool? allowSunday = true;
  bool? allowSaturday = true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.products.length,
      itemBuilder: (context, productIndex) {
        final product = widget.products[productIndex];
        return InkWell(
          onTap: () {
            setState(() {
              allowMonday = product.Schedule?.AllowMonday != false;
              allowTuesday = product.Schedule?.AlloTuesday != false;
              allowWednesday = product.Schedule?.AllowWednesday != false;
              allowThursday = product.Schedule?.AllowThursday != false;
              allowFriday = product.Schedule?.AllowFriday != false;
              allowSunday = product.Schedule?.AllowSunday != false;
              allowSaturday = product.Schedule?.AllowSaturday != false;
            });

            notificationDialog(
              context: context,
              titleMessage: R.string.productsSchedules,
              cancelMessage: R.string.cancel,
              confirmMessage: R.string.confirm,
              content: Scaffold(
                body: Column(
                  children: [
                    Text(product.Name),
                    CheckboxListTile(
                      dense: true,
                      title: Text("Mon" + "day"),
                      value: allowMonday,
                      onChanged: (value) {
                        setState(() {
                          allowMonday = value;
                        });
                      },
                    ),
                  ],
                ),
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
