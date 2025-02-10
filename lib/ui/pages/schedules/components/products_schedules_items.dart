import 'package:flutter/material.dart';

import '../../../../main/builders/builders.dart';
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
        final color = productIndex % 2 == 0 ? Colors.grey[300] : Colors.white;

        return Container(
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.5,
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(10),
            color: color!,
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  PersonalizedDialogPage.open(
                    context: context,
                    page: EnableOrDisableDays(
                      product: product,
                      expansibleGroup: widget.expansibleGroup,
                      child: null,
                      scheduleType: ScheduleType.product,
                      callSetState: () {
                        widget.callSetState();
                      },
                    ),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                        child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: EnterpriseBuilder
                                      .entity?.useReducedNameOnProduct ==
                                  true
                              ? product.NameReduced
                              : product.Name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: StringSize.size,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (product.childsComposition != null &&
                            product.childsComposition!.isNotEmpty)
                          TextSpan(
                            text: " (${R.string.combox})",
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: StringSize.size,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ]),
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
                ChildsItems(
                  product: product,
                  expansibleGroup: widget.expansibleGroup,
                  callSetState: widget.callSetState,
                  backgroundColor: color,
                ),
            ],
          ),
        );
      },
    );
  }
}
