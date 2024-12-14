import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class TitleName extends StatelessWidget {
  final ScheduleType scheduleType;
  final ProductsViewModel? product;
  final ExpansibleGroupsViewModel expansibleGroup;
  const TitleName({
    required this.scheduleType,
    required this.product,
    required this.expansibleGroup,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              scheduleType == ScheduleType.product
                  ? product?.Name ?? ""
                  : expansibleGroup.Name,
              style: TextStyle(
                fontSize: StringSize.size * 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              scheduleType == ScheduleType.product
                  ? product?.childsComposition != null &&
                          product!.childsComposition!.isNotEmpty
                      ? " (${R.string.combox})"
                      : "(${R.string.product})"
                  : "(${R.string.expansibleGroup})",
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
