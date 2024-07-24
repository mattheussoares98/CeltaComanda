import 'package:flutter/material.dart';

import '../../pages.dart';
import 'components.dart';

PreferredSize homeAppBar({
  required HomePresenter homePresenter,
  required BuildContext context,
  required GlobalKey<ScaffoldState> scaffoldKey,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(40),
    child: AppBar(
      actions: [
        ElevatedButton.icon(
          style:
              ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    insetPadding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1),
                    contentPadding: const EdgeInsets.all(0),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: CartPage(),
                      ),
                    ),
                  );
                });
          },
          label: const Center(
            child: Text(
              "CARRINHO",
            ),
          ),
          icon: const Icon(Icons.shopping_cart_outlined),
        )
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
