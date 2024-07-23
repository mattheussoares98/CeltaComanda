import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../pages.dart';

class GroupItems extends StatefulWidget {
  final List<ExpansibleGroupsViewModel> expansibleGroupsViewModel;
  final int selectedIndex;
  final Function() scrollUpItemsList;
  const GroupItems({
    required this.expansibleGroupsViewModel,
    required this.selectedIndex,
    required this.scrollUpItemsList,
    super.key,
  });

  @override
  State<GroupItems> createState() => _GroupItemsState();
}

class _GroupItemsState extends State<GroupItems> {
  bool isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isLoaded) {
      isLoaded = true;
      MenuPresenter menuPresenter = Provider.of(context, listen: false);
      Future.delayed(Duration.zero, () {
        menuPresenter.updateIndexOfSelectedGroup(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              blurRadius: 4, color: Color(0x33000000), offset: Offset(1, -1))
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.expansibleGroupsViewModel.length,
        itemBuilder: (context, index) {
          final groupViewModel = widget.expansibleGroupsViewModel[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                menuPresenter.updateIndexOfSelectedGroup(index);
                widget.scrollUpItemsList();
              });
            },
            child: Container(
              margin: const EdgeInsets.all(1),
              height: 70,
              decoration: BoxDecoration(
                gradient: widget.selectedIndex == index
                    ? LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Theme.of(context).primaryColorLight,
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColorDark,
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(10),
              ),
              child: GroupItem(
                expansibleGroupsViewModel: groupViewModel,
                groupIsSelected: widget.selectedIndex == index,
              ),
            ),
          );
        },
      ),
    );
  }
}
