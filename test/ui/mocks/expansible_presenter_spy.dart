// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class ExpansibleGroupsPresenterSpy extends Mock
    implements GetxExpansibleGroupsPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  final List<ExpansibleGroupsViewModel> expansibleGroupsController = [];

  ExpansibleGroupsPresenterSpy() {
    when(() => this.getExpansibleGroups()).thenAnswer((_) async => _);
    mockLoadCall().thenAnswer((_) async => _);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.expansibleGroups)
        .thenAnswer((_) => expansibleGroupsController);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.goToProductsPage(any())).thenAnswer((_) => Get.offNamed(
          PageRoutes.products,
        ));
    when(() => this.goToCartPage()).thenAnswer((_) => Get.offNamed(
          PageRoutes.cart,
        ));
    when(() => this.goToSplashPage()).thenAnswer((_) async => Get.offAllNamed(
          PageRoutes.splash,
        ));
    when(() => this.goToPrintedProductsPage())
        .thenAnswer((_) async => Get.offNamed(
              PageRoutes.printedProducts,
            ));
  }

  void mockLoadDataError(DomainError error) {
    mockLoadCall().thenThrow(error);
  }

  When mockLoadCall() => when(() => this.load(
        commandNumber: any(named: "commandNumber"),
        printedProductsPresenter: any(named: "printedProductsPresenter"),
      ));

  void mockExpansibleGroupStreamError(DomainError error) {
    mainErrorController.add(UIError.unexpected);
  }

  void emitLoading([bool show = true]) {
    isLoadingController.add(show);
  }
}
