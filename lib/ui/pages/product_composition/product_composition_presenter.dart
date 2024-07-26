import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ProductCompositionPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<double> get totalPriceComboxStream;
  Stream<bool> get comboxIsValidStream;
  Stream<bool> get showCommentsStream;
  Stream<ProductsViewModel?> get selectedComboxProductStream;
  Stream<int> get selectedFatherIndexStream;
  double get totalComboxQuantity;

  void updateTotalLiquidCombox(
    List<ProductCompositionViewModel> productsCompositionsViewModel,
  );

  Future<void> updateSelectedProduct(ProductsViewModel product);

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

  void updateSelectedFatherIndex(int newIndex);
  void clearSelectedComboxData({
    required ProductsViewModel product,
    required CommentsPresenter commentsPresenter,
  });
  bool fatherIsValid(ProductCompositionViewModel product);
  void advanceFatherIndex();
}
