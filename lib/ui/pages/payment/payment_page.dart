import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../../components/components.dart';
import '../pages.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: true);
    HomePresenter homePresenter = Provider.of(context, listen: true);
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, paymentPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, paymentPresenter.mainErrorStream);

    return Scaffold(
      drawer: drawer(
        context: context,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      ),
      body: printedProductsPresenter.printedProducts == null ||
              printedProductsPresenter.printedProducts!.TotalLiquid
                      .toDouble() ==
                  0
          ? SearchDataByCommandNumber(
              homePresenter: homePresenter,
              emptyMessage: homePresenter.commandNumber != null
                  ? R.string.msgCommandDontHaveOpenValues
                  : R.string.msgSearchCommandToPay,
              loadCommandData: () async {
                await paymentPresenter.getTotalValue(
                  homePresenter: homePresenter,
                  cartPresenter: cartPresenter,
                  printedProductsPresenter: printedProductsPresenter,
                  menuPresenter: menuPresenter,
                  expansibleGroupFromProductPresenter: expansibleGroupFromProductPresenter,
                );
              },
            )
          : Center(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${R.string.total}: ${printedProductsPresenter.printedProducts!.TotalLiquid.toDouble().toString().toBrazilianNumber()}"
                            .addBrazilianCoin(),
                        style: TextStyle(
                          fontSize: getStringSize(context) * 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 20,
                        ),
                        child: Text(
                          R.string.selectPaymentOption,
                          style: TextStyle(
                            // color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            fontSize: getStringSize(context),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await paymentPresenter.payWithPix(
                            longAmountValue: printedProductsPresenter
                                .printedProducts!.TotalLiquid
                                .toDouble(),
                            portionQuantity: 1,
                          );
                        },
                        child: Text(
                          "PIX",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getStringSize(context),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 10),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     await paymentPresenter.payWithCreditPortion(
                      //       longAmountValue: printedProductsPresenter
                      //           .printedProducts!.TotalLiquid
                      //           .toDouble(),
                      //       portionQuantity: 2,
                      //     );
                      //   },
                      //   child: Text(
                      //     "Crédito parcelado 2x",
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: getStringSize(context),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await paymentPresenter.payWithDebit(
                            longAmountValue: printedProductsPresenter
                                .printedProducts!.TotalLiquid
                                .toDouble(),
                            portionQuantity: 1,
                          );
                        },
                        child: Text(
                          R.string.debit.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getStringSize(context),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await paymentPresenter.payWithCredit(
                            longAmountValue: printedProductsPresenter
                                .printedProducts!.TotalLiquid
                                .toDouble(),
                            portionQuantity: 1,
                          );
                        },
                        child: Text(
                          R.string.cashCredit.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getStringSize(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
