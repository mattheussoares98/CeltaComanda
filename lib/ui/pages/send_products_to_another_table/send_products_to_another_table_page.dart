import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class SendProductsToAnotherTablePage extends StatefulWidget {
  const SendProductsToAnotherTablePage({super.key});

  @override
  State<SendProductsToAnotherTablePage> createState() =>
      _SendProductsToAnotherTablePageState();
}

class _SendProductsToAnotherTablePageState
    extends State<SendProductsToAnotherTablePage>
    with LoadingManager, UIErrorManager {
  int? selectedOriginCommand;
  int? selectedDestinyCommand;
  final formKey = GlobalKey<FormState>();
  bool tableIsEmpty = true;
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    SendProductsToAnotherTablePresenter sendProductsToAnotherTablePresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription = handleLoading(
      context,
      sendProductsToAnotherTablePresenter.isLoadingStream,
    );
    mainErrorSubscription = handleMainError(
      context,
      sendProductsToAnotherTablePresenter.mainErrorStream,
    );

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(R.string.sendOneOrMoreProductsToAnotherTable),
        ),
      ),
      body: Form(
        key: formKey,
        child: StreamBuilder<PrintedViewModel?>(
            stream: sendProductsToAnotherTablePresenter.printedProducts,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Row(
                    children: [
                      ReloadProductsIconButton(
                        selectedOriginCommand: selectedOriginCommand,
                      ),
                      Expanded(
                        child: OriginSelectTableDropdown(
                          selectedOriginCommand: selectedOriginCommand,
                          updateSelectedCommandInDropDown: (value) async {
                            setState(() {
                              selectedOriginCommand = value;
                            });
                            await sendProductsToAnotherTablePresenter
                                .loadProducts(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: DestinySelectTableDropdown(
                          selectedOriginCommand: selectedOriginCommand,
                          selectedDestinyCommand: selectedDestinyCommand,
                          updateSelectedCommandInDropDown: (value) {
                            setState(() {
                              selectedDestinyCommand = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: LoadedProductsItems(
                      printedViewModel: snapshot.data,
                      callSetState: () {
                        setState(() {});
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SelectOrUnselectAllProducts(
                        printedViewModel: snapshot.data,
                        callSetState: () {
                          setState(() {});
                        },
                      ),
                      ConfirmButton(
                        formKey: formKey,
                        oldPersonalizedCode: selectedOriginCommand,
                        newPersonalizedCode: selectedDestinyCommand,
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
