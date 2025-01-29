import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../mixins/mixins.dart';
import '../pages.dart';

class MenuPage extends StatefulWidget {
  final bool? isFixedCommandNumber;
  const MenuPage(
    this.isFixedCommandNumber, {
    super.key,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  int indexOfSelectedProductCommentIcon = -1;
  final commentTextController = TextEditingController();

  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    if (!_isLoaded && menuPresenter.loadedMenu.isEmpty) {
      _isLoaded = true;
      Future.delayed(
        Duration.zero,
        () async {
          await cartPresenter.getLocalCartProductsData();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription = handleLoading(context, menuPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, menuPresenter.mainErrorStream);

    return Scaffold(
      body: Column(
        children: [
          TextButton(
              onPressed: () async {
                await menuPresenter.loadAllImages(homePresenter);
              },
              child: Text("Load All Images")),
          Expanded(
            child: StreamBuilder<
                List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>>(
              stream: menuPresenter.menuStream,
              builder: (context, snapshot) {
                if (menuPresenter.loadedMenu.isEmpty) {
                  return const LoadMenuButton();
                } else {
                  return StreamBuilder<int>(
                      stream: menuPresenter.indexOfSelectedGroupStream,
                      builder: (context, selectedGroupIndex) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: GroupsSubgroupsAndProducts(
                            selectedIndex: selectedGroupIndex.data,
                          ),
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
