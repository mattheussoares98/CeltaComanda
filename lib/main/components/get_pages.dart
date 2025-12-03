import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';
import '../factories/factories.dart';

class GetPages {
  GetPages._();

  static final getPages = [
    GetPage(
      name: PageRoutes.cancelProducts,
      page: makeCancelProductsPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.covenant,
      page: makeCovenantPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.configurations,
      page: makeConfigurationsPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.enterpriseValidation,
      page: makeEnterpriseValidationPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.home,
      page: makeHomePage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.insertProducts,
      page: makeInsertProductsPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.parameters,
      page: makeParametersPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.payment,
      page: makePaymentPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.printedProducts,
      page: makePrintedProductsPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.printProducts,
      page: makePrintProductsPage,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PageRoutes.saleMovements,
      page: makeSaleMovementPage,
      transition: Transition.fade,
    ),
    GetPage(
      name: PageRoutes.schedules,
      page: makeSchedulesPage,
      transition: Transition.fade,
    ),
    GetPage(
      name: PageRoutes.sendProductsToAnotherTable,
      page: makeSendProductsToAnotherPageFactory,
      transition: Transition.fade,
    ),
    GetPage(
      name: PageRoutes.splash,
      page: makeSplashPage,
      transition: Transition.fade,
    ),
    GetPage(
      name: PageRoutes.webAddOrEditEnterprise,
      page: makeWebAddOrEditEnterprisePage,
      transition: Transition.fade,
    ),
    GetPage(
      name: PageRoutes.webDevicesInfo,
      page: makeWebDevicesInfoPage,
      transition: Transition.fade,
    ),
    GetPage(
      name: PageRoutes.webEnterprises,
      page: makeWebEnterprisesPage,
      transition: Transition.fade,
    ),
    GetPage(
      name: PageRoutes.webLogin,
      page: makeWebLoginPage,
      transition: Transition.fade,
    ),
    GetPage(
      name: PageRoutes.webSaleRequestDetails,
      page: makeGetxSaleRequestDetailsValidateEnterprisePage,
      transition: Transition.fade,
    ),
  ];
}
