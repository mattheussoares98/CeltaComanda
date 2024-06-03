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
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Scaffold(
      drawer: drawer(
        context: context,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
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
            SearchCommandIcon(loadCommandData: () async {
              await menuPresenter.loadCommandData(
                commandNumber: homePresenter.commandNumber!,
                printedProductsPresenter: printedProductsPresenter,
                saleRequestTempPresenter: saleRequestTempPresenter,
                menuPresenter: menuPresenter,
                homePresenter: homePresenter,
              );
            })
          ],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (homePresenter.commandNumber != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Comanda ${homePresenter.commandNumber!}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  loadingSubscription?.cancel();
                  mainErrorSubscription?.cancel();

                  loadingSubscription =
                      handleLoading(context, menuPresenter.isLoadingStream);
                  mainErrorSubscription =
                      handleMainError(context, menuPresenter.mainErrorStream);

                  if (printedProductsPresenter
                          .printedProducts?.Products.isEmpty ==
                      true) {
                    return SearchDataByCommandNumber(
                      menuPresenter: menuPresenter,
                      printedProductsPresenter: printedProductsPresenter,
                      saleRequestTempPresenter: saleRequestTempPresenter,
                      homePresenter: homePresenter,
                      emptyMessage: homePresenter.commandNumber == null
                          ? "Consulte alguma comanda para conseguir visualizar os produtos/combos e adicionar na comanda"
                          : "O pagamento fica disponível somente quando há produtos confirmados na comanda selecionada",
                      loadCommandData: () async {
                        await menuPresenter.loadCommandData(
                          commandNumber: homePresenter.commandNumber!,
                          printedProductsPresenter: printedProductsPresenter,
                          saleRequestTempPresenter: saleRequestTempPresenter,
                          menuPresenter: menuPresenter,
                          homePresenter: homePresenter,
                        );
                      },
                    );
                  }

                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("creditoavista"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("creditoparcelado"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("debito"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("pix"),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
