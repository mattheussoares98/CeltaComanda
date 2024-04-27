import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class InsertCommandNumber extends StatelessWidget {
  final ExpansibleGroupsPresenter presenter;
  final PrintedProductsPresenter printedProductsPresenter;
  const InsertCommandNumber({
    required this.presenter,
    required this.printedProductsPresenter,
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
        child: TextButton(
          onPressed: () {
            showDialogSearchCommandNumber(
              context: context,
              presenter: presenter,
              printedProductsPresenter: printedProductsPresenter,
            );
          },
          child: const Text(
            "Informe o número da comanda",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
