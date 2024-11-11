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
  bool isGeneratingVersionToTabletMock = false;

  HomePresenterSpy() {
    when(() => this.commandNumber).thenAnswer((_) => commandNumberMock);
    when(() => this.isFixedCommandNumber)
        .thenAnswer((_) => isFixedCommandNumberMock);
    when(() => this.isGeneratingVersionToRede)
        .thenAnswer((_) => isGeneratingVersionToRedeMock);
    when(() => this.isGeneratingVersionToTablet)
        .thenAnswer((_) => isGeneratingVersionToTabletMock);
    when(() => this.updateCommandNumber(any())).thenAnswer((any) async => any);
    when(() => this.updateIsFixedCommandNumber())
        .thenAnswer((any) async => any);
    when(() => this.clear()).thenAnswer((any) => any);
  }

  void mockGoToSplashPage() {
    when(() => this.doLogout(
          cartPresenter: any(named: "cartPresenter"),
          menuPresenter: any(named: "menuPresenter"),
          printedProductsPresenter: any(named: "printedProductsPresenter"),
          enterprisePresenter: any(named: "enterprisePresenter"),
        )).thenAnswer((_) async => Get.offAllNamed(
          PageRoutes.splash,
        ));
  }

  void mockLoadCommandData() {
    mockLoadCommandDataCall().thenAnswer((any) async => any);
  }

  When mockLoadCommandDataCall() => when(() => this.loadCommandData(
        menuPresenter: any(named: "menuPresenter"),
        printedProductsPresenter: any(named: "printedProductsPresenter"),
        cartPresenter: any(named: "cartPresenter"),
        expansibleGroupFromProductPresenter:
            any(named: "expansibleGroupFromProductPresenter"),
        updateMenu: any(named: "updateMenu"),
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
