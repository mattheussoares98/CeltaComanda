import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../mocks/mocks.dart';

Widget makePage(
    {required String path,
    required Widget Function() page,
    dynamic arguments}) {
  final allPages = [
    GetPage(
      name: '/any_route',
      page: () => Scaffold(
        appBar: AppBar(title: const Text('any title')),
        body: const Text('fake page'),
      ),
    ),
    GetPage(
      name: PageRoutes.menus,
      page: () => const MenuPage(null),
    ),
    GetPage(
      name: PageRoutes.cart,
      page: () => const CartPage(),
    ),
    GetPage(
      name: PageRoutes.splash,
      page: () => SplashPage(presenter: SplashPresenterSpy()),
    ),
    GetPage(
      name: PageRoutes.enterpriseValidation,
      page: () => EnterpriseValidationPage(),
    ),
    GetPage(
      name: PageRoutes.printedProducts,
      page: () => const PrintedProductsPage(),
    ),
    GetPage(
      name: PageRoutes.home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: PageRoutes.insertProducts,
      page: () => const InsertProductsPage(),
    ),
    GetPage(
      name: PageRoutes.covenant,
      page: () => CovenantPage(),
    ),
  ];

  final index = allPages.indexWhere((element) => element.name == path);
  if (index != -1) {
    //precisa sobrescrever a página que já existe caso esteja tentando criar ela
    //novamente pra não dar erro nos testes
    allPages[index] = GetPage(
      name: path,
      page: page,
      arguments: arguments,
    );
  } else {
    allPages.add(GetPage(
      name: path,
      page: page,
      arguments: arguments,
    ));
  }

  return MultiProvider(
    providers: [
      ListenableProvider<MenuPresenter>(
        create: (_) => MenuPresenterSpy(),
      ),
      ChangeNotifierProvider<CartPresenter>(
        create: (_) => CartPresenterSpy(),
      ),
      ChangeNotifierProvider<PrintedProductsPresenter>(
        create: (_) => PrintedProductsPresenterSpy(),
      ),
      ChangeNotifierProvider<HomePresenter>(
        create: (_) => HomePresenterSpy(),
      ),
      ListenableProvider<InsertProductPresenter>(
        create: (_) => InsertProductsPresenterSpy(),
      ),
      ListenableProvider<ExpansibleGroupFromProductPresenter>(
        create: (_) => ExpansibleGroupFromProductPresenterSpy(),
      ),
      ListenableProvider<EnterprisePresenter>(
        create: (_) => EnterprisePresenterSpy(),
      ),
      ListenableProvider<CovenantPresenter>(
        create: (_) => CovenantPresenterSpy(),
      ),
      ListenableProvider<ConfigurationsPresenter>(
        create: (_) => ConfigurationsPresenterSpy(),
      ),
    ],
    child: GetMaterialApp(
      initialRoute: path,
      navigatorObservers: [Get.put<RouteObserver>(RouteObserver<PageRoute>())],
      getPages: allPages,
    ),
  );
}

String get currentRoute => Get.currentRoute;
