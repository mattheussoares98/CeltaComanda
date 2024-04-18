import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxCartPresenter extends GetxController
    with LoadingManager
    implements CartPresenter {
  final NavigateTo navigateTo;
  GetxCartPresenter({
    required this.navigateTo,
  });

  final _cartItems = Rx<List<ProductsViewModel>>([]);

  @override
  Stream<List<ProductsViewModel>> get cartProducts => _cartItems.stream;

  @override
  void addProductInCart(ProductsViewModel product) {
    _cartItems.subject.add([product]);
  }
}
