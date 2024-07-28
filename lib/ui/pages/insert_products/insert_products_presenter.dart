import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class InsertProductPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<double> get totalPrice;
  Stream<bool> get childsCompositionIsValidStream;
  Stream<bool> get showCommentsStream;
  Stream<ProductsViewModel?> get selectedProductStream;
  Stream<int> get selectedLeftIndexStream;
  Stream<bool> get doScrollStream;
  int get totalProductsQuantity;

  void updateTotalLiquid(ProductsViewModel product);

  Future<void> updateSelectedProduct(ProductsViewModel product);

  Future<bool> updateSaleRequest({
    required HomePresenter homePresenter,
    required CartPresenter cartPresenter,
    required List<InsertProductsViewModel> productsCompositions,
  }); //usa só pra validar se o total do combo está calculando corretamente

  void updateTotalProductsQuantity(bool isAddingQuantity);

  double calculateTotalLiquid({required InsertProductsViewModel product});
  double calculateIncrementValue(InsertProductsViewModel product);
  double calculateProductPrice(InsertProductsViewModel product);
  void updateComment({
    required CommentsPresenter commentsPresenter,
    required InsertProductsViewModel father,
  });

  void updateSelectedIndexOfProduct({
    required InsertProductsViewModel father,
    required int? index,
  });

  void updateSelectedLeftItem(int newIndex);
  void clearData({
    required ProductsViewModel product,
    required CommentsPresenter commentsPresenter,
  });
  bool fatherIsValid(InsertProductsViewModel product);
  void advanceLeftIndex(CommentsPresenter commentsPresenter);
  bool get canAdvanceIndex;
}
