import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import '../../../data/models/models.dart';

class ProductScheduleEnabledDays extends StatelessWidget {
  final ProductScheduleModel? productSchedule;
  const ProductScheduleEnabledDays({
    required this.productSchedule,
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
          fontSize: getStringSize(context),
          color: enabled == false ? Colors.red : Colors.green,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        getIcon(
          enabled: productSchedule?.AllowMonday,
          firstLetterOfDay: "S",
          context: context,
        ),
        getIcon(
          enabled: productSchedule?.AlloTuesday,
          firstLetterOfDay: "T",
          context: context,
        ),
        getIcon(
          enabled: productSchedule?.AllowWednesday,
          firstLetterOfDay: "Q",
          context: context,
        ),
        getIcon(
          enabled: productSchedule?.AllowThursday,
          firstLetterOfDay: "Q",
          context: context,
        ),
        getIcon(
          enabled: productSchedule?.AllowFriday,
          firstLetterOfDay: "S",
          context: context,
        ),
        getIcon(
          enabled: productSchedule?.AllowSaturday,
          firstLetterOfDay: "S",
          context: context,
        ),
        getIcon(
          enabled: productSchedule?.AllowSunday,
          firstLetterOfDay: "D",
          context: context,
        ),
      ],
    );
  }
}
