import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFF1F5F8),
      title: TitleAppbar(loadMenuAgain: () async {
        await homePresenter.loadCommandData(
          menuPresenter: menuPresenter,
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          commentsPresenter: commentsPresenter,
        );
      }, openDrawer: () {
        scaffoldKey.currentState?.openDrawer();
      }),
    ),
  );
}
