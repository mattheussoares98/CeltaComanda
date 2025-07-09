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
  int? selectedGroupIndex;
  final scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    scrollController.dispose();
  }

  void updateSelectedGroupIndex(int groupIndex) {
    if (groupIndex == selectedGroupIndex) {
      setState(() {
        selectedGroupIndex = null;
      });
      scrollController.jumpTo(0);
    } else {
      setState(() {
        selectedGroupIndex = groupIndex;
      });
      scrollController.jumpTo(groupIndex * 45);
    }
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
                commandEntity: homePresenter.commandEntity,
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
                loadLocally: false,
              );
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await menuPresenter.getGroupsAndProducts(
            commandEntity: homePresenter.commandEntity,
            expansibleGroupFromProductPresenter:
                expansibleGroupFromProductPresenter,
            loadLocally: false,
          );
          setState(() {});
        },
        child: ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: menuPresenter.loadedMenu.length,
          itemBuilder: (context, groupIndex) {
            final group = menuPresenter.loadedMenu
                .map((element) => element.expansibleGroupsViewModel)
                .toList()[groupIndex];
            final productsOfGroup =
                menuPresenter.loadedMenu[groupIndex].productsViewModel;
            productsOfGroup.sort((a, b) => a.Name.compareTo(b.Name));

            return Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).secondaryHeaderColor,
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      updateSelectedGroupIndex(groupIndex);
                    },
                    child: ExpansibleGroupScheduleItem(
                      expansibleGroup: group,
                      callSetSate: setState,
                      updateSelectedGroupIndex: () {
                        updateSelectedGroupIndex(groupIndex);
                      },
                      groupIsSelected: groupIndex == selectedGroupIndex,
                    ),
                  ),
                  if (selectedGroupIndex == groupIndex)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: ProductsSchedulesItems(
                        products: productsOfGroup,
                        expansibleGroup: group,
                      ),
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
