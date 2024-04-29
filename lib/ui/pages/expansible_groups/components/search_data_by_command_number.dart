import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class SearchDataByCommandNumber extends StatelessWidget {
  final ExpansibleGroupsPresenter expansibleGroupsPresenter;
  final PrintedProductsPresenter printedProductsPresenter;
  final SaleRequestTempPresenter saleRequestTempPresenter;
  const SearchDataByCommandNumber({
    required this.expansibleGroupsPresenter,
    required this.printedProductsPresenter,
    required this.saleRequestTempPresenter,
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
      child: Center(
        child: TextButton.icon(
          onPressed: () {
            showDialogSearchCommandNumber(
              context: context,
              presenter: expansibleGroupsPresenter,
              printedProductsPresenter: printedProductsPresenter,
              saleRequestTempPresenter: saleRequestTempPresenter,
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
      ),
    );
  }
}
