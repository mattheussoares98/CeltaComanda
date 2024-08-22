import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class UpdateMenuButton extends StatelessWidget {
  const UpdateMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            label: Text(R.string.updateMenu),
            icon: Icon(
              Icons.refresh_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await homePresenter.loadCommandData(
                menuPresenter: menuPresenter,
                printedProductsPresenter: printedProductsPresenter,
                cartPresenter: cartPresenter,
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
                homePresenter: homePresenter,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  R.string.close.toUpperCase(),
                  style: TextStyle(
                    fontSize: getStringSize(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
