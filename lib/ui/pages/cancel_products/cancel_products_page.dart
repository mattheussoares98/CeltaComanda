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
  final commandNumberController = TextEditingController();
  bool searchedCommandData = false;

  @override
  dispose() {
    super.dispose();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    commandNumberController.dispose();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SearchCommandField(
                commandNumberController: commandNumberController,
                searchData: () async {
                  await cancelProductsPresenter.loadProducts(
                    commandNumberController.text.toInt(),
                  );
                  setState(() {
                    searchedCommandData = true;
                  });
                },
              ),
              StreamBuilder<PrintedViewModel?>(
                  stream: cancelProductsPresenter.printedProducts,
                  builder: (context, snapshot) {
                    if (searchedCommandData == true && snapshot.data == null) {
                      return Text(
                        R.string.emptyTable,
                        style: TextStyle(
                          fontSize: StringSize.size,
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
                            selectedCommandInDropDown:
                                commandNumberController.text.toInt(),
                            printed: snapshot.data!,
                          ),
                          RequestSummary(
                              showRemoveServiceChargeButton: true,
                              requestUserAndPassword: false,
                              printed: snapshot.data!,
                              commandNumber:
                                  commandNumberController.text.toInt(),
                              loadPrintedAgain: () async {
                                await cancelProductsPresenter.loadProducts(
                                    commandNumberController.text.toInt());
                              }),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
