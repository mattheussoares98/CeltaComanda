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
    MenuPresenter presenter = Provider.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.27,
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

          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    presenter.updateIndexOfSelectedGroup(index);
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
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.4,
                height: 0,
              ),
            ],
          );
        },
      ),
    );
  }
}
