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
  List<String> getAllPlus(MenuPresenter menuPresenter) {
    List<String> urls = [];

    final allProducts = menuPresenter.loadedMenu
        .expand((map) => map.values)
        .expand((lista) => lista)
        .toList();

    for (var product in allProducts) {
      urls.add(product.EanCode ?? product.PriceLookupCode);

      if (product.childsComposition != null) {
        for (var combox in product.childsComposition!) {
          urls.add(combox.PluChild!);

          if (combox.childs?.isNotEmpty == true) {
            for (var child in combox.childs!) {
              urls.add(child.PluChild!);
            }
          }
        }
      }
    }

    return urls;
  }

  List<String> getAllEans(MenuPresenter menuPresenter) {
    List<String> urls = [];

    final allProducts = menuPresenter.loadedMenu
        .expand((map) => map.values)
        .expand((lista) => lista)
        .toList();

    for (var product in allProducts) {
      if (product.EanCode != null) {
        urls.add(product.EanCode!);
      }
    }

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return StreamBuilder<bool>(
        stream: menuPresenter.showPreLoadImagesStream,
        builder: (context, snapshot) {
          if (snapshot.data != false) {
            return Stack(
              children: [
                SizedBox(
                  height: 1,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 1,
                        childAspectRatio: 1,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      itemCount: getAllPlus(menuPresenter).length,
                      itemBuilder: (context, index) {
                        final plu = getAllPlus(menuPresenter)[index];

                        return ImageWidget(
                          ean: null,
                          plu: plu,
                          isAlcoholic: false,
                          height: 1,
                          width: 1,
                        );
                      }),
                ),
                SizedBox(
                  height: 1,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 1,
                        childAspectRatio: 1,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      itemCount: getAllEans(menuPresenter).length,
                      itemBuilder: (context, index) {
                        final ean = getAllEans(menuPresenter)[index];

                        return ImageWidget(
                          ean: ean,
                          plu: "",
                          isAlcoholic: false,
                          height: 1,
                          width: 1,
                        );
                      }),
                ),
                Container(color: Colors.white),
              ],
            );
          } else{
            return const SizedBox();
          }
        });
  }
}
