import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class LoadMenuButton extends StatelessWidget {
  const LoadMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return SizedBox(
      height:
          MediaQuery.of(context).size.height - AppBar().preferredSize.height,
      child: Center(
        child: TextButton.icon(
          key: const Key("loadMenu"),
          onPressed: () async {
            if (homePresenter.commandEntity?.isFixedCommandNumber == true) {
              await homePresenter.loadCommandData(
                menuPresenter: menuPresenter,
                printedProductsPresenter: printedProductsPresenter,
                cartPresenter: cartPresenter,
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
              );
            } else {
              await menuPresenter.getGroupsAndProducts(
                commandNumber: "001",
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
              );
            }
          },
          icon: Icon(
            Icons.menu_book,
            size: hasMinWidth(context) ? 50 : 30,
            color: Theme.of(context).primaryColorDark,
          ),
          label: Text(
            R.string.loadMenu,
            style: TextStyle(
              fontSize: hasMinWidth(context) ? 40 : 30,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
      ),
    );
  }
}
