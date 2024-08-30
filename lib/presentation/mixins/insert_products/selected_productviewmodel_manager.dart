import 'package:get/get.dart';

import '../../../ui/pages/pages.dart';

mixin SelectedProductviewmodelManager on GetxController {
  final _selectedProduct = Rx<ProductsViewModel?>(null);
  ProductsViewModel? get selectedProductValue => _selectedProduct.value;

  Stream<ProductsViewModel?> get selectedProductStream =>
      _selectedProduct.stream;
  set selectedProduct(ProductsViewModel? product) {
    _selectedProduct.value = product;
  }
}
