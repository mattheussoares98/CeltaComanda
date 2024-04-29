import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'package:clean_celta_mobile/main/factories/factories.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

Widget makePage(
    {required String path,
    required Widget Function() page,
    dynamic arguments}) {
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
      page: () => const ExpansibleGroupsPage(),
    ),
    GetPage(
      name: PageRoutes.saleRequestTemp,
      page: () => const SaleRequestTempPage(),
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
      page: () => const PrintedProductsPage(),
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
      ChangeNotifierProvider<GetxExpansibleGroupsPresenter>(
        create: (_) => GetxExpansibleGroupsPresenter(
          loadExpansibleGroups: LoadExpansibleGroupsSpy(),
          localEnterpriseData: LocalEnterpriseDataSpy(),
          navigateTo: NavigateToSpy(),
        ),
      ),
      ChangeNotifierProvider<GetxSaleRequestTempPresenter>(
        create: (_) => GetxSaleRequestTempPresenter(
          loadSaleRequestTemp: makeRemoteLoadSaleRequestTemp(),
        ),
      ),
      ChangeNotifierProvider<GetxPrintedProductsPresenter>(
        create: (_) => GetxPrintedProductsPresenter(
          userValidations: UserValidationsSpy(),
          loadPrintedProducts: LoadPrintedProductsSpy(),
          removePrintedProduct: RemovePrintedProductSpy(),
        ),
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
