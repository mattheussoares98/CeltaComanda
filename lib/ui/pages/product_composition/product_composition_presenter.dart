import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ProductCompositionPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<ProductCompositionViewModel>> get productsCompositionStream;
  Stream<double> get totalPriceComboxStream;
  Stream<bool> get comboxIsValidStream;
  double get totalComboxQuantity;

  void updateTotalLiquidCombox(
    List<ProductCompositionViewModel> productsCompositionsViewModel,
  );

  bool certifyComboxIsValid(
      List<ProductCompositionViewModel> productsCompositions);
  void updateComboxIsValid(
      List<ProductCompositionViewModel> productsCompositions);

  Future<bool> updateSaleRequest({
    required HomePresenter homePresenter,
    required CartPresenter cartPresenter,
    required List<ProductCompositionViewModel> productsCompositions,
  });

  void updateComboxQuantity(bool isAddingQuantity);

  double calculateTotalLiquid({required ProductCompositionViewModel product});
  double calculateIncrementValue(ProductCompositionViewModel product);
  double calculateProductPrice(ProductCompositionViewModel product);
  void updateComment({
    required CommentsPresenter commentsPresenter,
    required ProductCompositionViewModel father,
  });

  void updateSelectedIndexOfProduct({
    required ProductCompositionViewModel father,
    required int? index,
  });
}
