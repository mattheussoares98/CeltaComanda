// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class MenuPresenterSpy extends Mock implements MenuPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  final selectedProductController = StreamController<ProductsViewModel?>();
  final List<LoadedMenuViewModel> expansibleGroupsController = [];
  ProductsViewModel? searchedProductController;

  MenuPresenterSpy() {
    mockLoadCall().thenAnswer((any) async => any);
    when(() => this.loadedMenu).thenAnswer((_) => expansibleGroupsController);
    when(() => this.clear()).thenAnswer((any) async => any);
    when(() => this.addOrRemoveSearchProducts()).thenAnswer((any) async => any);
    when(() => this.updateIndexOfSelectedGroup(any()))
        .thenAnswer((any) async => any);

    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void mockGoToInsertProductPage(ProductsViewModel product) {
    when(() => this.goToInsertProductPage(any())).thenAnswer((_) {
      Get.offNamed(
        PageRoutes.insertProducts,
        arguments: product,
      );
    });
  }

  void mockLoadDataError(DomainError error) {
    mockLoadCall().thenThrow(error);
  }

  When mockLoadCall() => when(() => this.getGroupsAndProducts(
        commandNumber: any(named: "commandNumber"),
        expansibleGroupFromProductPresenter:
            any(named: "expansibleGroupFromProductPresenter"),
        homePresenter: any(named: "homePresenter"),
        isValidatingNeedUpdateAgain: any(named: "isValidatingNeedUpdateAgain"),
      ));

  void mockExpansibleGroupStreamError(DomainError error) {
    mainErrorController.add(UIError.unexpected);
  }

  void emitLoading([bool show = true]) {
    isLoadingController.add(show);
  }
}
