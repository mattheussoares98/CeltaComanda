import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/products/products.dart';
import '../mixins/mixins.dart';

class GetxProductsPresenter extends GetxController
    with LoadingManager
    implements ProductsPresenter {
  final LoadProducts loadProducts;
  final NavigateTo navigateTo;

  GetxProductsPresenter({
    required this.navigateTo,
    required this.loadProducts,
  });

  final _products = Rx<List<ProductsViewModel>>([]);

  @override
  Stream<List<ProductsViewModel>> get productsStream => _products.stream;

  @override
  Future<void> load(int? expansibleGroupId) async {
    try {
      isLoading = true;

      final products = await loadProducts.load(expansibleGroupId);

      if (products != null) {
        _products.value =
            products.map((e) => ProductsViewModel.fromEntity(e)).toList();
      }

      isLoading = false;
    } catch (e) {
      _products.subject
          .addError(UIError.unexpected.description, StackTrace.current);

      isLoading = false;
      throw DomainError.unexpected;
    }
  }

  @override
  void goToCartPage() {
    navigateTo.navigate(
      pageRoute: PageRoutes.saleRequestTemp,
    );
  }

  int? _indexOfSelectedProduct;
  @override
  int? get indexOfSelectedProduct => _indexOfSelectedProduct;

  @override
  void updateIndexOfSelectedProduct(int? index) {
    if (_indexOfSelectedProduct == index) {
      _indexOfSelectedProduct = null;
    } else {
      _indexOfSelectedProduct = index;
    }
  }
}
