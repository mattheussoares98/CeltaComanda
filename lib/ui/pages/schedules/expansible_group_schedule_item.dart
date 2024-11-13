import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

class ExpansibleGroupScheduleItem extends StatelessWidget {
  final ExpansibleGroupsViewModel expansibleGroup;
  const ExpansibleGroupScheduleItem({
    required this.expansibleGroup,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              expansibleGroup.Name,
              style: TextStyle(
                fontSize: getStringSize(context),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          
        ],
      ),
    );
  }
}
