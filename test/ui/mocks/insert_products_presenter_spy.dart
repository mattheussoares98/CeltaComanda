// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class InsertProductsPresenterSpy extends Mock
    implements InsertProductPresenter {
  final mainErrorController = StreamController<UIError?>();
  final totalPriceComboxController = StreamController<double>();
  final enterpriseErrorController = StreamController<UIError?>();
  final productsCompositionController =
      StreamController<List<ProductCompositionViewModel>>();
  final isLoadingController = StreamController<bool>();
  final enterpriseNameTextEditingController = TextEditingController();
  final bool isUpdatedEnterpriseNameController = false;
  final int totalComboxQuantityController = 0;

  InsertProductsPresenterSpy() {
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.totalPriceStream)
        .thenAnswer((_) => totalPriceComboxController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.totalProductsQuantity)
        .thenAnswer((_) => totalComboxQuantityController);
    when(() => this.updateSelectedIndexOfProduct(
          father: any(named: "father"),
          index: any(named: "index"),
          expansibleGroupFromProductPresenter: any(named: "expansibleGroupFromProductPresenter"),
        )).thenAnswer((any) => any);
    when(() => this.calculateProductCompositionPrice(any()))
        .thenAnswer((_) => 0);
    when(() => this.calculateProductCompositionIncrementValue(any()))
        .thenAnswer((_) => 0);
    when(() => this.calculateProductCompositionTotalLiquid(
        product: any(named: "product"))).thenAnswer((_) => 0);
    when(() => this.updateTotalProductsQuantity(any())).thenAnswer((any) => any);
    when(() => this.updateSaleRequest(
          homePresenter: any(named: "homePresenter"),
          cartPresenter: any(named: "cartPresenter"),
          productsCompositions: any(named: "productsCompositions"),
        )).thenAnswer((_) async => true);
    when(() => this.updateSelectedProduct(
          product: any(named: "product"),
          expansibleGroupFromProductPresenter:
              any(named: "expansibleGroupFromProductPresenter"),
        )).thenAnswer((any) async => any);
    when(() => this.updateTotalLiquid(any())).thenAnswer((any) async => any);
  }

  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitMainError(UIError error) => mainErrorController.add(error);

  void dispose() {
    mainErrorController.close();
    isLoadingController.close();
  }
}
