import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CartPresenter implements ChangeNotifier {
  SaleRequestTempViewModel? get saleRequestTemp;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  int? get indexOfSelectedProduct;
  String get totalSaleRequestTempPrice;

  Future<void> loadSaleRequest(String commandNumber);

  void clear();

  Future<void> addNewPrintRequestInFirebase();

  List<CartProductsViewModel> get cartProducts;
  Future<void> addProductInCart({
    required CartProductEntity product,
    required MenuPresenter menuPresenter,
    required CommentsPresenter commentsPresenter,
  });
  Future<void> removeProductFromCart(int index);
  Future<void> updateCommentOfProductCart({
    required int index,
    required String? newComment,
  });
  Future<void> reduceCartProductQuantity(int index);
  Future<void> addCartProductQuantity(int index);
  Future<bool> saveProducts({
    required PrintedProductsPresenter printedProductsPresenter,
    required int? tableNumber,
    required HomePresenter homePresenter,
    required CommentsPresenter commentsPresenter,
    String? commandNumber,
  });
  Future<void> getLocalCartProductsData();
  Future<void> clearCartAndConfirmedCombox();

  int? get indexOfSelectedProductCombox;

  List<UpdateSaleRequestTempProductEntity>
      convertProductsCompositionToUpdateSaleRequestTempProductEntity({
    required int saleRequestTempId,
  });

  double calculateProductCompositionTotalLiquid(ProductCompositionViewModel product);
  double calculateProductCompositionIncrementValue(ProductCompositionViewModel product);
  double calculateProductCompositionPrice(ProductCompositionViewModel product);

  CartProductEntity productWithSelectedsComments({
    required CommentsPresenter commentsPresenter,
    required CartProductEntity product,
  });
}
