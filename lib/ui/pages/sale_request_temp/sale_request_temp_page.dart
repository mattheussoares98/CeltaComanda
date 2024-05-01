import 'package:provider/provider.dart';

import '../../../presentation/presenters/presenters.dart';
import '../pages.dart';
import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';

class SaleRequestTempPage extends StatefulWidget {
  const SaleRequestTempPage({super.key});

  @override
  State<SaleRequestTempPage> createState() => _SaleRequestTempPageState();
}

class _SaleRequestTempPageState extends State<SaleRequestTempPage>
    with LoadingManager, UIErrorManager {
  @override
  Widget build(BuildContext context) {
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context);
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
                      context, saleRequestTempPresenter.isLoadingStream);
                  handleMainError(
                      context, saleRequestTempPresenter.mainErrorStream);

                  if (saleRequestTempPresenter
                          .saleRequestTemp?.Products.isNotEmpty ==
                      true) {
                    return ProductsItems(
                        saleRequestTempViewModel:
                            saleRequestTempPresenter.saleRequestTemp!);
                  }
                  return SearchDataByCommandNumber(
                    expansibleGroupsPresenter: expansibleGroupsPresenter,
                    printedProductsPresenter: printedProductsPresenter,
                    saleRequestTempPresenter: saleRequestTempPresenter,
                  );
                },
              ),
            ),
          ),
          if (saleRequestTempPresenter.saleRequestTemp?.Products.isNotEmpty ==
              true)
            const SaveSaleRequestButton(),
        ],
      ),
    );
  }
}
