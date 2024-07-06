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
      name: PageRoutes.products,
      page: () => const ProductsPage(),
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
      page: () => EnterpriseValidationPage(EnterpriseValidationPresenterSpy()),
    ),
    GetPage(
      name: PageRoutes.printedProducts,
      page: () => const PrintedProductsPage(null),
    ),
    GetPage(
      name: PageRoutes.home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: PageRoutes.productComposition,
      page: () => const ProductCompositionPage(),
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
      ListenableProvider<ProductsPresenter>(
        create: (_) => ProductsPresenterSpy(),
      ),
      ListenableProvider<ProductCompositionPresenter>(
        create: (_) => ProductCompositionPresenterSpy(),
      ),
      ListenableProvider<CommentsPresenter>(
        create: (_) => CommentsPresenterSpy(),
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
