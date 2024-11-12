import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class CancelProductsPage extends StatefulWidget {
  const CancelProductsPage({
    super.key,
  });

  @override
  State<CancelProductsPage> createState() => _CancelProductsPageState();
}

class _CancelProductsPageState extends State<CancelProductsPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  int? selectedCommandInDropDown;

  @override
  dispose() {
    super.dispose();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    CancelProductsPresenter cancelProductsPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription =
        handleLoading(context, cancelProductsPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, cancelProductsPresenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.cancel),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SelectCommandDropDown(
            selectedCommandInDropDown: selectedCommandInDropDown,
            updateSelectedCommandInDropDown: (value) {
              setState(() {
                selectedCommandInDropDown = value;
              });
            },
          ),
          StreamBuilder<PrintedViewModel?>(
              stream: cancelProductsPresenter.printedProducts,
              builder: (context, snapshot) {
                if (selectedCommandInDropDown != null &&
                    snapshot.data == null) {
                  return Text(
                    R.string.emptyTable,
                    style: TextStyle(
                      fontSize: getStringSize(context),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                if (snapshot.data == null) {
                  return SizedBox();
                }

                return Expanded(
                  child: Column(
                    children: [
                      CancelProductsItems(
                        selectedCommandInDropDown: selectedCommandInDropDown,
                        printed: snapshot.data!,
                      ),
                      RequestSummary(
                          requestUserAndPassword: false,
                          printed: snapshot.data!,
                          commandNumber: selectedCommandInDropDown!,
                          loadPrintedAgain: () async {
                            await cancelProductsPresenter
                                .loadProducts(selectedCommandInDropDown!);
                          }),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
