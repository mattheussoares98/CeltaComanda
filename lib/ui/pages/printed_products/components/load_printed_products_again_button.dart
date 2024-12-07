import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class LoadPrintedProductsAgainButton extends StatelessWidget {
  const LoadPrintedProductsAgainButton({super.key});

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return IconButton(
      onPressed: homePresenter.commandEntity!.commandNumber == null
          ? null
          : () async {
              await printedProductsPresenter
                  .loadPrinted(homePresenter.commandEntity!.commandNumber!);
            },
      icon: Row(
        children: [
          if (homePresenter.commandEntity?.commandNumber != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                "${R.string.command} ${homePresenter.commandEntity!.commandNumber!.toInt()}",
                style: TextStyle(fontSize: getStringSize(context)),
              ),
            ),
          const Icon(Icons.refresh),
        ],
      ),
    );
  }
}
