import 'package:clean_celta_mobile/ui/pages/expansible_groups/expansible_groups.dart';

import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpansibleGroupsPage extends StatelessWidget
    with KeyboardManager, LoadingManager, UIErrorManager, NavigationManager {
  final ExpansibleGroupsPresenter presenter;

  ExpansibleGroupsPage(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    presenter.getProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grupos expansíveis"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: const [
          CartIcon(),
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
