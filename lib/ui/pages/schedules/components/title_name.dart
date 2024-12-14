import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class TitleName extends StatelessWidget {
  final ScheduleType scheduleType;
  final ProductsViewModel? product;
  final ProductCompositionViewModel? child;
  final ExpansibleGroupsViewModel expansibleGroup;
  const TitleName({
    required this.scheduleType,
    required this.product,
    required this.child,
    required this.expansibleGroup,
    super.key,
  });

  String getName() {
    if (scheduleType == ScheduleType.product && product != null) {
      return product?.Name ?? "";
    } else if (scheduleType == ScheduleType.expansibleGroup) {
      return expansibleGroup.Name;
    } else if (child != null) {
      return child!.ChildName!;
    } else {
      return "";
    }
  }

  String getType() {
    if (scheduleType == ScheduleType.product &&
        product != null &&
        product!.childsComposition != null &&
        product!.childsComposition!.isNotEmpty) {
      return " (${R.string.combox})";
    } else if (scheduleType == ScheduleType.product && product != null) {
      return " (${R.string.product})";
    } else if (scheduleType == ScheduleType.expansibleGroup) {
      return " (${R.string.expansibleGroup})";
    } else {
      return " (${R.string.child})";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getName(),
              style: TextStyle(
                fontSize: StringSize.size * 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              getType(),
              style: TextStyle(
                fontSize: StringSize.size,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
