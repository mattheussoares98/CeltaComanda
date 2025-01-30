import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

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
    HomePresenter homePresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription = handleLoading(context, menuPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, menuPresenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text(R.string.productsSchedules)),
        actions: [
          IconButton(
            onPressed: () async {
              await menuPresenter.getGroupsAndProducts(
                commandNumber:
                    homePresenter.commandEntity!.commandNumber ?? "001",
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
                homePresenter: homePresenter,
                isValidatingNeedUpdateAgain: false,
              );
              setState(() {});
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async {
            await menuPresenter.getGroupsAndProducts(
              commandNumber:
                  homePresenter.commandEntity!.commandNumber ?? "001",
              expansibleGroupFromProductPresenter:
                  expansibleGroupFromProductPresenter,
              homePresenter: homePresenter,
              isValidatingNeedUpdateAgain: false,
            );
            setState(() {});
          },
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: menuPresenter.loadedMenu.length,
            itemBuilder: (context, groupIndex) {
              final group = menuPresenter.loadedMenu
                  .map((element) => element.keys.first)
                  .toList()[groupIndex];
              final productsOfGroup =
                  menuPresenter.loadedMenu[groupIndex].values.first;
              productsOfGroup.sort((a, b) => a.Name.compareTo(b.Name));

              return Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).secondaryHeaderColor,
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ExpansibleGroupScheduleItem(
                        expansibleGroup: group,
                        callSetSate: () => setState(() {}),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: ProductsSchedulesItems(
                          products: productsOfGroup,
                          expansibleGroup: group,
                          callSetState: () => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
