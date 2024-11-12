import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';

class SchedulesPage extends StatelessWidget {
  const SchedulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: menuPresenter.loadedMenu.length,
          itemBuilder: (context, groupIndex) {
            final group = menuPresenter.loadedMenu
                .map((element) => element.keys.first)
                .toList()[groupIndex];
            final productsOfGroup =
                menuPresenter.loadedMenu[groupIndex].values.first;
            return Column(
              children: [
                Text(group.Name),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: productsOfGroup.length,
                  itemBuilder: (context, productIndex) {
                    final product = productsOfGroup[productIndex];
                    return Text(product.Name);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
