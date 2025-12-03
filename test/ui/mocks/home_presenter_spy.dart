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
  CommandEntity? commandEntityController;
  bool isGeneratingVersionToRedeMock = false;
  bool isGeneratingVersionToGetNetMock = false;
  bool isGeneratingVersionToTabletMock = false;
  bool isGeneratingVersionToWebSaleRequestDetailsMock = false;

  HomePresenterSpy() {
    when(() => this.commandEntity).thenAnswer((_) => commandEntityController);
    when(() => this.isGeneratingVersionToRede)
        .thenAnswer((_) => isGeneratingVersionToRedeMock);
    when(() => this.isGeneratingVersionToGetNet)
        .thenAnswer((_) => isGeneratingVersionToGetNetMock);
    when(() => this.isGeneratingVersionToTablet)
        .thenAnswer((_) => isGeneratingVersionToTabletMock);
    when(() => this.isGeneratingVersionToWebSaleRequestDetails)
        .thenAnswer((_) => isGeneratingVersionToWebSaleRequestDetailsMock);
    when(() => this.updateCommandEntity(
          commandNumber: any(named: "commandNumber"),
          isFixedCommandNumber: any(named: "isFixedCommandNumber"),
          pdv: any(named: "pdv"),
        )).thenAnswer((any) async => any);
    when(() => this.clear()).thenAnswer((any) async => any);
    mockApplicationIsInLatestVersion(true);
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
        printedProductsPresenter: any(named: "printedProductsPresenter"),
        cartPresenter: any(named: "cartPresenter"),
        expansibleGroupFromProductPresenter:
            any(named: "expansibleGroupFromProductPresenter"),
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

  void mockApplicationIsInLatestVersion(bool value) {
    when(() => this.applicationIsInLatestVersion())
        .thenAnswer((_) async => value);
  }
}
