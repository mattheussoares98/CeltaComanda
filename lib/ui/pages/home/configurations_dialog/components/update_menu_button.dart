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
          Expanded(
            child: TextButton.icon(
              label: Text(
                MediaQuery.of(context).size.width > 250
                    ? R.string.updateMenu
                    : "",
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
              icon: Flexible(
                child: Icon(
                  Icons.refresh_outlined,
                  color: Theme.of(context).primaryColorDark,
                ),
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
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: TextButton(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
