import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class InsertProductPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<double> get totalPrice;
  Stream<bool> get childsCompositionIsValidStream;
  Stream<ProductsViewModel?> get selectedProductStream;
  Stream<int> get selectedLeftIndexStream;
  Stream<bool> get doScrollStream;
  Stream<bool> get showCommentsStream;
  Stream<bool> get showObligatoryOptionsStream;
  int get totalProductsQuantity;

  void updateTotalLiquid(ProductsViewModel product);

  Future<void> updateSelectedProduct({
    required ProductsViewModel product,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  });

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
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required ProductCompositionViewModel father,
  });

  void updateSelectedIndexOfProduct({
    required ProductCompositionViewModel father,
    required int? index,
  });

  void updateFatherIndex(int newIndex);
  void clearData({
    required ProductsViewModel product,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  });
  bool fatherIsValid(ProductCompositionViewModel? product);
  void advanceFatherIndex(
      ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter);
  bool getCanAdvanceIndex(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  );

  bool getShowComments(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  );

  bool getShowObligatoryOptions(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  );

  bool getShowUpdateQuantity(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  );
}
