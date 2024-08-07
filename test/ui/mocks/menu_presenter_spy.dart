// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class MenuPresenterSpy extends Mock implements MenuPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  final menuController = StreamController<
      List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>>();
  final showPreLoadImageController = StreamController<bool>();
  final selectedProductController = StreamController<ProductsViewModel?>();
  final List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>
      expansibleGroupsController = [];
  ProductsViewModel? searchedProductController;
  TextEditingController searchProductControllerMock = TextEditingController();

  MenuPresenterSpy() {
    mockLoadCall().thenAnswer((_) async => _);
    when(() => this.loadedMenu).thenAnswer((_) => expansibleGroupsController);
    when(() => this.menuStream).thenAnswer((_) => menuController.stream);
    when(() => this.showPreLoadImagesStream)
        .thenAnswer((_) => showPreLoadImageController.stream);
    when(() => this.clear()).thenAnswer((_) async => _);
    when(() => this.updateIndexOfSelectedGroup(any()))
        .thenAnswer((_) async => _);

    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.searchProductController)
        .thenAnswer((_) => searchProductControllerMock);
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
        commentsPresenter: any(named: "commentsPresenter"),
      ));

  void mockExpansibleGroupStreamError(DomainError error) {
    mainErrorController.add(UIError.unexpected);
  }

  void emitLoading([bool show = true]) {
    isLoadingController.add(show);
  }
}
