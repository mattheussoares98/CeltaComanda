import 'package:clean_celta_mobile/ui/pages/menus/components/subgroups.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/pages.dart';
import '../../../helpers/helpers.dart';

class GroupsSubgroupsAndProducts extends StatelessWidget {
  final int? selectedIndex;
  const GroupsSubgroupsAndProducts({
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
    required ScrollController productsScrollController,
  }) async {
    if (!productsScrollController.hasClients) return;

    final currentPosition = productsScrollController.position.pixels;
    final minScrollExtent = productsScrollController.position.minScrollExtent;

    if (currentPosition >= minScrollExtent) {
      await productsScrollController.animateTo(
        productsScrollController.position.minScrollExtent,
        duration: Duration(
            milliseconds: menuPresenter
                    .loadedMenu[selectedIndex ?? 0].values.first.length *
                50),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    }
  }

  double getProductItemExtent(BuildContext context) {
    return (MediaQuery.of(context).size.height -
            AppBar().preferredSize.height) /
        3.5;
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    final productsScrollController = ScrollController();

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
                  productsScrollController: productsScrollController,
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
              child: Row(
                children: [
                  if (hasMinWidth(context))
                    Subgroups(
                      selectedIndex: selectedIndex,
                      productsScrollController: productsScrollController,
                      productItemExtent: getProductItemExtent(context),
                    ),
                  Expanded(
                    flex: 4,
                    child: ProductsItems(
                      products: menuPresenter
                          .loadedMenu[selectedIndex ?? 0].values.first,
                      productsScrollController: productsScrollController,
                      itemExtent: getProductItemExtent(context),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
