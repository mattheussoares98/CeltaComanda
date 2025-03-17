import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CancelProductsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<PrintedViewModel?> get printedProducts;

  Future<void> cancelProduct({
    required PrintedProductsViewModel product,
    required int commandNumber,
    required void Function() showSuccessMessage,
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
  });
  Future<void> newCancelProduct({
    required PrintedProductsViewModel product,
    required PrintedModel printedModel,
    required int commandNumber,
    required void Function() showSuccessMessage,
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
    required int UserIdOfCancellation,
  });
  Future<void> loadProducts(int commandNumber);
}
