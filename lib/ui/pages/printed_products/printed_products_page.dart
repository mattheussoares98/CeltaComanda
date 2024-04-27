import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../presentation/presenters/presenters.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class PrintedProductsPage extends StatefulWidget {
  const PrintedProductsPage({
    super.key,
  });

  @override
  State<PrintedProductsPage> createState() => _PrintedProductsPageState();
}

class _PrintedProductsPageState extends State<PrintedProductsPage>
    with LoadingManager, UIErrorManager {
  @override
  Widget build(BuildContext context) {
    GetxExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context);
    GetxPrintedProductsPresenter printedProductsPresenter =
        Provider.of(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  handleLoading(
                      context, printedProductsPresenter.isLoadingStream);
                  handleMainError(
                      context, printedProductsPresenter.mainErrorStream);

                  if (printedProductsPresenter.printedProducts != null) {
                    return PrintedProduct(
                      printed: printedProductsPresenter.printedProducts!,
                    );
                  }
                  return SearchDataByCommandNumber(
                    expansibleGroupsPresenter: expansibleGroupsPresenter,
                    printedProductsPresenter: printedProductsPresenter,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
