import 'package:flutter/material.dart';

import 'cart.dart';

abstract class CartPresenter implements Listenable {
  Stream<List<CartViewModel>> get cartProducts;
  Stream<bool> get isLoadingStream;
}
