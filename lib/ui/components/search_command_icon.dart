import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/presenters/presenters.dart';

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
    GetxExpansibleGroupsPresenter presenter = Provider.of(context);
    GetxPrintedProductsPresenter printedProductsPresenter =
        Provider.of(context);

    return GestureDetector(
      key: const Key("SearchCommandIcon"),
      onTap: () {
        showDialogSearchCommandNumber(
          context: context,
          presenter: presenter,
          printedProductsPresenter: printedProductsPresenter,
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
                  presenter: presenter,
                  printedProductsPresenter: printedProductsPresenter,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}