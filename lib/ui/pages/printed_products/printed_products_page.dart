import 'dart:async';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../main/builders/builders.dart';
import '../../../presentation/presenters/presenters.dart';
import '../../components/components.dart';
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
    with UIErrorManager, LoadingManager, AlertMessageManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? homeLoadingSubscription;
  StreamSubscription? alertMessageSubscription;
  static bool isDialogShowing = false;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    homeLoadingSubscription?.cancel();
    alertMessageSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context);
    GetxExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context);
    GetxPrintedProductsPresenter printedProductsPresenter =
        Provider.of(context);
    GetxHomePresenter homePresenter = Provider.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  loadingSubscription = handleLoading(
                      context, printedProductsPresenter.isLoadingStream);
                  mainErrorSubscription = handleMainError(
                      context, printedProductsPresenter.mainErrorStream);
                  alertMessageSubscription = handleAlertMessage(
                      context, printedProductsPresenter.alertMessageStream);

                  homeLoadingSubscription =
                      homePresenter.isLoadingStream.listen((isLoading) async {
                    if (isLoading == true && !isDialogShowing) {
                      isDialogShowing = true;
                      showLoading(
                        NavigatorKey.navigatorKey.currentState?.context ??
                            context,
                      );
                    } else {
                      hideLoading(
                        NavigatorKey.navigatorKey.currentState?.context ??
                            context,
                      );
                      isDialogShowing = false;
                    }
                  });

                  if (printedProductsPresenter.printedProducts != null) {
                    return PrintedItem(
                      printed: printedProductsPresenter.printedProducts!,
                    );
                  }
                  return SearchDataByCommandNumber(
                    expansibleGroupsPresenter: expansibleGroupsPresenter,
                    printedProductsPresenter: printedProductsPresenter,
                    saleRequestTempPresenter: saleRequestTempPresenter,
                    homePresenter: homePresenter,
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
