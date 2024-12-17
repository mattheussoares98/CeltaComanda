import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
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

  final originCommandNumberController = TextEditingController();
  final destinyCommandNumberController = TextEditingController();

  @override
  dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    originCommandNumberController.dispose();
    destinyCommandNumberController.dispose();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Form(
            key: formKey,
            child: StreamBuilder<PrintedViewModel?>(
                stream: sendProductsToAnotherTablePresenter.printedProducts,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CommandField(
                              commandNumberController:
                                  originCommandNumberController,
                              hintText: R.string.msgOldTable,
                              labelText: R.string.msgOldTable,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              bool? isValid = formKey.currentState?.validate();

                              if (isValid == true) {
                                await sendProductsToAnotherTablePresenter
                                    .loadProducts(originCommandNumberController
                                        .text
                                        .toInt());
                              }
                            },
                            icon: Icon(Icons.refresh),
                          ),
                        ],
                      ),
                      CommandField(
                        commandNumberController: destinyCommandNumberController,
                        hintText: R.string.msgNewTable,
                        labelText: R.string.msgNewTable,
                      ),
                      Expanded(
                        child: LoadedProductsItems(
                          printedViewModel: snapshot.data,
                          callSetState: () {
                            setState(() {});
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: SelectOrUnselectAllProducts(
                                printedViewModel: snapshot.data,
                                callSetState: () {
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ConfirmButton(
                                formKey: formKey,
                                originCommandNumberController:
                                    originCommandNumberController,
                                destinyCommandNumberController:
                                    destinyCommandNumberController,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
