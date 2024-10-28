import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class ServiceCharge extends StatefulWidget {
  const ServiceCharge({super.key});

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
    HomePresenter homePresenter,
  ) async {
    bool? isValid = formKey.currentState?.validate();

    if (isValid == true) {
      Navigator.of(context).pop();
      await printedProductsPresenter.removeServiceCharge(
        personalizedCode: userController.text.toInt(),
        password: passwordController.text,
        homePresenter: homePresenter,
      );
    }
  }

  void openRemoveServiceChargeDialog(
    PrintedProductsPresenter printedProductsPresenter,
    HomePresenter homePresenter,
  ) {
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
                          printedProductsPresenter, homePresenter);
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
                          printedProductsPresenter, homePresenter);
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
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return GestureDetector(
      onLongPress: () {
        openRemoveServiceChargeDialog(printedProductsPresenter, homePresenter);
      },
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
                  printedProductsPresenter.serviceChargeValue
                      .toDouble()
                      .toString()
                      .toBrazilianNumber()
                      .addBrazilianCoin(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getStringSize(context),
                  ),
                ),
                if (!homePresenter.isGeneratingVersionToTablet)
                  InkWell(
                    onTap: () {
                      openRemoveServiceChargeDialog(
                        printedProductsPresenter,
                        homePresenter,
                      );
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
    );
  }
}
