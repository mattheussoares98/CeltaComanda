import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../presentation/presenters/presenters.dart';
import '../../ui/pages/pages.dart';

class SearchCommandIcon extends StatefulWidget {
  const SearchCommandIcon({
    super.key,
  });

  @override
  State<SearchCommandIcon> createState() => _SearchCommandIconState();
}

class _SearchCommandIconState extends State<SearchCommandIcon> {
  @override
  Widget build(BuildContext context) {
    GetxExpansibleGroupsPresenter expansibleGroupsPresenterr =
        Provider.of(context);
    GetxSaleRequestTempPresenter saleRequestTempPresenter = Provider.of(context);
    GetxPrintedProductsPresenter printedProductsPresenter =
        Provider.of(context);
    GetxHomePresenter homePresenter =
        Provider.of(context);

    return GestureDetector(
      key: const Key("SearchCommandIcon"),
      onTap: () {
        showDialogSearchCommandNumber(
          context: context,
          expansibleGroupsPresenter: expansibleGroupsPresenterr,
          printedProductsPresenter: printedProductsPresenter,
          saleRequestTempPresenter: saleRequestTempPresenter,
          homePresenter: homePresenter,
        );
      },
      child: FittedBox(
        child: Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.find_replace_rounded,
                color: Colors.grey,
                size: 28,
              ),
              onPressed: () {
                showDialogSearchCommandNumber(
                  context: context,
                  expansibleGroupsPresenter: expansibleGroupsPresenterr,
                  printedProductsPresenter: printedProductsPresenter,
                  saleRequestTempPresenter: saleRequestTempPresenter,
                  homePresenter: homePresenter,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
