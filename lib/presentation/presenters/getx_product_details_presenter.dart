import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxProductDetailsPresenter extends GetxController
    with LoadingManager
    implements ProductDetailsPresenter {
  final NavigateTo navigateTo;

  GetxProductDetailsPresenter({
    required this.navigateTo,
  });

  // @override
  // void addProductInCart(ProductsViewModel product) {}

  @override
  void goToCartPage() {
    navigateTo.navigate(pageRoute: PageRoutes.cart);
  }
}
