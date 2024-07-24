import 'package:flutter/material.dart';

import '../../pages.dart';

PreferredSize homeAppBar({
  required HomePresenter homePresenter,
  required BuildContext context,
  required GlobalKey<ScaffoldState> scaffoldKey,
  required CartPresenter cartPresenter,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(40),
    child: AppBar(
      actions: [
        Stack(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder()),
              onPressed: () {
                openCartPageDialog(context);
              },
              label: const Center(
                child: Text(
                  "CARRINHO",
                ),
              ),
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
            Positioned(
              top: 2,
              left: 5,
              child: CircleAvatar(
                backgroundColor: Colors.black,
                maxRadius: 8,
                minRadius: 8,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      cartPresenter.cartProducts.length.toString(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
      title: TitleAppbar(openDrawer: () {
        scaffoldKey.currentState?.openDrawer();
      }),
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
            const EnterpriseLogoImage(),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF1F5F8),
    ),
  );
}
