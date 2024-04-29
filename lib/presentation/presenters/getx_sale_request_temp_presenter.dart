import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:get/get.dart';

import 'package:flutter/foundation.dart';

import '../../ui/pages/pages.dart';

class GetxCartPresenter
    with ChangeNotifier
    implements SaleRequestTempPresenter {
  final LoadSaleRequestTemp loadSaleRequestTemp;

  GetxCartPresenter({
    required this.loadSaleRequestTemp,
  });
  
  final List<ProductsViewModel> _cartItems = [];

  @override
  List<ProductsViewModel> get saleRequestProducts => _cartItems;

  @override
  Future<void> addProductInCart(ProductsViewModel product) async {
    _cartItems.add(product);
    notifyListeners();
  }

  final _isLoading = Rx<bool>(false);

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  Future<void> load() async {}
}
