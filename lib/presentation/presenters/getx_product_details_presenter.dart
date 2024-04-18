import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxProductDetailsPresenter extends GetxController
    with LoadingManager
    implements ProductDetailsPresenter {
  final AddProduct addProduct;
  final NavigateTo navigateTo;

  GetxProductDetailsPresenter({
    required this.navigateTo,
    required this.addProduct,
  });

  @override
  void addProductInCart(ProductsViewModel product) {
    addProduct.add(product);
  }

  @override
  void goToCartPage() {
    navigateTo.navigate(pageRoute: PageRoutes.cart);
  }
}
