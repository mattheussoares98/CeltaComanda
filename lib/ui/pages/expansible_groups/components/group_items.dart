import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../pages.dart';

class GroupItems extends StatefulWidget {
  final List<ExpansibleGroupsViewModel> expansibleGroupsViewModel;
  final int selectedIndex;
  const GroupItems({
    required this.expansibleGroupsViewModel,
    required this.selectedIndex,
    super.key,
  });

  @override
  State<GroupItems> createState() => _GroupItemsState();
}

class _GroupItemsState extends State<GroupItems> {
  @override
  Widget build(BuildContext context) {
    ExpansibleGroupsPresenter presenter = Provider.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.27,
      height: MediaQuery.of(context).size.height -
          AppBar().preferredSize.height -
          MediaQuery.of(context).padding.bottom -
          kBottomNavigationBarHeight -
          72,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              blurRadius: 4, color: Color(0x33000000), offset: Offset(1, -1))
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(top: 8),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.expansibleGroupsViewModel.length,
        itemBuilder: (context, index) {
          final groupViewModel = widget.expansibleGroupsViewModel[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                presenter.updateIndexOfSelectedGroup(index);
              });
            },
            child: Container(
              height: 70,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: GroupItem(
                      expansibleGroupsViewModel: groupViewModel,
                      groupIsSelected: widget.selectedIndex == index,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.grey,
            thickness: 0.4,
            height: 0,
          );
        },
      ),
    );
  }
}
