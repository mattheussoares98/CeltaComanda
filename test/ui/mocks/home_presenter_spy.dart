// ignore_for_file: unnecessary_this

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
  bool isFixedCommandNumberMock = false;
  bool isGeneratingVersionToRedeMock = false;

  HomePresenterSpy() {
    when(() => this.commandNumber).thenAnswer((_) => commandNumberMock);
    when(() => this.isFixedCommandNumber)
        .thenAnswer((_) => isFixedCommandNumberMock);
    when(() => this.isGeneratingVersionToRede)
        .thenAnswer((_) => isGeneratingVersionToRedeMock);
    when(() => this.updateCommandNumber(any())).thenAnswer((_) async => _);
    when(() => this.getLocalCommandData()).thenAnswer((_) async => _);
    when(() => this.updateIsFixedCommandNumber()).thenAnswer((_) async => _);
  }

  void mockGoToSplashPage() {
    when(() => this.goToSplashPage(
          cartPresenter: any(named: "cartPresenter"),
          menuPresenter: any(named: "menuPresenter"),
          printedProductsPresenter: any(named: "printedProductsPresenter"),
        )).thenAnswer((_) async => Get.offAllNamed(
          PageRoutes.splash,
        ));
  }

  void mockLoadCommandData() {
    mockLoadCommandDataCall().thenAnswer((_) async => _);
  }

  When mockLoadCommandDataCall() => when(() => this.loadCommandData(
        menuPresenter: any(named: "menuPresenter"),
        printedProductsPresenter: any(named: "printedProductsPresenter"),
        cartPresenter: any(named: "cartPresenter"),
        expansibleGroupFromProductPresenter: any(named: "expansibleGroupFromProductPresenter"),
        homePresenter: any(named: "homePresenter"),
      ));

  void mockLoadCommandDataError() {
    mockLoadCommandDataCall().thenThrow(DomainError.unexpected);
  }

  void mockExpansibleGroupStreamError(DomainError error) {
    mainErrorController.add(UIError.unexpected);
  }

  void emitLoading([bool show = true]) {
    isLoadingController.add(show);
  }
}
