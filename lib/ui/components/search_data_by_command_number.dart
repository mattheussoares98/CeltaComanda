import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/helpers/helpers.dart';
import '../pages/pages.dart';
import 'components.dart';

class SearchDataByCommandNumber extends StatelessWidget {
  const SearchDataByCommandNumber({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: true);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (printedProductsPresenter.printed == null)
          Text(
            R.string.msgCommandDontHaveOpenValues,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenSize.hasMinWidth ? 30 : 23,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: TextButton.icon(
            onPressed: () async {
              if (homePresenter.commandEntity?.isFixedCommandNumber == true) {
                await printedProductsPresenter.loadPrinted(
                  homePresenter.commandEntity!.commandNumber!,
                );
              } else {
                final commandNumber = await GetCommandNumber.get(homePresenter);

                if (commandNumber != null) {
                  await printedProductsPresenter.loadPrinted(
                    commandNumber.toString(),
                  );
                }
              }
            },
            icon: Icon(
              Icons.search,
              size: ScreenSize.hasMinWidth ? 40 : 25,
              color: Theme.of(context).primaryColorDark,
            ),
            label: Text(
              homePresenter.commandEntity?.isFixedCommandNumber == true
                  ? R.string.searchCommandData
                  : R.string.searchDataOfOtherCommandNumber,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ScreenSize.hasMinWidth ? 30 : 23,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
