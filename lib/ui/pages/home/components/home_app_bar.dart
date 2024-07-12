import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';
import 'components.dart';

PreferredSize homeAppBar({
  required HomePresenter homePresenter,
  required CartPresenter cartPresenter,
  required MenuPresenter menuPresenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required BuildContext context,
  required GlobalKey<ScaffoldState> scaffoldKey,
  required int currentIndex,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(40),
    child: AppBar(
      leading: FittedBox(
        child: Row(
          children: [
            if (homePresenter.isFixedCommandNumber != true)
              IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
          ],
        ),
      ),
      actions: [
        if (currentIndex == 2)
          SearchCommandIcon(
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
              printedProductsPresenter.updateCanCancelProducts(false);
            },
          )
      ],
      backgroundColor: const Color(0xFFF1F5F8),
      title: TitleAppbar(
          showLoadMenuAgain: currentIndex == 0,
          loadMenuAgain: () async {
            await menuPresenter.getGroupsAndProducts("001");
          },
          openDrawer: () {
            scaffoldKey.currentState?.openDrawer();
          }),
    ),
  );
}
