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
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

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
      body: SingleChildScrollView(
        child: printedProductsPresenter.printedProducts == null ||
                printedProductsPresenter.printedProducts!.TotalLiquid
                        .toDouble() ==
                    0
            ? SearchDataByCommandNumber(
                homePresenter: homePresenter,
                emptyMessage: homePresenter.commandNumber != null
                    ? "Essa comanda não possui valores em aberto"
                    : "Consulte alguma comanda para efetuar o pagamento dela",
                loadCommandData: () async {
                  await paymentPresenter.getTotalValue(
                    homePresenter: homePresenter,
                    cartPresenter: cartPresenter,
                    printedProductsPresenter: printedProductsPresenter,
                    menuPresenter: menuPresenter,
                    commentsPresenter: commentsPresenter,
                  );
                },
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (homePresenter.commandNumber != null)
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Comanda ${homePresenter.commandNumber}",
                          style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Text(
                      "Total: ${printedProductsPresenter.printedProducts!.TotalLiquid.toDouble().toString().toBrazilianNumber()}"
                          .addBrazilianCoin(),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 20,
                      ),
                      child: Text(
                        "Selecione uma opção de pagamento abaixo",
                        style: TextStyle(
                          // color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await paymentPresenter.payWithCredit(
                          longAmountValue: printedProductsPresenter
                              .printedProducts!.TotalLiquid
                              .toDouble(),
                          portionQuantity: 1,
                        );
                      },
                      child: const Text("Crédito a vista"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await paymentPresenter.payWithCreditPortion(
                          longAmountValue: printedProductsPresenter
                              .printedProducts!.TotalLiquid
                              .toDouble(),
                          portionQuantity: 2,
                        );
                      },
                      child: const Text("Crédito parcelado 2x"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await paymentPresenter.payWithDebit(
                          longAmountValue: printedProductsPresenter
                              .printedProducts!.TotalLiquid
                              .toDouble(),
                          portionQuantity: 1,
                        );
                      },
                      child: const Text("Débito"),
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
                      child: const Text("PIX"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
