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
  Future<void> addProductQuantity({
    required String url,
    required int saleRequestProductTempId,
    required String commandNumber,
  });
  Future<void> subtractProductQuantity({
    required String url,
    required int saleRequestProductTempId,
    required int productQuantity,
    required String commandNumber,
  });

  Future<void> loadCommandData({
    required String commandNumber,
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
  });

  void clear();

  Future<void> updateComment({
    required String comments,
    required int saleRequestProductTempId,
    required MenuPresenter menuPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
  });

  void updateLocalSaleRequestComment(String newComment);

  Future<void> finishSaleRequest({
    required SaleRequestTempEntity saleRequestTempEntity,
    required MenuPresenter menuPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
  });

  void updateIndexOfSelectedProduct(int? index);

  Future<void> addNewPrintRequestInFirebase();

  List<CartProductsViewModel> get cartProducts;
  Future<void> addProductInCart({
    required CartProductEntity product,
    required MenuPresenter menuPresenter,
  });
  Future<void> removeProductFromCart(int index);
  Future<void> updateCommentOfProductCart({
    required int index,
    required String? newComment,
  });
  Future<void> reduceCartProductQuantity(int index);
  Future<void> addCartProductQuantity(int index);
  Future<bool> saveProducts({
    required String commandNumber,
    required PrintedProductsPresenter printedProductsPresenter,
  });
  Future<void> getLocalCartProductsData();
}
