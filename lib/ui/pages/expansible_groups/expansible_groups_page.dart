import 'package:provider/provider.dart';

import '../../../presentation/presenters/presenters.dart';
import '../../../ui/pages/pages.dart';
import '../../mixins/mixins.dart';

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
    GetxExpansibleGroupsPresenter presenter = Provider.of(context);
    GetxPrintedProductsPresenter printedProductsPresenter =
        Provider.of(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  handleLoading(context, presenter.isLoadingStream);
                  handleMainError(context, presenter.mainErrorStream);

                  if (presenter.expansibleGroups.isEmpty) {
                    return SearchDataByCommandNumber(
                      expansibleGroupsPresenter: presenter,
                      printedProductsPresenter: printedProductsPresenter,
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
