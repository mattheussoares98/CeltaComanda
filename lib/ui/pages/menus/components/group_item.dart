import 'package:flutter/material.dart';

import '../../pages.dart';

class GroupItem extends StatelessWidget {
  final ExpansibleGroupsViewModel expansibleGroupsViewModel;
  final bool groupIsSelected;
  const GroupItem({
    required this.expansibleGroupsViewModel,
    required this.groupIsSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Center(
        child: Text(
          expansibleGroupsViewModel.Name.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: groupIsSelected ? Colors.white : Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
