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
  Future<bool> updateSaleRequest({
    required HomePresenter homePresenter,
    required ProductsViewModel productsViewModel,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      String numberAmerican =
          productsViewModel.SaleRetailPraticed.replaceAll(RegExp(r','), '.');

      double saleRetailPraticed = double.parse(numberAmerican);

      final entity = UpdateSaleRequestTempEntity(
        DeliveryControl: int.parse(
            saleRequestTempPresenter.saleRequestTemp!.DeliveryControl),
        EnterpriseId:
            int.parse(saleRequestTempPresenter.saleRequestTemp!.EnterpriseId),
        PersonalizedCode:
            saleRequestTempPresenter.saleRequestTemp!.PersonalizedCode,
        SaleRequestTempId: int.parse(
            saleRequestTempPresenter.saleRequestTemp!.SaleRequestTempId),
        TotalLiquid: saleRetailPraticed,
        Products: [
          UpdateSaleRequestTempProductEntity(
            ProductInternalCodeOnErp:
                int.parse(productsViewModel.InternalCodeOnERP.toString()),
            ProductPriceLookUpCode: productsViewModel.PriceLookupCode,
            Quantity: 1,
            SaleRequestTempId: int.parse(
                saleRequestTempPresenter.saleRequestTemp!.SaleRequestTempId),
            TotalLiquid: saleRetailPraticed,
            Value: saleRetailPraticed,
          )
        ],
      );

      await updateSaleRequestTemp.update(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        entity: entity,
      );

      await saleRequestTempPresenter.loadSaleRequest(homePresenter.commandNumber!);

      return true;
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.addComment:
          mainError = UIError.addComment;
          return false;
        default:
          mainError = UIError.unexpected;
          return false;
      }
    } finally {
      isLoading = false;
    }
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
