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

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return GestureDetector(
      onLongPress: () {
        notificationDialog(
          context: context,
          titleMessage: "",
          showCancelAndConfirmMessage: false,
          content: Scaffold(
            backgroundColor: Colors.transparent,
            body: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
          onPress: () async {},
        );
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
            child: Text(
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
          ),
        ],
      ),
    );
  }
}
