import '../expansible_groups/expansible_groups.dart';

import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpansibleGroupsPage extends StatelessWidget
    with KeyboardManager, LoadingManager, UIErrorManager, NavigationManager {
  final ExpansibleGroupsPresenter presenter;

  ExpansibleGroupsPage(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    presenter.loadExpansibleGroups();

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

          return StreamBuilder<List<ExpansibleGroupsViewModel>>(
              stream: presenter.expansibleGroupsStream,
              builder: (context, snapshot) {
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
                                  presenter.loadExpansibleGroups();
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
              });
        },
      ),
    );
  }
}
