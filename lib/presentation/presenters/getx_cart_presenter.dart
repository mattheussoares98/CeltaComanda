import 'package:get/get.dart';

import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxCartPresenter extends GetxController
    with LoadingManager
    implements CartPresenter {
  GetxCartPresenter();

  final _cartItems = Rx<List<ProductsViewModel>>([]);

  @override
  Stream<List<ProductsViewModel>> get cartProducts => _cartItems.stream;

  @override
  void addProductInCart(ProductsViewModel product) async {
    await Future.delayed(const Duration(seconds: 1));
    isLoading = true;
    await Future.delayed(const Duration(seconds: 3));
    _cartItems.subject.add([product]);
    isLoading = false;
  }
}
