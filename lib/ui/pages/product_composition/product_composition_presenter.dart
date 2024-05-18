import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import 'product_composition_view_model.dart';

abstract class ProductCompositionPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<ProductCompositionViewModel>> get productsCompositionStream;

  Future<void> loadProductComposition({
    required String url,
    required int enterpriseId,
    required int internalCodeOnErp,
  });
}
