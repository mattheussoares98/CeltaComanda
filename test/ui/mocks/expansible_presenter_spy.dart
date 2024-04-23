// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class ExpansibleGroupsPresenterSpy extends Mock
    implements ExpansibleGroupsPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  final List<ExpansibleGroupsViewModel> expansibleGroupsController = [];

  ExpansibleGroupsPresenterSpy() {
    when(() => this.getExpansibleGroups()).thenAnswer((_) async => _);
    when(() => this.getSaleRequestTemp(any())).thenAnswer((_) async => _);
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
    when(() => this.goToSplashPage()).thenAnswer((_) => Get.offAllNamed(
          PageRoutes.splash,
        ));
  }

  void mockVerifyCommandIsAvailableError(DomainError error) {
    when(() => this.getSaleRequestTemp(any())).thenThrow(error);
  }

  void mockExpansibleGroupStreamError(DomainError error) {
    mainErrorController.add(UIError.unexpected);
  }

  void emitLoading([bool show = true]) {
    isLoadingController.add(show);
  }
}
