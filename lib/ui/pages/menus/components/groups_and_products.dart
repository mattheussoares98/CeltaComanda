import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupsAndProducts extends StatelessWidget {
  final int? selectedIndex;
  const GroupsAndProducts({
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 20,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: GroupItems(
                expansibleGroupsViewModel: menuPresenter.loadedMenu
                    .map((element) => element.keys.first)
                    .toList(),
                selectedIndex: selectedIndex ?? 0,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 80,
            child: ProductsItems(
              itensPerLine: 2,
              products: menuPresenter
                  .loadedMenu[selectedIndex ?? 0].entries.first.value,
            ),
          ),
        ],
      ),
    );
  }
}
