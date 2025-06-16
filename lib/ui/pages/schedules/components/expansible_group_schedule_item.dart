import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class ExpansibleGroupScheduleItem extends StatelessWidget {
  final ExpansibleGroupsViewModel expansibleGroup;
  final StateSetter callSetSate;
  final void Function() updateSelectedGroupIndex;
  final bool groupIsSelected;

  const ExpansibleGroupScheduleItem({
    required this.expansibleGroup,
    required this.callSetSate,
    required this.updateSelectedGroupIndex,
    required this.groupIsSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              expansibleGroup.Name,
              style: TextStyle(
                fontSize: StringSize.size * 1.5,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          IconButton(
            onPressed: () {
              updateSelectedGroupIndex();
            },
            icon: Icon(
              groupIsSelected ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          InkWell(
            onTap: () {
              PersonalizedDialogPage.open(
                context: context,
                page: EnableOrDisableDays(
                  product: null,
                  child: null,
                  expansibleGroup: expansibleGroup,
                  scheduleType: ScheduleType.expansibleGroup,
                  callSetState: callSetSate,
                ),
              );
            },
            child: Row(
              children: [
                ScheduleEnabledDays(
                  allowMonday: expansibleGroup.Schedule?.AllowMonday != false,
                  allowTuesday: expansibleGroup.Schedule?.AllowTuesday != false,
                  allowWednesday:
                      expansibleGroup.Schedule?.AllowWednesday != false,
                  allowThursday:
                      expansibleGroup.Schedule?.AllowThursday != false,
                  allowFriday: expansibleGroup.Schedule?.AllowFriday != false,
                  allowSaturday:
                      expansibleGroup.Schedule?.AllowSaturday != false,
                  allowSunday: expansibleGroup.Schedule?.AllowSunday != false,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
