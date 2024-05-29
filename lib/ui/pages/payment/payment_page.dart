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
    ExpansibleGroupsPresenter expansibleGroupsPresenter = Provider.of(context);
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Scaffold(
      drawer: drawer(
        context: context,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        homePresenter: homePresenter,
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5F8),
        actions: [
          SearchCommandIcon(loadCommandData: () async {
            await expansibleGroupsPresenter.loadCommandData(
              commandNumber: homePresenter.commandNumber!,
              printedProductsPresenter: printedProductsPresenter,
              saleRequestTempPresenter: saleRequestTempPresenter,
              expansibleGroupsPresenter: expansibleGroupsPresenter,
              homePresenter: homePresenter,
            );
          })
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FittedBox(
              child: Text(
                "Produtos",
                style: TextStyle(fontSize: 20),
              ),
            ),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  loadingSubscription?.cancel();
                  mainErrorSubscription?.cancel();

                  loadingSubscription = handleLoading(
                      context, expansibleGroupsPresenter.isLoadingStream);
                  mainErrorSubscription = handleMainError(
                      context, expansibleGroupsPresenter.mainErrorStream);

                  if (printedProductsPresenter
                          .printedProducts?.Products.isEmpty ==
                      true) {
                    return SearchDataByCommandNumber(
                      expansibleGroupsPresenter: expansibleGroupsPresenter,
                      printedProductsPresenter: printedProductsPresenter,
                      saleRequestTempPresenter: saleRequestTempPresenter,
                      homePresenter: homePresenter,
                      emptyMessage: homePresenter.commandNumber == null
                          ? "Consulte alguma comanda para conseguir visualizar os produtos/combos e adicionar na comanda"
                          : "O pagamento fica disponível somente quando há produtos confirmados na comanda selecionada",
                      loadCommandData: () async {
                        await expansibleGroupsPresenter.loadCommandData(
                          commandNumber: homePresenter.commandNumber!,
                          printedProductsPresenter: printedProductsPresenter,
                          saleRequestTempPresenter: saleRequestTempPresenter,
                          expansibleGroupsPresenter: expansibleGroupsPresenter,
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
