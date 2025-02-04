// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class MenuPresenterSpy extends Mock implements MenuPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  final doScrollGroupsController = StreamController<bool>();
  final indexOfSelectedGroupController = StreamController<int>();
  final selectedProductController = StreamController<ProductsViewModel?>();
  final searchedProductController = StreamController<ProductsViewModel?>();
  final productScheduleController =
      StreamController<ProductScheduleViewModel?>();
  final expansibleGroupScheduleController =
      StreamController<ExpansibleGroupScheduleViewModel?>();
  final List<LoadedMenuViewModel> loadedMenuController = [];
  final List<ImageModel> downloadedImagesController = [];

  MenuPresenterSpy() {
    mockLoadCall().thenAnswer((any) async => any);
    when(() => this.loadedMenu).thenAnswer((_) => loadedMenuController);
    when(() => this.clear()).thenAnswer((any) async => any);
    when(() => this.addOrRemoveSearchProducts()).thenAnswer((any) async => any);
    when(() => this.searchProduct(any())).thenAnswer((any) async => any);
    when(() => this.loadAllImages(
          updateLocally: any(named: "updateLocally"),
        )).thenAnswer((any) async => any);
    this.mockLoadCall().thenAnswer((any) async => any);
    when(() => this.updateIndexOfSelectedGroup(any()))
        .thenAnswer((any) async => any);

    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.doScrollGroupsStream)
        .thenAnswer((_) => doScrollGroupsController.stream);
    when(() => this.indexOfSelectedGroupStream)
        .thenAnswer((_) => indexOfSelectedGroupController.stream);
    when(() => this.searchedProductStream)
        .thenAnswer((_) => searchedProductController.stream);
    when(() => this.productScheduleStream)
        .thenAnswer((_) => productScheduleController.stream);
    when(() => this.expansibleGroupScheduleStream)
        .thenAnswer((_) => expansibleGroupScheduleController.stream);
    when(() => this.downloadedImages)
        .thenAnswer((_) => downloadedImagesController);
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

  When mockLoadCall() {
    return when(() => this.getGroupsAndProducts(
          commandEntity: any(named: "commandEntity"),
          expansibleGroupFromProductPresenter:
              any(named: "expansibleGroupFromProductPresenter"),
          loadLocally: any(named: "loadLocally"),
        ));
  }

  void mockExpansibleGroupStreamError(DomainError error) {
    mainErrorController.add(UIError.unexpected);
  }

  void emitLoading([bool show = true]) {
    isLoadingController.add(show);
  }
}
