import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/sizes/sizes.dart';
import '../../pages.dart';

class Subgroups extends StatelessWidget {
  final int? selectedIndex;
  final ScrollController productsScrollController;
  final double productItemExtent;
  const Subgroups({
    super.key,
    required this.selectedIndex,
    required this.productsScrollController,
    required this.productItemExtent,
  });

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    // Future<void> _scrollToFirstProductOfSubgroup(
    //   ScrollController productsScrollController,
    //   String subgroupName,
    // ) async {
    //   if (!productsScrollController.hasClients) return;

    //   for (var item in menuPresenter.loadedMenu) {
    //     // item.entries.first.value.indexWhere((e) => e.subGroup)
    //   }

    //   // productsScrollController.animateTo(
    //   //   productItemExtent * indexOfSubgroup,
    //   //   duration: const Duration(milliseconds: 300),
    //   //   curve: Curves.easeInOut,
    //   // );
    // }

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
            return InkWell(
              onTap: () {},
              child: Container(
                color: Theme.of(context).primaryColorLight,
                height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height) /
                    subgroups.length,
                margin: const EdgeInsets.only(bottom: 2),
                child: Center(
                  child: Text(
                    subgroups[index]!,
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
