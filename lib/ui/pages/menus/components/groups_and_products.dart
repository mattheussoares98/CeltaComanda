import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/pages.dart';

class GroupsAndProducts extends StatelessWidget {
  final int? selectedIndex;
  final ProductsViewModel? selectedProduct;
  const GroupsAndProducts({
    required this.selectedIndex,
    required this.selectedProduct,
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
            child: GroupItems(
              expansibleGroupsViewModel: menuPresenter.loadedMenu
                  .map((element) => element.keys.first)
                  .toList(),
              selectedIndex: selectedIndex ?? 0,
            ),
          ),
          Expanded(
            flex: 80,
            child: ProductsItems(
              itensPerLine: 2,
              products: menuPresenter
                  .loadedMenu[selectedIndex ?? 0].entries.first.value,
              selectedProduct: selectedProduct,
            ),
          ),
        ],
      ),
    );
  }
}
