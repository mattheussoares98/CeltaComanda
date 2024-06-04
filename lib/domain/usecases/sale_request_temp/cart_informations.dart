import '../../../ui/pages/pages.dart';

abstract class CartInformations {
  Future<void> update(List<CartProductsViewModel> cartProducts);
  Future<List<CartProductsViewModel>?> get();
}
