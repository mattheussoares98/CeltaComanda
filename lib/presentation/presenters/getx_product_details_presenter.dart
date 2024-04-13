import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxProductDetailsPresenter extends GetxController
    with NavigationManager, LoadingManager
    implements ProductDetailsPresenter {
  GetxProductDetailsPresenter();

  @override
  void addProductInCart() {}

  @override
  void goToCartPage() {
    navigateTo = PageRoutes.cart;
  }
}
