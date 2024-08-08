import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/pages.dart';
import '../../../helpers/helpers.dart';

class GroupsAndProducts extends StatelessWidget {
  final int? selectedIndex;
  const GroupsAndProducts({
    required this.selectedIndex,
    super.key,
  });

  bool isDetachSelected(MenuPresenter menuPresenter) {
    for (var menu in menuPresenter.loadedMenu) {
      for (var group in menu.keys) {
        if (group.Name.toLowerCase() == R.string.detach.toLowerCase() &&
            (selectedIndex == 0 || selectedIndex == null)) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _scrollUp({
    required MenuPresenter menuPresenter,
    required ScrollController scrollController,
  }) async {
    if (!scrollController.hasClients) return;

    final currentPosition = scrollController.position.pixels;
    final minScrollExtent = scrollController.position.minScrollExtent;

    if (currentPosition >= minScrollExtent) {
      await scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: Duration(
            milliseconds: menuPresenter
                    .loadedMenu[selectedIndex ?? 0].entries.first.value.length *
                50),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    final scrollController = ScrollController();

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: hasMinWidth(context) ? 10 : 25,
            child: GroupItems(
              expansibleGroupsViewModel: menuPresenter.loadedMenu
                  .map((element) => element.keys.first)
                  .toList(),
              selectedIndex: selectedIndex ?? 0,
              scrollUpItemsList: () {
                _scrollUp(
                  menuPresenter: menuPresenter,
                  scrollController: scrollController,
                );
              },
            ),
          ),
          if (isDetachSelected(menuPresenter))
            Expanded(
              flex: hasMinWidth(context) ? 90 : 75,
              child: DetachItems(
                products: menuPresenter.loadedMenu[0].entries.first.value,
              ),
            ),
          if (!isDetachSelected(menuPresenter))
            Expanded(
              flex: hasMinWidth(context) ? 90 : 75,
              child: ProductsItems(
                selectedGroupIndex: selectedIndex,
                products: menuPresenter
                    .loadedMenu[selectedIndex ?? 0].entries.first.value,
                scrollController: scrollController,
              ),
            ),
        ],
      ),
    );
  }
}
