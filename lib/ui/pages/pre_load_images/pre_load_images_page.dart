import 'package:provider/provider.dart';

import '../../../ui/components/components.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

import 'package:flutter/material.dart';

class PreLoadImagesPage extends StatefulWidget {
  final PageController? pageController;
  final bool? isFixedCommandNumber;
  const PreLoadImagesPage({
    this.pageController,
    this.isFixedCommandNumber,
    super.key,
  });

  @override
  State<PreLoadImagesPage> createState() => _PreLoadImagesPageState();
}

class _PreLoadImagesPageState extends State<PreLoadImagesPage>
    with UIErrorManager, LoadingManager {
  List<String> allPlus = [];
  List<String> allEans = [];

  void addPlusInAllPlusList(MenuPresenter menuPresenter) {
    final allProducts = menuPresenter.loadedMenu
        .expand((map) => map.values)
        .expand((lista) => lista)
        .toList();

    void addPlu(String? plu) {
      if (!allPlus.contains(plu) && plu != null) {
        allPlus.add(plu);
      }
    }

    for (var product in allProducts) {
      addPlu(product.EanCode ?? product.PriceLookupCode);

      if (product.childsComposition != null) {
        for (var combox in product.childsComposition!) {
          addPlu(combox.PluChild);

          if (combox.childs?.isNotEmpty == true) {
            for (var child in combox.childs!) {
              addPlu(child.PluChild);
            }
          }
        }
      }
    }
  }

  void addEansInAllEansList(MenuPresenter menuPresenter) {
    final allProducts = menuPresenter.loadedMenu
        .expand((map) => map.values)
        .expand((lista) => lista)
        .toList();

    for (var product in allProducts) {
      if (product.EanCode != null) {
        allEans.add(product.EanCode!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    addPlusInAllPlusList(menuPresenter);
    addEansInAllEansList(menuPresenter);

    return Stack(
      children: [
        SizedBox(
          height: 0,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 1,
                childAspectRatio: 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: allPlus.length,
              itemBuilder: (context, index) {
                final plu = allPlus[index];

                return ImageWidget(
                  ean: null,
                  plu: plu,
                  selectedProduct: null,
                  height: 1,
                  width: 1,
                );
              }),
        ),
        SizedBox(
          height: 1,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 1,
                childAspectRatio: 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: allEans.length,
              itemBuilder: (context, index) {
                final ean = allEans[index];

                return ImageWidget(
                  ean: ean,
                  plu: "",
                  selectedProduct: null,
                  height: 1,
                  width: 1,
                );
              }),
        ),
        Container(color: Colors.white),
      ],
    );
  }
}
