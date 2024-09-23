import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/sizes/sizes.dart';
import '../../pages.dart';

class Subgroups extends StatelessWidget {
  final int? selectedIndex;
  final ScrollController productsScrollController;
  final double productItemExtent;
  final int firstVisibleProductIndex;
  const Subgroups({
    super.key,
    required this.selectedIndex,
    required this.productsScrollController,
    required this.productItemExtent,
    required this.firstVisibleProductIndex,
  });

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    Color getSubgroupColor(String subgroupName) {
      if (firstVisibleProductIndex >=
          menuPresenter.loadedMenu[selectedIndex ?? 0].values.first.length) {
        return Theme.of(context).primaryColorLight;
      }
      final element = menuPresenter.loadedMenu[selectedIndex ?? 0].values.first
          .elementAt(firstVisibleProductIndex);

      if (subgroupName == element.subgroupName) {
        return Theme.of(context).primaryColorDark;
      } else {
        return Theme.of(context).primaryColorLight;
      }
    }

    Future<void> scrollToFirstProductOfSubgroup(
      ScrollController productsScrollController,
      String subgroupName,
    ) async {
      if (!productsScrollController.hasClients) return;

      Map<ExpansibleGroupsViewModel, List<ProductsViewModel>> selectedItem =
          menuPresenter.loadedMenu[selectedIndex ?? 0];

      int index = selectedItem.values.first
          .indexWhere((e) => e.subgroupName == subgroupName);

      productsScrollController.animateTo(
        productItemExtent * index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return Builder(builder: (context) {
      final subgroups =
          menuPresenter.loadedMenu[selectedIndex ?? 0].keys.first.subgroups;

      if (subgroups.length == 1) {
        return const SizedBox();
      }
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: subgroups.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final subgroupName = subgroups[index]!;

            return InkWell(
              onTap: () {
                scrollToFirstProductOfSubgroup(
                  productsScrollController,
                  subgroupName,
                );
              },
              child: Container(
                color: getSubgroupColor(subgroupName),
                height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height) /
                    subgroups.length,
                margin: const EdgeInsets.only(bottom: 2),
                child: Center(
                  child: Text(
                    subgroups[index]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getStringSize(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
