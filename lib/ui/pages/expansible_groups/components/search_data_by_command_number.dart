import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class SearchDataByCommandNumber extends StatelessWidget {
  final ExpansibleGroupsPresenter expansibleGroupsPresenter;
  final PrintedProductsPresenter printedProductsPresenter;
  final SaleRequestTempPresenter saleRequestTempPresenter;
  final HomePresenter homePresenter;
  const SearchDataByCommandNumber({
    required this.expansibleGroupsPresenter,
    required this.printedProductsPresenter,
    required this.saleRequestTempPresenter,
    required this.homePresenter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final usableScreenHeight = screenHeight - appBarHeight - statusBarHeight;

    return SizedBox(
      height: usableScreenHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Não há dados",
            textAlign: TextAlign.center,
          ),
          TextButton.icon(
            onPressed: () {
              showDialogSearchCommandNumber(
                context: context,
                expansibleGroupsPresenter: expansibleGroupsPresenter,
                printedProductsPresenter: printedProductsPresenter,
                saleRequestTempPresenter: saleRequestTempPresenter,
                homePresenter: homePresenter,
              );
            },
            icon: const Icon(Icons.search),
            label: const Text(
              "Consultar dados da comanda",
              textAlign: TextAlign.center,
              style: TextStyle(
                  // fontSize: 25,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
