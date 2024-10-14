import 'package:flutter/material.dart';

import '../components.dart';

class DrawerItems extends StatelessWidget implements PreferredSizeWidget {
  const DrawerItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset(
                "lib/ui/assets/images/logoCeltaTransparente.png",
                fit: BoxFit.cover,
              ),
            ),
            const SupportItemDrawer(),
            const TableConfigurationsItemDrawer(),
            const LogoutItemDrawer(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => throw UnimplementedError();
}
