import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';
import 'components.dart';

PreferredSize homeAppBar({
  required HomePresenter homePresenter,
  required CartPresenter cartPresenter,
  required MenuPresenter menuPresenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required CommentsPresenter commentsPresenter,
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
              if (homePresenter.isFixedCommandNumber) {
                await printedProductsPresenter.loadCommandData(
                  cartPresenter: cartPresenter,
                  menuPresenter: menuPresenter,
                  homePresenter: homePresenter,
                  clearPermissionToCancelProducts: true,
                  isRemovingProduct: false,
                  commentsPresenter: commentsPresenter,
                );
              } else {
                await menuPresenter.getGroupsAndProducts(
                  commandNumber: "001",
                  commentsPresenter: commentsPresenter,
                );
              }
            },
          )
      ],
      backgroundColor: const Color(0xFFF1F5F8),
      title: TitleAppbar(
          showLoadMenuAgain: currentIndex == 0,
          loadMenuAgain: () async {
            if (homePresenter.isFixedCommandNumber) {
              await printedProductsPresenter.loadCommandData(
                cartPresenter: cartPresenter,
                menuPresenter: menuPresenter,
                homePresenter: homePresenter,
                clearPermissionToCancelProducts: true,
                isRemovingProduct: false,
                commentsPresenter: commentsPresenter,
              );
            } else {
              await menuPresenter.getGroupsAndProducts(
                commandNumber: "001",
                commentsPresenter: commentsPresenter,
              );
            }
          },
          openDrawer: () {
            scaffoldKey.currentState?.openDrawer();
          }),
    ),
  );
}
