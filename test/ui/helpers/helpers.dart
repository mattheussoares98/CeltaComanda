import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../mocks/mocks.dart';

Widget makePage({required String path, required Widget Function() page}) {
  final allPages = [
    GetPage(
      name: PageRoutes.products,
      page: () => ProductsPage(
        ProductsPresenterSpy(),
      ),
    ),
    GetPage(
      name: PageRoutes.productDetails,
      page: () => ProductDetailsPage(
        ProductDetailsPresenterSpy(),
      ),
    ),
    GetPage(
      name: '/any_route',
      page: () => Scaffold(
        appBar: AppBar(title: const Text('any title')),
        body: const Text('fake page'),
      ),
    ),
    GetPage(
      name: PageRoutes.expansibleGroups,
      page: () => ExpansibleGroupsPage(ExpansibleGroupsPresenterSpy()),
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
      page: () => EnterpriseValidationPage(EnterpriseValidationPresenterSpy()),
    ),
  ];

  final index = allPages.indexWhere((element) => element.name == path);
  if (index != -1) {
    //precisa sobrescrever a página que já existe caso esteja tentando criar ela
    //novamente pra não dar erro nos testes
    allPages[index] = GetPage(
      name: path,
      page: page,
    );
  } else {
    allPages.add(GetPage(
      name: path,
      page: page,
    ));
  }

  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => GetxCartPresenter(),
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
