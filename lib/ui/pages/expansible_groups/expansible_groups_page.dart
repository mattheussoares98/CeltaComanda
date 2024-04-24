import 'package:provider/provider.dart';

import '../../../presentation/presenters/presenters.dart';
import '../../components/components.dart';
import '../../mixins/mixins.dart';
import '../expansible_groups/expansible_groups.dart';

import 'package:flutter/material.dart';

class ExpansibleGroupsPage extends StatefulWidget {
  const ExpansibleGroupsPage({super.key});

  @override
  State<ExpansibleGroupsPage> createState() => _ExpansibleGroupsPageState();
}

class _ExpansibleGroupsPageState extends State<ExpansibleGroupsPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<GetxExpansibleGroupsPresenter>(context);
    return Scaffold(
      drawer: drawer(context: context, presenter: presenter),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5F8),
        title: const Text("Grupos de comida"),
        actions: [
          CartIcon(goToCartPage: presenter.goToCartPage),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  handleLoading(context, presenter.isLoadingStream);
                  handleMainError(context, presenter.mainErrorStream);

                  if (presenter.expansibleGroups.isEmpty) {
                    return InsertCommandNumber(
                      presenter: presenter,
                    );
                  }

                  return GroupItems(
                    expansibleGroupsViewModel: presenter.expansibleGroups,
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
