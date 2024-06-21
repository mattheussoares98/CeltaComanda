import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../mixins/mixins.dart';
import '../../components/components.dart';
import '../pages.dart';

class PaymentPage extends StatefulWidget {
  final PaymentPresenter paymentPresenter;
  const PaymentPage(
    this.paymentPresenter, {
    super.key,
  });

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
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Scaffold(
      drawer: drawer(
        context: context,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          backgroundColor: const Color(0xFFF1F5F8),
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          actions: [
            SearchCommandIcon(
              loadCommandData: () async {
                if (cartPresenter.isGeneratingVersionToRede) {
                  writeCommandNumber(
                    context: context,
                    action: OnWriteCommand.getPaymentAmmount,
                  );
                } else {
                  await widget.paymentPresenter.getTotalValue(
                    homePresenter: homePresenter,
                    writedCommandNumber: null,
                    cartPresenter: cartPresenter,
                  );
                }
                printedProductsPresenter.updateCanCancelProducts(false);
              },
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Builder(
          builder: (context) {
            loadingSubscription?.cancel();
            mainErrorSubscription?.cancel();

            loadingSubscription =
                handleLoading(context, widget.paymentPresenter.isLoadingStream);
            mainErrorSubscription = handleMainError(
                context, widget.paymentPresenter.mainErrorStream);

            return StreamBuilder<double?>(
              stream: widget.paymentPresenter.totalAmountValueStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SearchDataByCommandNumber(
                    homePresenter: homePresenter,
                    emptyMessage:
                        "Consulte alguma comanda para efetuar o pagamento dela",
                    loadCommandData: () async {
                      if (cartPresenter.isGeneratingVersionToRede) {
                        writeCommandNumber(
                          context: context,
                          action: OnWriteCommand.getPaymentAmmount,
                        );
                      } else {
                        await widget.paymentPresenter.getTotalValue(
                          homePresenter: homePresenter,
                          writedCommandNumber: null,
                          cartPresenter: cartPresenter,
                        );
                      }
                    },
                  );
                } else {
                  return SizedBox(
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
                          "Total: ${snapshot.data!.toString().toBrazilianNumber()}"
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
                            await widget.paymentPresenter.payWithCredit(
                              longAmountValue: snapshot.data!,
                              portionQuantity: 1,
                            );
                          },
                          child: const Text("Crédito a vista"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await widget.paymentPresenter.payWithCreditPortion(
                              longAmountValue: snapshot.data!,
                              portionQuantity: 2,
                            );
                          },
                          child: const Text("Crédito parcelado 2x"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await widget.paymentPresenter.payWithDebit(
                              longAmountValue: snapshot.data!,
                              portionQuantity: 1,
                            );
                          },
                          child: const Text("Débito"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await widget.paymentPresenter.payWithPix(
                              longAmountValue: snapshot.data!,
                              portionQuantity: 1,
                            );
                          },
                          child: const Text("PIX"),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
