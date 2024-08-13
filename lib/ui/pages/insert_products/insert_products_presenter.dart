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
    required List<ProductCompositionViewModel> productsCompositions,
  }); //usa só pra validar se o total do combo está calculando corretamente

  void updateTotalProductsQuantity(bool isAddingQuantity);

  double calculateProductCompositionTotalLiquid(
      {required ProductCompositionViewModel product});
  double calculateProductCompositionIncrementValue(
      ProductCompositionViewModel product);
  double calculateProductCompositionPrice(ProductCompositionViewModel product);
  double getProductPrice(ProductsViewModel product);
  void updateComment({
    required ExpansibleGroupFromProductPresenter commentsPresenter,
    required ProductCompositionViewModel father,
  });

  void updateSelectedIndexOfProduct({
    required ProductCompositionViewModel father,
    required int? index,
  });

  void updateSelectedLeftItem(int newIndex);
  void clearData({
    required ProductsViewModel product,
    required ExpansibleGroupFromProductPresenter commentsPresenter,
  });
  bool fatherIsValid(ProductCompositionViewModel product);
  void advanceLeftIndex(ExpansibleGroupFromProductPresenter commentsPresenter);
  bool get canAdvanceIndex;

  bool get showComments;
}
