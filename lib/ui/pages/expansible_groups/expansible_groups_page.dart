import 'package:clean_celta_mobile/ui/pages/expansible_groups/expansible_groups.dart';

import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpansibleGroupsPage extends StatelessWidget
    with KeyboardManager, LoadingManager, UIErrorManager, NavigationManager {
  final ExpansibleGroupPresenter presenter;

  ExpansibleGroupsPage(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grupos expansíveis"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart_rounded,
              color: Colors.red,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 2.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          handleLoading(context, presenter.isLoadingStream);
          handleMainError(context, presenter.mainErrorStream);
          handleNavigation(presenter.navigateToStream, clear: true);

          return GestureDetector(
            onTap: () => hideKeyboard(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListenableProvider(
                    create: (_) => presenter,
                    child: Column(
                      children: <Widget>[
                        const Groups(),
                        TextButton(
                          onPressed: () {
                            presenter.getProducts();
                          },
                          child: const Text("Obter produtos"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
