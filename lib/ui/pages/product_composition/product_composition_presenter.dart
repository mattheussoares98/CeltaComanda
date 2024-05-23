import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ProductCompositionPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<ProductCompositionViewModel>> get productsCompositionStream;

  Future<void> loadProductComposition({
    required String url,
    required int enterpriseId,
    required int internalCodeOnErp,
  });

  Future<void> updateSaleRequest({
    required ProductsViewModel productsViewModel,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required List<UpdateSaleRequestTempProductEntity> products,
  });

  bool comboxIsValid();
}
