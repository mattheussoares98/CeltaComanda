import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components.dart';
import '../../helpers/helpers.dart';
import '../../pages/pages.dart';

class ServiceCharge extends StatefulWidget {
  final PrintedViewModel printed;
  final Future<void> Function() loadPrintedAgain;
  final bool validateUserAndPassword;
  final bool showRemoveServiceChargeButton;
  final int commandNumber;
  const ServiceCharge({
    required this.printed,
    required this.loadPrintedAgain,
    required this.validateUserAndPassword,
    required this.showRemoveServiceChargeButton,
    required this.commandNumber,
    super.key,
  });

  @override
  State<ServiceCharge> createState() => _ServiceChargeState();
}

class _ServiceChargeState extends State<ServiceCharge> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    userController.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
  }

  Future<void> removeCharge(
    PrintedProductsPresenter printedProductsPresenter,
    CancelProductsPresenter cancelProductsPresenter,
  ) async {
    bool? isValid;

    if (widget.validateUserAndPassword) {
      isValid = formKey.currentState?.validate();
    } else {
      isValid = true;
    }

    if (isValid == true) {
      if (widget.validateUserAndPassword) {
        Navigator.of(context).pop();
      }
      await printedProductsPresenter.removeServiceCharge(
        validateUserAndPassword: widget.validateUserAndPassword,
        userPersonalizedCode: userController.text.toInt(),
        password: passwordController.text,
        commandNumber: widget.commandNumber.toString(),
        printed: widget.printed,
      );
      if (widget.validateUserAndPassword) {
        await cancelProductsPresenter.loadProducts(widget.commandNumber);
      } else {
        await widget.loadPrintedAgain();
      }
    }
  }

  void openRemoveServiceChargeDialog(
    PrintedProductsPresenter printedProductsPresenter,
    CancelProductsPresenter cancelProductsPresenter,
  ) {
    if (widget.validateUserAndPassword == false) {
      notificationDialog(
          context: context,
          titleMessage: R.string.removeServiceCharge,
          content: null,
          showCancelAndConfirmMessage: true,
          onPress: () async {
            await removeCharge(
                printedProductsPresenter, cancelProductsPresenter);
          });
      return;
    }
    userController.clear();
    passwordController.clear();
    notificationDialog(
      context: context,
      titleMessage: R.string.removeServiceCharge,
      showCancelAndConfirmMessage: false,
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    controller: userController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (value) {
                      if (FocusScope.of(context).canRequestFocus) {
                        FocusScope.of(
                                NavigatorKey.navigatorKey.currentState!.context)
                            .requestFocus(passwordFocusNode);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return R.string.msgWriteUserCode;
                      }
                      return null;
                    },
                    decoration: formFieldDecoration(
                      context: context,
                      hintText: R.string.userCode,
                      labelText: R.string.userCode,
                      errorText: null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    onFieldSubmitted: (value) async {
                      await removeCharge(
                          printedProductsPresenter, cancelProductsPresenter);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return R.string.msgWritePassword;
                      }
                      return null;
                    },
                    decoration: formFieldDecoration(
                      context: context,
                      hintText: R.string.password,
                      labelText: R.string.password,
                      errorText: null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await removeCharge(
                          printedProductsPresenter, cancelProductsPresenter);
                    },
                    child: Text(
                      R.string.confirm,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onPress: () async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    CancelProductsPresenter cancelProductsPresenter =
        Provider.of(context, listen: false);

    return GestureDetector(
      onLongPress: () async {
        openRemoveServiceChargeDialog(
            printedProductsPresenter, cancelProductsPresenter);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Text(
                R.string.serviceCharge,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: getStringSize(context)),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    printedProductsPresenter
                        .getServiceChargeValue(widget.printed)
                        .toString()
                        .toBrazilianNumber()
                        .addBrazilianCoin(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getStringSize(context),
                    ),
                  ),
                  if (widget.showRemoveServiceChargeButton)
                    InkWell(
                      onTap: () {
                        openRemoveServiceChargeDialog(
                            printedProductsPresenter, cancelProductsPresenter);
                      },
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              R.string.removeServiceCharge,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: getStringSize(context),
                              ),
                            ),
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
