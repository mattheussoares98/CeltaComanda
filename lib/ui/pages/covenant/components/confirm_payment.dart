import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ConfirmPayment extends StatelessWidget {
  final TextEditingController passwordController;
  final CustomerViewModel customer;
  final GlobalKey<FormState> passwordKey;
  //TODO add option to add cpf or cnpj

  const ConfirmPayment({
    required this.customer,
    required this.passwordController,
    required this.passwordKey,
    super.key,
  });

  Future<void> _finishSaleRequestByCovenant({
    required HomePresenter homePresenter,
    required PaymentPresenter paymentPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required BuildContext context,
  }) async {
    await paymentPresenter.finishSaleRequestByCovenant(
      customerPassword: passwordController.text,
      homePresenter: homePresenter,
      printedProductsPresenter: printedProductsPresenter,
      cpfCnpj: null,
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
              if (customer.HasPassword == "false") {
                await _finishSaleRequestByCovenant(
                  paymentPresenter: paymentPresenter,
                  homePresenter: homePresenter,
                  printedProductsPresenter: printedProductsPresenter,
                  context: context,
                );
              } else {
                passwordController.clear();
                notificationDialog(
                    context: context,
                    titleMessage: R.string.password,
                    cancelMessage: R.string.cancel,
                    confirmMessage: R.string.confirm,
                    content: Form(
                      key: passwordKey,
                      child: TextFormField(
                        controller: passwordController,
                        autofocus: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: true,
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
                          bool? isValid = passwordKey.currentState?.validate();
                          if (isValid == true) {
                            Navigator.of(context).pop();
                            await _finishSaleRequestByCovenant(
                              paymentPresenter: paymentPresenter,
                              homePresenter: homePresenter,
                              printedProductsPresenter:
                                  printedProductsPresenter,
                              context: context,
                            );
                          }
                        },
                      ),
                    ),
                    onPress: () async {
                      bool? isValid = passwordKey.currentState?.validate();
                      if (isValid == true) {
                        await _finishSaleRequestByCovenant(
                          paymentPresenter: paymentPresenter,
                          homePresenter: homePresenter,
                          printedProductsPresenter: printedProductsPresenter,
                          context: context,
                        );
                      }
                    });
              }
            },
      child: Text(
        R.string.liquidateCommand.toUpperCase(),
      ),
    );
  }
}
