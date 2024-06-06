import 'package:get/get.dart';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../main/builders/builders.dart';
import '../../../ui/pages/pages.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';

class GetxProductsPresenter with ChangeNotifier implements ProductsPresenter {
  final LoadProducts loadProducts;
  final NavigateTo navigateTo;
  final UpdateSaleRequestTemp updateSaleRequestTemp;

  GetxProductsPresenter({
    required this.navigateTo,
    required this.loadProducts,
    required this.updateSaleRequestTemp,
  });

  final _products = Rx<List<ProductsViewModel>>([]);
  @override
  Stream<List<ProductsViewModel>> get productsStream => _products.stream;

  @override
  Future<void> load(int? expansibleGroupId) async {
    isLoading = true;
    mainError = null;
    try {
      final products = await loadProducts.load(expansibleGroupId);

      if (products != null) {
        _products.value =
            products.map((e) => ProductsViewModel.fromEntity(e)).toList();
      }
    } catch (e) {
      isLoading = false;
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> updateSaleRequest({
    required HomePresenter homePresenter,
    required ProductsViewModel productsViewModel,
    required CartPresenter cartPresenter,
    required List<UpdateSaleRequestTempProductEntity> products,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      final entity = UpdateSaleRequestTempEntity(
        DeliveryControl:
            cartPresenter.saleRequestTemp!.DeliveryControl.toInt(),
        EnterpriseId:
            cartPresenter.saleRequestTemp!.EnterpriseId.toInt(),
        PersonalizedCode:
            cartPresenter.saleRequestTemp!.PersonalizedCode,
        SaleRequestTempId:
            cartPresenter.saleRequestTemp!.SaleRequestTempId.toInt(),
        TotalLiquid: products.fold(0.0,
            (previousValue, element) => element.TotalLiquid + previousValue),
        Products: products,
      );

      await updateSaleRequestTemp.update(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        entity: entity,
      );

      await cartPresenter
          .loadSaleRequest(homePresenter.commandNumber!);
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToComboxPage(ProductsViewModel product) {
    navigateTo.navigate(
      pageRoute: PageRoutes.productComposition,
      arguments: product,
    );
  }

  final _isLoading = false.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) => _isLoading.value = value;

  final _mainError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;
}
