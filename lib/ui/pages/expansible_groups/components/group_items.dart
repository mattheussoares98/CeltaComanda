import 'package:flutter/material.dart';

import '../../pages.dart';

class GroupItems extends StatelessWidget {
  final List<ExpansibleGroupsViewModel> expansibleGroupsViewModel;
  const GroupItems({
    required this.expansibleGroupsViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expansibleGroupsViewModel.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (context, index) {
        final groupViewModel = expansibleGroupsViewModel[index];

        return GroupItem(expansibleGroupsViewModel: groupViewModel);
      },
    );
  }
}
