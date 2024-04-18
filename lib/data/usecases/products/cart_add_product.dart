import '../../../../ui/pages/pages.dart';

import '../../../domain/usecases/usecases.dart';

class CartAddProduct implements AddProduct {
  final CartPresenter cartPresenter;

  CartAddProduct({required this.cartPresenter});

  @override
  void add(ProductsViewModel product) {
    cartPresenter.addProductInCart(product);
  }
}
