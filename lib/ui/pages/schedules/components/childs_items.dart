import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class ChildsItems extends StatelessWidget {
  final ProductsViewModel product;
  final ExpansibleGroupsViewModel expansibleGroup;
  final void Function() callSetState;
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

        if (father.childs == null || father.childs!.isEmpty) {
          return SizedBox();
        }

        return Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: father.childs!.length,
                itemBuilder: (context, childIndex) {
                  final child = father.childs![childIndex];
                  return InkWell(
                    onTap: () {
                      PersonalizedDialogPage.open(
                        context: context,
                        page: EnableOrDisableDays(
                          product: product,
                          expansibleGroup: expansibleGroup,
                          scheduleType: ScheduleType.child,
                          child: child,
                          callSetState: () {
                            callSetState();
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                                  "- ${child.ChildName!}   (${R.string.child.toUpperCase()})")),
                          ScheduleEnabledDays(
                            allowMonday: child.Schedule?.AllowMonday != false,
                            allowTuesday: child.Schedule?.AllowTuesday != false,
                            allowWednesday:
                                child.Schedule?.AllowWednesday != false,
                            allowThursday:
                                child.Schedule?.AllowThursday != false,
                            allowFriday: child.Schedule?.AllowFriday != false,
                            allowSaturday:
                                child.Schedule?.AllowSaturday != false,
                            allowSunday: child.Schedule?.AllowSunday != false,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                color: backgroundColor,
                child: Text(
                  "${father.ChildName!} (${R.string.father.toUpperCase()})",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: StringSize.size,
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
