import 'dart:async';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class PrintedProductsPage extends StatefulWidget {
  const PrintedProductsPage({
    super.key,
  });

  @override
  State<PrintedProductsPage> createState() => _PrintedProductsPageState();
}

class _PrintedProductsPageState extends State<PrintedProductsPage>
    with UIErrorManager, LoadingManager, AlertMessageManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? alertMessageSubscription;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController personalizedCodeController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    alertMessageSubscription?.cancel();
    personalizedCodeController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const totalPriceContainerHeight = 50.0;

    PrintedProductsPresenter printedProductsPresenter = Provider.of(context);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    alertMessageSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, printedProductsPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, printedProductsPresenter.mainErrorStream);
    alertMessageSubscription = handleAlertMessage(
        context, printedProductsPresenter.alertMessageStream);

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
          leading: IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          actions: [
            SearchCommandIcon(
              loadCommandData: () async {
                if (cartPresenter.isGeneratingVersionToRede) {
                  writeCommandNumber(
                    context: context,
                    action: OnWriteCommand.loadCommandData,
                  );
                } else {
                  await printedProductsPresenter.loadCommandData(
                    printedProductsPresenter: printedProductsPresenter,
                    cartPresenter: cartPresenter,
                    menuPresenter: menuPresenter,
                    homePresenter: homePresenter,
                    clearPermissionToCancelProducts: true,
                    isRemovingProduct: false,
                    commandNumber: "",
                  );
                }
                printedProductsPresenter.updateCanCancelProducts(false);
              },
            )
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
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: totalPriceContainerHeight),
            child: SingleChildScrollView(
              child: printedProductsPresenter.printedProducts != null
                  ? PrintedItem(
                      printed: printedProductsPresenter.printedProducts!,
                      formKey: formKey,
                      passwordController: passwordController,
                      personalizedCodeController: personalizedCodeController,
                    )
                  : SearchDataByCommandNumber(
                      homePresenter: homePresenter,
                      emptyMessage: homePresenter.commandNumber == null
                          ? "Consulte alguma comanda para visualizar os produtos solicitados"
                          : "Não há produtos solicitados nessa comanda",
                      loadCommandData: () async {
                        if (cartPresenter.isGeneratingVersionToRede) {
                          writeCommandNumber(
                            context: context,
                            action: OnWriteCommand.loadCommandData,
                          );
                        } else {
                          await printedProductsPresenter.loadCommandData(
                            printedProductsPresenter: printedProductsPresenter,
                            cartPresenter: cartPresenter,
                            menuPresenter: menuPresenter,
                            homePresenter: homePresenter,
                            clearPermissionToCancelProducts: true,
                            isRemovingProduct: false,
                            commandNumber: "",
                          );
                        }
                      },
                    ),
            ),
          ),
          if (printedProductsPresenter.printedProducts != null)
            Container(
              height: totalPriceContainerHeight,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: const Color.fromARGB(255, 220, 218, 218)),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Color(0x33000000),
                    offset: Offset(-3, -1),
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: RequestSummary(
                totalLiquid:
                    printedProductsPresenter.printedProducts!.TotalLiquid,
                comments: printedProductsPresenter.printedProducts!.Comments,
              ),
            ),
        ],
      ),
    );
  }
}
