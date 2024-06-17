import '../../../ui/pages/pages.dart';

abstract class CartInformations {
  Future<void> updateCartProducts(List<CartProductsViewModel> cartProducts);
  Future<List<CartProductsViewModel>?> getCartProducts();
  Future<void> clearCartProducts();

  Future<void> updateConfirmedCombox(
    List<ConfirmedComboxViewModel> confirmedCombox,
  );
  Future<List<ConfirmedComboxViewModel>?> getConfirmedCombox();
  Future<void> clearConfirmedCombox();
}
