// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class ExpansibleGroupsPresenterSpy extends Mock
    implements ExpansibleGroupsPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  final List<ExpansibleGroupsViewModel> expansibleGroupsController = [];
  ProductsViewModel? searchedProductController;
  TextEditingController searchProductControllerMock = TextEditingController();

  ExpansibleGroupsPresenterSpy() {
    mockLoadCall().thenAnswer((_) async => _);
    when(() => this.expansibleGroups)
        .thenAnswer((_) => expansibleGroupsController);
    when(() => this.clear()).thenAnswer((_) async => _);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.searchedProduct)
        .thenAnswer((_) => searchedProductController);
    when(() => this.searchProductController)
        .thenAnswer((_) => searchProductControllerMock);
  }

  void mockGoToProductsPage(ExpansibleGroupEntity entity) {
    when(() => this.goToProductsPage(any())).thenAnswer((_) => Get.offNamed(
          PageRoutes.products,
          arguments: entity,
        ));
  }

  void mockGoToComboxPage(int internalCodeOnERPCodeFather) {
    when(() => this.goToComboxPage(any())).thenAnswer((_) => Get.offNamed(
          PageRoutes.combox,
          arguments: internalCodeOnERPCodeFather,
        ));
  }

  void mockLoadDataError(DomainError error) {
    mockLoadCall().thenThrow(error);
  }

  When mockLoadCall() => when(() => this.loadGroups(any()));

  void mockExpansibleGroupStreamError(DomainError error) {
    mainErrorController.add(UIError.unexpected);
  }

  void emitLoading([bool show = true]) {
    isLoadingController.add(show);
  }
}
