import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/sizes/sizes.dart';
import '../../pages.dart';

class Subgroups extends StatelessWidget {
  final int? selectedIndex;
  final ScrollController productsScrollController;
  final double productItemExtent;
  final int firstVisibleProductIndex;
  final int groupItemsFlex;
  const Subgroups({
    super.key,
    required this.selectedIndex,
    required this.productsScrollController,
    required this.productItemExtent,
    required this.firstVisibleProductIndex,
    required this.groupItemsFlex,
  });

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    ScrollController subgroupScrollController = ScrollController();

    bool firstIndexIsGreaterThanAtualProductsLength() =>
        firstVisibleProductIndex >=
        menuPresenter.treatSchedules<ProductsViewModel>().length;

    Color getSubgroupColor(String subgroupName) {
      if (firstIndexIsGreaterThanAtualProductsLength()) {
        return Theme.of(context).primaryColorLight;
      }
      final element = menuPresenter
          .treatSchedules<ProductsViewModel>()
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
      if (!productsScrollController.hasClients ||
          firstIndexIsGreaterThanAtualProductsLength()) {
        return;
      }

      List<ProductsViewModel> products =
          menuPresenter.treatSchedules<ProductsViewModel>();

      int index = products.indexWhere((e) => e.subgroupName == subgroupName);

      productsScrollController.animateTo(
        productItemExtent * index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    Future<void> scrollSubgroup(List<String?> subgroups, int index) async {
      if (!productsScrollController.hasClients ||
          hasMinWidth(context) ||
          firstIndexIsGreaterThanAtualProductsLength()) {
        return;
      }

      final element = menuPresenter.loadedMenu[selectedIndex ?? 0].values.first
          .elementAt(firstVisibleProductIndex);

      if (element.subgroupName != subgroups[index]) return;

      subgroupScrollController.animateTo(
        MediaQuery.of(context).size.width * 0.35 * (index - 0.5),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return Builder(builder: (context) {
      final subgroups = menuPresenter
          .treatSchedules<ExpansibleGroupsViewModel>()[selectedIndex ?? 0]
          .subgroups
          .where((e) => menuPresenter
              .treatSchedules<ProductsViewModel>()
              .where((t) => t.subgroupName == e)
              .toList()
              .isNotEmpty)
          .toList();

      if (subgroups.isEmpty) {
        return const SizedBox();
      }
      return Expanded(
        child: ListView.builder(
          controller: subgroupScrollController,
          shrinkWrap: true,
          scrollDirection:
              hasMinWidth(context) ? Axis.vertical : Axis.horizontal,
          itemCount: subgroups.length,
          itemExtent: hasMinWidth(context)
              ? (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height) /
                  subgroups.length
              : MediaQuery.of(context).size.width * 0.35,
          itemBuilder: (context, index) {
            final subgroupName = subgroups[index].toString();
            Future.delayed(Duration.zero, () {
              scrollSubgroup(subgroups, index);
            });

            return InkWell(
              onTap: () {
                scrollToFirstProductOfSubgroup(
                  productsScrollController,
                  subgroupName,
                );
              },
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: getSubgroupColor(subgroupName),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      subgroups[index].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: StringSize.size,
                        fontWeight: FontWeight.bold,
                      ),
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
