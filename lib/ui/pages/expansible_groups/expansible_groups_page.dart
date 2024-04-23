import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:provider/provider.dart';

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
    final expansibleGroupsPresenter =
        Provider.of<GetxExpansibleGroupsPresenter>(context);

    return Scaffold(
      drawer: drawer(context: context, presenter: expansibleGroupsPresenter),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5F8),
        title: const Text("Grupos de comida"),
        actions: [
          CartIcon(goToCartPage: expansibleGroupsPresenter.goToCartPage),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  handleLoading(
                      context, expansibleGroupsPresenter.isLoadingStream);
                  handleMainError(
                      context, expansibleGroupsPresenter.mainErrorStream);

                  if (expansibleGroupsPresenter.expansibleGroups.isEmpty) {
                    return InsertCommandNumber(
                      presenter: expansibleGroupsPresenter,
                    );
                  }

                  return GroupItems(
                    expansibleGroupsViewModel:
                        expansibleGroupsPresenter.expansibleGroups,
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
