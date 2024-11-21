import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

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
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          color: productIndex % 2 == 0
              ? Theme.of(context).primaryColorLight.withAlpha(30)
              : Colors.white,
          child: Column(
            children: [
              InkWell(
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
                child: Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Text(
                          product.Name,
                          style: TextStyle(
                            fontSize: getStringSize(context),
                          ),
                        ),
                        if (product.childsComposition != null &&
                            product.childsComposition!.isNotEmpty)
                          Text(
                            "  (${R.string.combox})",
                            style: TextStyle(
                              fontSize: getStringSize(context),
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                      ],
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
              if (product.childsComposition != null &&
                  product.childsComposition!.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: product.childsComposition!.length,
                  itemBuilder: (context, fatherIndex) {
                    final father = product.childsComposition![fatherIndex];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(father.ChildName! + " (FATHER)"),
                        if (father.childs != null && father.childs!.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: father.childs!.length,
                            itemBuilder: (context, childIndex) {
                              final child = father.childs![childIndex];
                              return Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text("- ${child.ChildName!}"),
                              );
                            },
                          ),
                      ],
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
