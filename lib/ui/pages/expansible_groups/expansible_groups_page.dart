import '../../components/components.dart';
import '../../mixins/mixins.dart';
import '../expansible_groups/expansible_groups.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpansibleGroupsPage extends StatefulWidget {
  final ExpansibleGroupsPresenter presenter;

  const ExpansibleGroupsPage(this.presenter, {super.key});

  @override
  State<ExpansibleGroupsPage> createState() => _ExpansibleGroupsPageState();
}

class _ExpansibleGroupsPageState extends State<ExpansibleGroupsPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      widget.presenter.loadExpansibleGroups();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context: context, presenter: widget.presenter),
      appBar: AppBar(
        title: const Text("Grupos expansíveis"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          CartIcon(goToCartPage: widget.presenter.goToCartPage),
        ],
      ),
      body: SingleChildScrollView(
        primary: false,
        child: Builder(
          builder: (context) {
            handleLoading(context, widget.presenter.isLoadingStream);

            return StreamBuilder<List<ExpansibleGroupsViewModel>>(
                stream: widget.presenter.expansibleGroupsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ReloadScreen(
                      error: '${snapshot.error}',
                      reload: () async =>
                          await widget.presenter.loadExpansibleGroups(),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListenableProvider(
                      create: (_) => widget.presenter,
                      child:
                          GroupItems(expansibleGroupsViewModel: snapshot.data!),
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
