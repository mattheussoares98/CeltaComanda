import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../main/builders/builders.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

List<Widget> allButtons(BuildContext context) {
  ConfigurationsPresenter configurationsPresenter =
      Provider.of(context, listen: false);
  CartPresenter cartPresenter = Provider.of(context, listen: false);
  HomePresenter homePresenter = Provider.of(context, listen: false);
  PrintedProductsPresenter printedProductsPresenter =
      Provider.of(context, listen: false);
  MenuPresenter menuPresenter = Provider.of(context, listen: false);
  EnterprisePresenter enterprisePresenter = Provider.of(context, listen: false);

  return [
    _button(
        context: context,
        name: R.string.updateMenu,
        function: () {
          notificationDialog(
              context: context,
              titleMessage: R.string.updateMenu,
              content: Text(R.string.msgWantUpdateMenuInAllDevices),
              onPress: () async {
                final updated = await configurationsPresenter.loadMenuAgain();

                if (updated) {
                  snackBarMessage(
                      // ignore: use_build_context_synchronously
                      context,
                      R.string.msgSuccessUpdateMenuInAllDevices);
                }
              });
        }),
    _button(
        context: context,
        name: R.string.productsSchedules,
        function: () async {
          await configurationsPresenter.goToSchedulesPage();
        }),
    _button(
        context: context,
        name: R.string.cancelProductsOrRemoveServiceCharge,
        function: () async {
          await configurationsPresenter.goToCancelProductsPage();
        }),
    _button(
        context: context,
        name: R.string.tableConfigurations,
        function: () {
          notificationDialog(
              context: context,
              titleMessage: R.string.tableConfigurations,
              showCancelAndConfirmMessage: false,
              showCloseAction: true,
              showLargeDialog: true,
              content: CommandConfigurationsPage(),
              onPress: () async {});
        }),
    _button(
        context: context,
        name: R.string.doLogout,
        function: () {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            notificationDialog(
                context: context,
                titleMessage: cartPresenter.cartProducts.isNotEmpty
                    ? R.string.clearCart
                    : R.string.doLogout,
                content: Text(
                  cartPresenter.cartProducts.isNotEmpty
                      ? R.string.msgClearCartOnLogout
                      : R.string.msgWantDoLogout,
                  textAlign: TextAlign.center,
                ),
                onPress: () async {
                  cartPresenter.clearCart();
                  await homePresenter.doLogout(
                    printedProductsPresenter: printedProductsPresenter,
                    cartPresenter: cartPresenter,
                    menuPresenter: menuPresenter,
                    enterprisePresenter: enterprisePresenter,
                  );
                });
          });
        }),
    _button(
        context: context,
        name: R.string.liberateOrBlockTable,
        function: () {
          notificationDialog(
              context: context,
              titleMessage: R.string.liberateOrBlockTable,
              showCancelAndConfirmMessage: false,
              showCloseAction: true,
              showLargeDialog: true,
              content: SizedBox(
                child: BlockOrLiberateCommandPage(),
              ),
              onPress: () async {});
        }),
    if (!homePresenter.isGeneratingVersionToRede &&
        !homePresenter.isGeneratingVersionToGetNet)
      _button(
          context: context,
          name: R.string.reserveTable,
          function: () async {
            Navigator.of(NavigatorKey.navigatorKey.currentState!.context)
                .popUntil(
              (route) => route.isFirst,
            );

            await Future.delayed(Duration.zero, () {});

            showDialog(
                // ignore: use_build_context_synchronously
                context: context,
                builder: (context) {
                  return const ReserveTable();
                });
          }),
    _button(
        context: context,
        name: R.string.sendProductsToAnotherTable,
        function: () {
          notificationDialog(
              context: context,
              titleMessage: R.string.sendProductsToAnotherTable,
              showCancelAndConfirmMessage: false,
              showCloseAction: true,
              showLargeDialog: true,
              content: SizedBox(
                child: ChangeSaleRequestPersonalizedCodePage(),
              ),
              onPress: () async {});
        }),
  ];
}

ElevatedButton _button({
  required BuildContext context,
  required String name,
  required Function() function,
}) =>
    ElevatedButton(
      onPressed: function,
      child: Text(
        name,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(),
      ),
    );
