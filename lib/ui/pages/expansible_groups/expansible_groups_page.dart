import '../../components/components.dart';
import '../expansible_groups/expansible_groups.dart';

import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpansibleGroupsPage extends StatefulWidget {
  final ExpansibleGroupsPresenter presenter;

  const ExpansibleGroupsPage(this.presenter, {super.key});

  @override
  State<ExpansibleGroupsPage> createState() => _ExpansibleGroupsPageState();
}

class _ExpansibleGroupsPageState extends State<ExpansibleGroupsPage>
    with KeyboardManager, LoadingManager, UIErrorManager, NavigationManager {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grupos expansíveis"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: const [
          CartIcon(),
        ],
      ),
      body: SingleChildScrollView(
        primary: false,
        child: Builder(
          builder: (context) {
            handleLoading(context, widget.presenter.isLoadingStream);
            // handleMainError(context, widget.presenter.mainErrorStream);
            handleNavigation(widget.presenter.navigateToStream);

            widget.presenter.loadExpansibleGroups();
            return StreamBuilder<List<ExpansibleGroupsViewModel>>(
                stream: widget.presenter.expansibleGroupsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ReloadScreen(
                      error: '${snapshot.error}',
                      reload: widget.presenter.loadExpansibleGroups,
                    );
                  }
                  if (snapshot.hasData) {
                    return ListenableProvider(
                      create: (_) => widget.presenter,
                      child: GroupsItems(
                          expansibleGroupsViewModel: snapshot.data!),
                    );
                  }
                  return const SizedBox(height: 0);
                });
          },
        ),
      ),
    );
  }
}
