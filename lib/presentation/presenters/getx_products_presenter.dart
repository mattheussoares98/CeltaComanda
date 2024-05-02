import 'package:get/get.dart';

import '../../../domain/entities/entities.dart';
import '../../../main/builders/builders.dart';
import '../../../ui/pages/pages.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../mixins/mixins.dart';

class GetxProductsPresenter extends GetxController
    with LoadingManager
    implements ProductsPresenter {
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
    try {
      isLoading = true;

      final products = await loadProducts.load(expansibleGroupId);

      if (products != null) {
        _products.value =
            products.map((e) => ProductsViewModel.fromEntity(e)).toList();
      }
    } catch (e) {
      _products.subject
          .addError(UIError.unexpected.description, StackTrace.current);

      isLoading = false;
      throw DomainError.unexpected;
    } finally {
      isLoading = false;
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

  @override
  Future<void> updateSaleRequest({
    required UpdateSaleRequestTempEntity entity,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
  }) async {
    try {
      isLoading = true;

      await updateSaleRequestTemp.update(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        entity: entity,
      );

      await saleRequestTempPresenter
          .load(expansibleGroupsPresenter.commandNumber!);
    } catch (e) {
      isLoading = false;
      throw DomainError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
