import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CartPresenter implements ChangeNotifier {
  SaleRequestTempViewModel? get saleRequestTemp;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  int? get indexOfSelectedProduct;
  String getTotalSaleRequestTempPrice(
    InsertProductPresenter insertProductPresenter,
  );

  Future<void> getSaleRequestTemp(String commandNumber);

  void clear();

  Future<void> addNewPrintRequestInFirebase();

  List<CartProductsViewModel> get cartProducts;
  Future<void> addProductInCart({
    required CartProductEntity product,
    required MenuPresenter menuPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required String? writtedComment,
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
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    String? commandNumber,
    required InsertProductPresenter insertProductPresenter,
  });
  Future<void> getLocalCartProductsData();
  Future<void> clearCart();

  List<UpdateSaleRequestTempProductEntity> getProductsEntitys({
    required int saleRequestTempId,
    required InsertProductPresenter insertProductPresenter,
  });

  CartProductEntity productWithSelectedsComments({
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required CartProductEntity product,
    required String? writtedComment,
  });
  double calculateServiceChargeValue(double totalLiquidSaleRequest);

  Future<void> insertServiceChargeProduct({
    required String commandNumber,
    required HomePresenter homePresenter,
  });
}
