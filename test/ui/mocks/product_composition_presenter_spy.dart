// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class ProductCompositionPresenterSpy extends Mock
    implements ProductCompositionPresenter {
  final mainErrorController = StreamController<UIError?>();
  final totalPriceComboxController = StreamController<double>();
  final comboxIsValidController = StreamController<bool>();
  final enterpriseErrorController = StreamController<UIError?>();
  final selectedComboxProductController =
      StreamController<ProductsViewModel?>();
  final productsCompositionController =
      StreamController<List<ProductCompositionViewModel>>();
  final isLoadingController = StreamController<bool>();
  final enterpriseNameTextEditingController = TextEditingController();
  final bool isUpdatedEnterpriseNameController = false;
  final double totalComboxQuantityController = 0;

  ProductCompositionPresenterSpy() {
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.comboxIsValidStream)
        .thenAnswer((_) => comboxIsValidController.stream);
    when(() => this.totalPriceComboxStream)
        .thenAnswer((_) => totalPriceComboxController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.selectedComboxProductStream)
        .thenAnswer((_) => selectedComboxProductController.stream);
    when(() => this.totalComboxQuantity)
        .thenAnswer((_) => totalComboxQuantityController);
    when(() => this.updateSelectedIndexOfProduct(
          father: any(named: "father"),
          index: any(named: "index"),
        )).thenAnswer((_) => _);
    when(() => this.updateComment(
          commentsPresenter: any(named: "commentsPresenter"),
          father: any(named: "father"),
        )).thenAnswer((_) => _);
    when(() => this.calculateProductPrice(any())).thenAnswer((_) => 0);
    when(() => this.calculateIncrementValue(any())).thenAnswer((_) => 0);
    when(() => this.calculateTotalLiquid(product: any(named: "product")))
        .thenAnswer((_) => 0);
    when(() => this.updateComboxQuantity(any())).thenAnswer((_) => _);
    when(() => this.updateSaleRequest(
          homePresenter: any(named: "homePresenter"),
          cartPresenter: any(named: "cartPresenter"),
          productsCompositions: any(named: "productsCompositions"),
        )).thenAnswer((_) async => true);
    when(() => this.updateComboxIsValid(any())).thenAnswer((_) => true);
    when(() => this.certifyComboxIsValid(any())).thenAnswer((_) => true);
    when(() => this.updateSelectedProduct(any())).thenAnswer((_) async => _);
    when(() => this.updateTotalLiquidCombox(any())).thenAnswer((_) async => _);
  }

  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitMainError(UIError error) => mainErrorController.add(error);

  void dispose() {
    mainErrorController.close();
    isLoadingController.close();
  }
}
