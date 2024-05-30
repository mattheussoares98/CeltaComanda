import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../pages.dart';

class GroupItems extends StatefulWidget {
  final List<ExpansibleGroupsViewModel> expansibleGroupsViewModel;
  const GroupItems({
    required this.expansibleGroupsViewModel,
    super.key,
  });

  @override
  State<GroupItems> createState() => _GroupItemsState();
}

class _GroupItemsState extends State<GroupItems> {
  @override
  Widget build(BuildContext context) {
    ExpansibleGroupsPresenter presenter = Provider.of(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.expansibleGroupsViewModel.length,
      itemBuilder: (context, index) {
        final groupViewModel = widget.expansibleGroupsViewModel[index];

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  presenter.indexOfSelectedGroup = index;
                });
              },
              child: GroupItem(
                expansibleGroupsViewModel: groupViewModel,
                groupIndex: index,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.0),
              child: Divider(thickness: 0.2),
            ),
          ],
        );
      },
    );
  }
}
