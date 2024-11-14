import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class ProductsSchedulesItems extends StatefulWidget {
  final List<ProductsViewModel> products;
  final ExpansibleGroupsViewModel expansibleGroup;
  final void Function() callSetState;
  const ProductsSchedulesItems({
    required this.products,
    required this.expansibleGroup,
    required this.callSetState,
    super.key,
  });

  @override
  State<ProductsSchedulesItems> createState() => _ProductsSchedulesItemsState();
}

class _ProductsSchedulesItemsState extends State<ProductsSchedulesItems> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.products.length,
      itemBuilder: (context, productIndex) {
        final product = widget.products[productIndex];
        return InkWell(
          onTap: () {
            PersonalizedDialogPage.open(
              context: context,
              page: EnableOrDisableDays(
                product: product,
                expansibleGroup: widget.expansibleGroup,
                isUpdatingProduct: true,
                callSetState: () {
                  widget.callSetState();
                },
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            color: productIndex % 2 == 0
                ? Theme.of(context).primaryColorLight.withAlpha(30)
                : Colors.white,
            child: GestureDetector(
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    product.Name,
                    style: TextStyle(
                      fontSize: getStringSize(context),
                    ),
                  )),
                  const SizedBox(width: 5),
                  ScheduleEnabledDays(
                    allowMonday: product.Schedule?.AllowMonday != false,
                    allowTuesday: product.Schedule?.AllowTuesday != false,
                    allowWednesday: product.Schedule?.AllowWednesday != false,
                    allowThursday: product.Schedule?.AllowThursday != false,
                    allowFriday: product.Schedule?.AllowFriday != false,
                    allowSaturday: product.Schedule?.AllowSaturday != false,
                    allowSunday: product.Schedule?.AllowSunday != false,
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
