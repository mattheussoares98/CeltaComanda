import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/products/products.dart';
import '../mixins/mixins.dart';

class GetxProductsPresenter extends GetxController
    with NavigationManager, LoadingManager
    implements ProductsPresenter {
  GetxProductsPresenter();

  final _products = Rx<List<ProductsViewModel>>([]);

  @override
  Stream<List<ProductsViewModel>> get productsStream => _products.stream;

  @override
  void goToProductDetailsPage() {
    navigateTo = "/product_details";
  }

  @override
  Future<void> loadProducts() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      isLoading = true;
      await Future.delayed(const Duration(seconds: 3));
      _products.subject.add([
        const ProductsViewModel(
            price: 10,
            name: "name 1",
            image:
                "https://www.keyfactor.com/wp-content/uploads/iStock-1252346549-1.jpg"),
        const ProductsViewModel(
            price: 20,
            name: "name 2",
            image:
                "https://www.keyfactor.com/wp-content/uploads/iStock-1252346549-1.jpg"),
        const ProductsViewModel(
            price: 30,
            name: "name 3",
            image:
                "https://www.keyfactor.com/wp-content/uploads/iStock-1252346549-1.jpg"),
      ]);
      isLoading = false;
    } catch (e) {
      _products.subject
          .addError(UIError.unexpected.description, StackTrace.current);
    }
  }
}
