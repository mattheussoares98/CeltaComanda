import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ProductCompositionPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<ProductCompositionViewModel>> get productsCompositionStream;
  Stream<double> get totalPriceComboxStream;

  void updateTotalLiquidCombox(
    List<ProductCompositionViewModel> productsCompositionsViewModel,
  );

  Future<void> loadProductComposition({
    required String url,
    required int enterpriseId,
    required int internalCodeOnErp,
  });

  Future<void> updateSaleRequest({
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required List<ProductCompositionViewModel> productsCompositions,
  });

  bool comboxIsValid();
}
