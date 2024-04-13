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
    navigateTo = PageRoutes.productDetails;
    Get.toNamed(PageRoutes.productDetails, arguments: _selectedProduct);
  }

  ProductsViewModel? _selectedProduct;
  @override
  ProductsViewModel? get selectedProduct => _selectedProduct;

  @override
  Future<void> loadProducts() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      isLoading = true;
      await Future.delayed(const Duration(seconds: 3));
      _products.subject.add([
        ProductsViewModel(
            price: 10.toString(),
            name: "name 1",
            image:
                "https://www.keyfactor.com/wp-content/uploads/iStock-1252346549-1.jpg"),
        ProductsViewModel(
            price: 20.toString(),
            name: "name 2",
            image:
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZrRMOfxT7f-f7DMJMneZplp2E6wwfCn6LbA&s"),
        ProductsViewModel(
          price: 30.toString(),
          name: "Mattheus",
          image: "https://play-lh.googleusercontent.com/CyuxNrlJ5RZ9NhoEL0v5Ipp-lWYCW-0U2xESBiw0vxycYsqVJ71tZAuzIR5PxldcP9wF=w526-h296-rw",
        ),
      ]);
      isLoading = false;
    } catch (e) {
      _products.subject
          .addError(UIError.unexpected.description, StackTrace.current);
    }
  }

  @override
  void updateSelectedProduct(ProductsViewModel product) {
    _selectedProduct = product;
  }
}
