// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
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
  final String? commandNumberMock = null;

  ExpansibleGroupsPresenterSpy() {
    mockLoadCall().thenAnswer((_) async => _);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.commandNumber).thenAnswer((_) => commandNumberMock);
    when(() => this.expansibleGroups)
        .thenAnswer((_) => expansibleGroupsController);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.clear()).thenAnswer((_) async => _);

    when(() => this.goToSplashPage(
          printedProductsPresenter: any(named: "printedProductsPresenter"),
          saleRequestTempPresenter: any(named: "saleRequestTempPresenter"),
        )).thenAnswer((_) async => Get.offAllNamed(
          PageRoutes.splash,
        ));
  }

  void mockGoToProductsPage(ExpansibleGroupEntity entity) {
    when(() => this.goToProductsPage(any())).thenAnswer((_) => Get.offNamed(
          PageRoutes.products,
          arguments: entity,
        ));
  }

  void mockLoadDataError(DomainError error) {
    mockLoadCall().thenThrow(error);
  }

  When mockLoadCall() => when(() => this.load(
        commandNumber: any(named: "commandNumber"),
        printedProductsPresenter: any(named: "printedProductsPresenter"),
        saleRequestTempPresenter: any(named: "saleRequestTempPresenter"),
      ));

  void mockExpansibleGroupStreamError(DomainError error) {
    mainErrorController.add(UIError.unexpected);
  }

  void emitLoading([bool show = true]) {
    isLoadingController.add(show);
  }
}
