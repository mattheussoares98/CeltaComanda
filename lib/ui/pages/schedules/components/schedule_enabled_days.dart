import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class ScheduleEnabledDays extends StatelessWidget {
  final bool allowMonday;
  final bool allowTuesday;
  final bool allowWednesday;
  final bool allowThursday;
  final bool allowFriday;
  final bool allowSaturday;
  final bool allowSunday;
  const ScheduleEnabledDays({
    required this.allowMonday,
    required this.allowTuesday,
    required this.allowWednesday,
    required this.allowThursday,
    required this.allowFriday,
    required this.allowSaturday,
    required this.allowSunday,
    super.key,
  });

  Widget getIcon({
    required bool? enabled,
    required String firstLetterOfDay,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Text(
        firstLetterOfDay,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: StringSize.size,
          color: enabled == false ? Colors.red : Colors.green,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor.withAlpha(30),
      ),
      child: Row(
        children: [
          getIcon(
            enabled: allowMonday,
            firstLetterOfDay: "S",
            context: context,
          ),
          getIcon(
            enabled: allowTuesday,
            firstLetterOfDay: "T",
            context: context,
          ),
          getIcon(
            enabled: allowWednesday,
            firstLetterOfDay: "Q",
            context: context,
          ),
          getIcon(
            enabled: allowThursday,
            firstLetterOfDay: "Q",
            context: context,
          ),
          getIcon(
            enabled: allowFriday,
            firstLetterOfDay: "S",
            context: context,
          ),
          getIcon(
            enabled: allowSaturday,
            firstLetterOfDay: "S",
            context: context,
          ),
          getIcon(
            enabled: allowSunday,
            firstLetterOfDay: "D",
            context: context,
          ),
          const SizedBox(width: 5),
          Icon(
            Icons.edit,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ],
      ),
    );
  }
}
