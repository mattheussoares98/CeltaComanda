import 'package:provider/provider.dart';

import '../factories/factories.dart';

class Providers {
  Providers._();

  static final providers = [
    ChangeNotifierProvider(
      create: (_) => makeGetxCartPresenter(),
    ),
    ChangeNotifierProvider(
      create: (_) => makeGetxHomePresenter(),
    ),
    ChangeNotifierProvider(
      create: (_) => makeGetxPrintedProductsPresenter(),
    ),
    ListenableProvider(
      create: (_) => makeGetxCancelProductsPresenter(),
    ),
    ListenableProvider(
      create: (_) => makeGetxConfigurationsPresenter(),
    ),
    ListenableProvider(
      create: (_) => makeGetxEnterprisePresenter(),
    ),
    ListenableProvider(
      create: (_) => makeGetxExpansibleGroupFromProductPresenter(),
    ),
    ListenableProvider(
      create: (_) => makeGetxInsertProductsPresenter(),
    ),
    ListenableProvider(
      create: (_) => makeGetxMenuPresenter(),
    ),
    ListenableProvider(
      create: (_) => makeGetxParametersPresenter(),
    ),
    ListenableProvider(
      create: (_) => makeGetxPaymentPresenter(),
    ),
    ListenableProvider(
      create: (_) => makeGetxSaleMovementPresenter(),
    ),
    ListenableProvider(
      create: (_) => makeGetxSendProductsToAnotherTablePresenter(),
    ),
    ListenableProvider(
      create: (_) => makeGetxWebEnterprisesPresenter(),
    ),
    ListenableProvider(
      create: (_) => makeGetxWebLoginPresenter(),
    ),
  ];
}
