import '../../components/components.dart';
import '../../mixins/mixins.dart';
import '../expansible_groups/expansible_groups.dart';

import 'package:flutter/material.dart';

class ExpansibleGroupsPage extends StatefulWidget {
  final ExpansibleGroupsPresenter presenter;

  const ExpansibleGroupsPage(this.presenter, {super.key});

  @override
  State<ExpansibleGroupsPage> createState() => _ExpansibleGroupsPageState();
}

class _ExpansibleGroupsPageState extends State<ExpansibleGroupsPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context: context, presenter: widget.presenter),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5F8),
        title: const Text("Grupos de comida"),
        actions: [
          CartIcon(goToCartPage: widget.presenter.goToCartPage),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  handleLoading(context, widget.presenter.isLoadingStream);
                  handleMainError(context, widget.presenter.mainErrorStream);

                  if (widget.presenter.expansibleGroups.isEmpty) {
                    return InsertCommandNumber(
                      presenter: widget.presenter,
                    );
                  }

                  return GroupItems(
                    expansibleGroupsViewModel:
                        widget.presenter.expansibleGroups,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
