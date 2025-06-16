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
  final formKey = GlobalKey<FormState>();
  final formKeyOriginTable = GlobalKey<FormState>();
  bool tableIsEmpty = true;
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  final originCommandNumberController = TextEditingController();
  final destinyCommandNumberController = TextEditingController();
  final originFocusNode = FocusNode();
  final destinyFocusNode = FocusNode();

  @override
  dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    originCommandNumberController.dispose();
    destinyCommandNumberController.dispose();
    originFocusNode.dispose();
    destinyFocusNode.dispose();
  }

  void unfocus() {
    originFocusNode.unfocus();
    destinyFocusNode.unfocus();
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
          child: Text(R.string.sendProductsToAnotherTable),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                            child: Form(
                              key: formKeyOriginTable,
                              child: CommandField(
                                commandNumberController:
                                    originCommandNumberController,
                                hintText: R.string.msgOldTable,
                                labelText: R.string.msgOldTable,
                                focusNode: originFocusNode,
                                loadData: () async {
                                  bool? isValid = formKeyOriginTable
                                      .currentState
                                      ?.validate();

                                  if (isValid == true) {
                                    await sendProductsToAnotherTablePresenter
                                        .loadProducts(
                                            originCommandNumberController.text
                                                .toInt());
                                  }
                                  unfocus();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      CommandField(
                        commandNumberController: destinyCommandNumberController,
                        hintText: R.string.msgNewTable,
                        labelText: R.string.msgNewTable,
                        focusNode: destinyFocusNode,
                      ),
                      Expanded(
                        child: LoadedProductsItems(
                          printedViewModel: snapshot.data,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: ConfirmButton(
                          formKey: formKey,
                          originCommandNumberController:
                              originCommandNumberController,
                          destinyCommandNumberController:
                              destinyCommandNumberController,
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
