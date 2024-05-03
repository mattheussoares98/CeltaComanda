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

  final _mainError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;

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
    required UpdateSaleRequestTempEntity entity,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      await updateSaleRequestTemp.update(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        entity: entity,
      );

      await saleRequestTempPresenter
          .load(expansibleGroupsPresenter.commandNumber!);

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
}
