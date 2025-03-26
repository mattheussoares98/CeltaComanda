import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ConfirmPayment extends StatelessWidget {
  final TextEditingController passwordController;
  final CustomerViewModel customer;
  final GlobalKey<FormState> passwordKey;
  final TextEditingController cpfCnpjController;
  final GlobalKey<FormState> cpfCnpjKey;

  const ConfirmPayment({
    required this.customer,
    required this.passwordController,
    required this.passwordKey,
    required this.cpfCnpjController,
    required this.cpfCnpjKey,
    super.key,
  });

  Future<void> finish({
    required HomePresenter homePresenter,
    required PaymentPresenter paymentPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required BuildContext context,
  }) async {
    await paymentPresenter.finishSaleRequestByCovenant(
      customerPassword: passwordController.text,
      homePresenter: homePresenter,
      printedProductsPresenter: printedProductsPresenter,
      showErrorMessageReturnedByBs: (error) {
        snackBarMessage(
          context,
          error,
          backgroundColor: Colors.red,
        );
      },
      showSuccessAndCloseUntilHomePage: () {
        Navigator.of(context).popUntil(
          (route) => route.isFirst,
        );
        snackBarMessage(
          context,
          R.string.liquidateCommandSucceeds,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        );
      },
    );
  }

  void requestPassword({
    required HomePresenter homePresenter,
    required PaymentPresenter paymentPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required BuildContext context,
  }) {
    passwordController.clear();
    notificationDialog(
        closeDialogOnConfirmPress: false,
        context: context,
        titleMessage: R.string.password,
        cancelMessage: R.string.cancel,
        confirmMessage: R.string.confirm,
        canPop: false,
        content: Form(
          key: passwordKey,
          child: TextFormField(
            controller: passwordController,
            autofocus: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: true,
            onChanged: paymentPresenter.changeCpfCnpj,
            decoration: formFieldDecoration(
              context: context,
              hintText: R.string.password,
              labelText: R.string.password,
              errorText: null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return R.string.msgWritePassword;
              }
              return null;
            },
            onFieldSubmitted: (_) async {
              if (passwordKey.currentState?.validate() != true) return;
              Navigator.of(context).pop();
              await finish(
                homePresenter: homePresenter,
                paymentPresenter: paymentPresenter,
                printedProductsPresenter: printedProductsPresenter,
                context: context,
              );
            },
          ),
        ),
        onPress: () async {
          if (passwordKey.currentState?.validate() != true) return;
          Navigator.of(context).pop();
          await finish(
            homePresenter: homePresenter,
            paymentPresenter: paymentPresenter,
            printedProductsPresenter: printedProductsPresenter,
            context: context,
          );
        });
  }

  Future<void> requestCpfOrCnpj({
    required HomePresenter homePresenter,
    required PaymentPresenter paymentPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required BuildContext context,
  }) async {
    Future.delayed(Duration.zero, () {
      cpfCnpjKey.currentState?.validate();
    });

    await notificationDialog(
        context: context,
        titleMessage: R.string.cpfCnpj,
        cancelMessage: R.string.jump,
        confirmMessage: R.string.confirm,
        closeDialogOnConfirmPress: false,
        onCancelPress: () async {
          cpfCnpjController.clear();
        },
        canPop: false,
        content: Form(
          key: cpfCnpjKey,
          child: TextFormField(
            controller: cpfCnpjController,
            autofocus: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [LengthLimitingTextInputFormatter(14)],
            decoration: formFieldDecoration(
              context: context,
              hintText: R.string.cpfCnpj,
              labelText: R.string.cpfCnpj,
              errorText: null,
            ),
            validator: (value) {
              if (value == null || (value.length != 11 && value.length != 14)) {
                return R.string.msgInvalidCpfCnpj;
              } else if (value.length == 11 && CPFValidator.isValid(value)) {
                return null;
              } else if (value.length == 14 && CNPJValidator.isValid(value)) {
                return null;
              }

              return R.string.msgInvalidCpfCnpj;
            },
            onFieldSubmitted: (_) async {
              if (cpfCnpjKey.currentState?.validate() != true) return;
              Navigator.of(context).pop();
            },
          ),
        ),
        onPress: () async {
          if (cpfCnpjKey.currentState?.validate() != true) return;
          Navigator.of(context).pop();
        });
  }

  @override
  Widget build(BuildContext context) {
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: paymentPresenter.selectedCustomer?.customer.Code == null
          ? null
          : () async {
              await requestCpfOrCnpj(
                homePresenter: homePresenter,
                paymentPresenter: paymentPresenter,
                printedProductsPresenter: printedProductsPresenter,
                context: context,
              );

              if (customer.HasPassword == "true") {
                requestPassword(
                  homePresenter: homePresenter,
                  paymentPresenter: paymentPresenter,
                  printedProductsPresenter: printedProductsPresenter,
                  context: context,
                );
              } else {
                await finish(
                  homePresenter: homePresenter,
                  paymentPresenter: paymentPresenter,
                  printedProductsPresenter: printedProductsPresenter,
                  context: context,
                );
              }
            },
      child: Text(
        R.string.liquidateCommand.toUpperCase(),
      ),
    );
  }
}
