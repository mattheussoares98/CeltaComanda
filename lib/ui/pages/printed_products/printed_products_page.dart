import 'dart:async';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../ui/helpers/helpers.dart';
import '../../components/components.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class PrintedProductsPage extends StatefulWidget {
  final bool? isFixedCommandNumber;
  const PrintedProductsPage(
    this.isFixedCommandNumber, {
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
      drawer: widget.isFixedCommandNumber == true
          ? null
          : drawer(
              context: context,
              menuPresenter: menuPresenter,
              printedProductsPresenter: printedProductsPresenter,
              cartPresenter: cartPresenter,
              homePresenter: homePresenter,
            ),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
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
                        itensPerLine: hasMinWidth(context) ? 3 : 2,
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
                              cartPresenter: cartPresenter,
                              menuPresenter: menuPresenter,
                              homePresenter: homePresenter,
                              clearPermissionToCancelProducts: true,
                              isRemovingProduct: false,
                              writedCommandNumberForRedeVersion: "",
                            );
                          }
                        },
                      ),
              ),
            ),
            if (printedProductsPresenter.printedProducts != null)
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: totalPriceContainerHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.only(bottom: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 220, 218, 218)),
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
                    comments:
                        printedProductsPresenter.printedProducts!.Comments,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
