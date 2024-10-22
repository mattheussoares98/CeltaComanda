import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ConfirmPayment extends StatelessWidget {
  final TextEditingController passwordController;
  final CustomerViewModel customer;
  final GlobalKey<FormState> passwordKey;

  const ConfirmPayment({
    required this.customer,
    required this.passwordController,
    required this.passwordKey,
    super.key,
  });

  Future<void> _finishSaleRequestByCovenant({
    required CovenantPresenter covenantPresenter,
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required BuildContext context,
  }) async {
    await covenantPresenter.finishSaleRequestByCovenant(
      customerPassword: passwordController.text,
      homePresenter: homePresenter,
      printedProductsPresenter: printedProductsPresenter,
      showErrorMessageReturnedByBs: (error) {
        showAlertMessage(
          context,
          error,
          backgroundColor: Colors.red,
        );
      },
      closePagesUntilHomePage: () {
        Navigator.of(context).popUntil(
          (route) => route.isFirst,
        );
        showAlertMessage(
          context,
          R.string.liquidateCommandSucceeds,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CovenantPresenter covenantPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: covenantPresenter.selectedCovenant.containsKey(customer.Code)
          ? () async {
              if (customer.HasPassword == "false") {
                await _finishSaleRequestByCovenant(
                  covenantPresenter: covenantPresenter,
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
                              covenantPresenter: covenantPresenter,
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
                          covenantPresenter: covenantPresenter,
                          homePresenter: homePresenter,
                          printedProductsPresenter: printedProductsPresenter,
                          context: context,
                        );
                      }
                    });
              }
            }
          : null,
      child: Text(
        R.string.liquidateCommand.toUpperCase(),
      ),
    );
  }
}
