import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class ChildsItems extends StatelessWidget {
  final ProductsViewModel product;
  final ExpansibleGroupsViewModel expansibleGroup;
  final StateSetter callSetState;
  final Color backgroundColor;
  const ChildsItems({
    required this.product,
    required this.expansibleGroup,
    required this.callSetState,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: product.childsComposition!.length,
      itemBuilder: (context, fatherIndex) {
        final father = product.childsComposition![fatherIndex];
        product.childsComposition!.sort(
            (a, b) => (a.childs?.length ?? 0).compareTo(b.childs?.length ?? 0));

        if (father.childs == null || father.childs!.isEmpty) {
          return InkWell(
            onTap: () {
              PersonalizedDialogPage.open(
                context: context,
                page: EnableOrDisableDays(
                  product: product,
                  expansibleGroup: expansibleGroup,
                  scheduleType: ScheduleType.child,
                  child: father,
                  callSetState: callSetState,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "- ${father.ChildName}   (${R.string.product.toUpperCase()})",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ScheduleEnabledDays(
                    allowMonday: father.Schedule?.AllowMonday != false,
                    allowTuesday: father.Schedule?.AllowTuesday != false,
                    allowWednesday: father.Schedule?.AllowWednesday != false,
                    allowThursday: father.Schedule?.AllowThursday != false,
                    allowFriday: father.Schedule?.AllowFriday != false,
                    allowSaturday: father.Schedule?.AllowSaturday != false,
                    allowSunday: father.Schedule?.AllowSunday != false,
                  ),
                ],
              ),
            ),
          );
        }

        return Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: father.childs!.length,
                itemBuilder: (context, childIndex) {
                  final child = father.childs![childIndex];

                  return Column(
                    children: [
                      if (childIndex > 0) Divider(thickness: 0.3),
                      InkWell(
                        onTap: () {
                          PersonalizedDialogPage.open(
                            context: context,
                            page: EnableOrDisableDays(
                              product: product,
                              expansibleGroup: expansibleGroup,
                              scheduleType: ScheduleType.child,
                              child: child,
                              callSetState: callSetState,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "- ${child.ChildName!}   (${R.string.child.toUpperCase()})",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ScheduleEnabledDays(
                                allowMonday:
                                    child.Schedule?.AllowMonday != false,
                                allowTuesday:
                                    child.Schedule?.AllowTuesday != false,
                                allowWednesday:
                                    child.Schedule?.AllowWednesday != false,
                                allowThursday:
                                    child.Schedule?.AllowThursday != false,
                                allowFriday:
                                    child.Schedule?.AllowFriday != false,
                                allowSaturday:
                                    child.Schedule?.AllowSaturday != false,
                                allowSunday:
                                    child.Schedule?.AllowSunday != false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Text(
                  "${father.ChildName!} (${R.string.father.toUpperCase()})",
                  style: TextStyle(
                    backgroundColor: backgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: StringSize.size,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
