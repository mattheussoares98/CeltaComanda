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
  final LoadSaleRequestTemp loadSaleRequestTemp;
  final UpdateProductComment updateProductComment;

  GetxProductsPresenter({
    required this.navigateTo,
    required this.loadProducts,
    required this.updateSaleRequestTemp,
    required this.loadSaleRequestTemp,
    required this.updateProductComment,
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
  Future<bool> updateSaleRequest({
    required UpdateSaleRequestTempEntity entity,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required String comments,
    required int saleRequestProductTempId,
  }) async {
    isLoading = true;
    try {
      await updateSaleRequestTemp.update(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        entity: entity,
      );

      await loadSaleRequestTemp.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: expansibleGroupsPresenter.commandNumber!,
      );

      if (comments.isNotEmpty) {
        await updateProductComment.update(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          saleRequestProductTempId: saleRequestProductTempId,
          comments: comments,
        );
      }
      return true;
    } on DomainError catch (e) {
      isLoading = false;
      switch (e) {
        case DomainError.addComment:
          throw DomainError.addComment;
        default:
          throw DomainError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }
}
