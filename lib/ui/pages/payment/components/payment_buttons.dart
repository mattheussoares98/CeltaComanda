import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../../main/builders/builders.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PaymentButtons extends StatelessWidget {
  final TextEditingController paymentController;
  final GlobalKey<FormState> formKey;
  const PaymentButtons({
    required this.paymentController,
    required this.formKey,
    super.key,
  });

  void showSuccessAndCloseUntilHomePage(BuildContext context) {
    snackBarMessage(context, R.string.liquidateCommandSucceeds);
    Navigator.of(NavigatorKey.key.currentState!.context)
        .popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    Future<void> callPayment(PaymentMode paymentMode) async {
      bool? isValid = formKey.currentState?.validate();
      if (isValid == true) {
        await paymentPresenter.callPayment(
          longAmountValue: paymentController.text.toDouble(),
          portionQuantity: 1,
          paymentMode: paymentMode,
          homePresenter: homePresenter,
          printedProductsPresenter: printedProductsPresenter,
          showSuccessAndCloseUntilHomePage: () =>
              showSuccessAndCloseUntilHomePage(context),
          showErrorMessageReturnedByBs: (error) {
            snackBarMessage(
              context,
              error,
              backgroundColor: Colors.red,
            );
          },
        );
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (homePresenter.isGeneratingVersionToRede ||
            homePresenter.isGeneratingVersionToGetNet ||
            homePresenter.isGeneratingVersionToCielo)
          Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await callPayment(PaymentMode.pix);
                },
                child: Text(
                  "PIX",
                  style: _buttonStyle(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  onPressed: () async {
                    await callPayment(PaymentMode.debit);
                  },
                  child: Text(
                    R.string.debit.toUpperCase(),
                    style: _buttonStyle(context),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  onPressed: () async {
                    await callPayment(PaymentMode.credit);
                  },
                  child: Text(
                    R.string.cashCredit.toUpperCase(),
                    style: _buttonStyle(context),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  onPressed: () async {
                    await callPayment(PaymentMode.voucher);
                  },
                  child: Text(
                    R.string.voucher.toUpperCase(),
                    style: _buttonStyle(context),
                  ),
                ),
              ),
            ],
          ),
        if (EnterpriseBuilder.entity?.useCovenant == true)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ElevatedButton(
              onPressed: () {
                paymentPresenter.goToCovenantPage();
              },
              child: Text(
                R.string.covenant.toUpperCase(),
                style: _buttonStyle(context),
              ),
            ),
          ),
      ],
    );
  }
}

TextStyle _buttonStyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: StringSize.size,
    );
