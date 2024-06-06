// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class HomePresenterSpy extends Mock implements HomePresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  String? commandNumberMock;

  HomePresenterSpy() {
    when(() => this.commandNumber).thenAnswer((_) => commandNumberMock);
    when(() => this.goToSplashPage(
          printedProductsPresenter: any(named: "printedProductsPresenter"),
          cartPresenter: any(named: "cartPresenter"),
          menuPresenter: any(named: "menuPresenter"),
        )).thenAnswer((_) async => Get.offAllNamed(
          PageRoutes.splash,
        ));
    when(() => this.updateCommandNumber(any())).thenAnswer((_) async => _);
  }

  void mockGoToProductsPage(ExpansibleGroupEntity entity) {
    when(() => this.goToProductsPage(any())).thenAnswer((_) => Get.offNamed(
          PageRoutes.products,
          arguments: entity,
        ));
  }

  void mockExpansibleGroupStreamError(DomainError error) {
    mainErrorController.add(UIError.unexpected);
  }

  void emitLoading([bool show = true]) {
    isLoadingController.add(show);
  }
}
