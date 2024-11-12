import 'dart:async';

import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription = handleLoading(context, menuPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, menuPresenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.productsSchedules),
        actions: [
          IconButton(
            onPressed: () async {
              await menuPresenter.getGroupsAndProducts(
                commandNumber: "001",
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
              );
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
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
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      group.Name,
                      style: TextStyle(
                        fontSize: getStringSize(context),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: productsOfGroup.length,
                    itemBuilder: (context, productIndex) {
                      final product = productsOfGroup[productIndex];
                      return InkWell(
                        onTap: () {
                          notificationDialog(
                            context: context,
                            titleMessage: R.string.productsSchedules,
                            cancelMessage: R.string.cancel,
                            confirmMessage: R.string.confirm,
                            content: Column(
                              children: [
                                Text(product.Name),
                              ],
                            ),
                            onPress: () async {},
                          );
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          color: productIndex % 2 == 0
                              ? Theme.of(context)
                                  .primaryColorLight
                                  .withAlpha(50)
                              : Colors.white,
                          child: GestureDetector(
                            child: Row(
                              children: [
                                Expanded(child: Text(product.Name)),
                                Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
