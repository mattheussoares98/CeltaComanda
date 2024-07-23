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
