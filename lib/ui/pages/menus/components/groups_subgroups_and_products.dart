import 'package:clean_celta_mobile/ui/pages/menus/components/subgroups.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/pages.dart';
import '../../../helpers/helpers.dart';

class GroupsSubgroupsAndProducts extends StatefulWidget {
  final int? selectedIndex;
  const GroupsSubgroupsAndProducts({
    required this.selectedIndex,
    super.key,
  });

  @override
  State<GroupsSubgroupsAndProducts> createState() =>
      _GroupsSubgroupsAndProductsState();
}

class _GroupsSubgroupsAndProductsState
    extends State<GroupsSubgroupsAndProducts> {
  final productsScrollController = ScrollController();
  int firstVisibleProductIndex = 0;

  bool groupIsSelected(MenuPresenter menuPresenter, String groupName) {
    return menuPresenter
            .treatSchedules<ExpansibleGroupsViewModel>()[
                widget.selectedIndex ?? 0]
            .Name
            .toLowerCase() ==
        groupName.toLowerCase();
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
                    .loadedMenu[widget.selectedIndex ?? 0].values.first.length *
                50),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    }
  }

  double getProductItemExtent(BuildContext context) {
    return (MediaQuery.of(context).size.height -
            AppBar().preferredSize.height) /
        (hasMinWidth(context) ? 3 : 3.5);
  }

  @override
  void initState() {
    super.initState();

    productsScrollController.addListener(_checkFirstVisibleItem);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _checkFirstVisibleItem() {
    if (productsScrollController.hasClients) {
      setState(() {
        firstVisibleProductIndex =
            (productsScrollController.offset / getProductItemExtent(context))
                .floor();
      });
    }
  }

  int getGroupItemFlex() => hasMinWidth(context) ? 10 : 25;

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: getGroupItemFlex(),
            child: GroupItems(
              expansibleGroupsViewModel:
                  menuPresenter.treatSchedules<ExpansibleGroupsViewModel>(),
              selectedIndex: widget.selectedIndex ?? 0,
              scrollUpItemsList: () {
                _scrollUp(
                  menuPresenter: menuPresenter,
                  productsScrollController: productsScrollController,
                );
              },
            ),
          ),
          if (groupIsSelected(menuPresenter, R.string.detach))
            Expanded(
              flex: hasMinWidth(context) ? 90 : 75,
              child: const DetachItems(),
            ),
          if (groupIsSelected(menuPresenter, R.string.searchProduct))
            Expanded(
              flex: hasMinWidth(context) ? 90 : 75,
              child: InsertProductBody(),
            ),
          if (!groupIsSelected(menuPresenter, R.string.detach) &&
              !groupIsSelected(menuPresenter, R.string.searchProduct))
            Expanded(
              flex: hasMinWidth(context) ? 90 : 75,
              child: Column(
                children: [
                  if (!hasMinWidth(context))
                    Subgroups(
                      groupItemsFlex: getGroupItemFlex(),
                      selectedIndex: widget.selectedIndex,
                      productsScrollController: productsScrollController,
                      productItemExtent: getProductItemExtent(context),
                      firstVisibleProductIndex: firstVisibleProductIndex,
                    ),
                  Expanded(
                    flex: 9,
                    child: Row(
                      children: [
                        if (hasMinWidth(context))
                          Subgroups(
                            groupItemsFlex: getGroupItemFlex(),
                            selectedIndex: widget.selectedIndex,
                            productsScrollController: productsScrollController,
                            productItemExtent: getProductItemExtent(context),
                            firstVisibleProductIndex: firstVisibleProductIndex,
                          ),
                        Expanded(
                          flex: 4,
                          child: ProductsItems(
                            products: menuPresenter
                                .treatSchedules<ProductsViewModel>(),
                            productsScrollController: productsScrollController,
                            itemExtent: getProductItemExtent(context),
                          ),
                        ),
                      ],
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
