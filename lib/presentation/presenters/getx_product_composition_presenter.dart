import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxProductCompositionPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements ProductCompositionPresenter {
  final GetProductComposition getProductComposition;
  final UpdateSaleRequestTemp updateSaleRequestTemp;

  GetxProductCompositionPresenter({
    required this.getProductComposition,
    required this.updateSaleRequestTemp,
  });

  final _productsComposition = Rx<List<ProductCompositionViewModel>>([]);
  @override
  Stream<List<ProductCompositionViewModel>> get productsCompositionStream =>
      _productsComposition.stream;

  @override
  Future<void> loadProductComposition({
    required String url,
    required int enterpriseId,
    required int internalCodeOnErp,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      final fathers = await getProductComposition.getFathers(
        url: url,
        enterpriseId: enterpriseId,
        internalCodeOnErp: internalCodeOnErp,
      );

      List<ProductCompositionViewModel> childs =
          await getProductComposition.getChildsOfFather(
        url: url,
        enterpriseId: enterpriseId,
        internalCodeOnErp: internalCodeOnErp,
        fathers: fathers,
      );

      _productsComposition.subject.add(childs);
    } catch (e) {
      mainError = UIError.unexpected;
      _productsComposition.subject.add([]);
    } finally {
      isLoading = false;
    }
  }

  @override
  bool comboxIsValid() {
    bool isValid = true;
    for (var element in _productsComposition.subject.value!) {
      if (element.IsOptionalItem == "false" &&
          element.indexOfSelectedChild == null) {
        return false;
      }
    }

    return isValid;
  }

  @override
  Future<void> updateSaleRequest({
    required HomePresenter homePresenter,
    required ProductsViewModel productsViewModel,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required List<UpdateSaleRequestTempProductEntity> products,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      final entity = UpdateSaleRequestTempEntity(
        DeliveryControl:
            saleRequestTempPresenter.saleRequestTemp!.DeliveryControl.toInt(),
        EnterpriseId:
            saleRequestTempPresenter.saleRequestTemp!.EnterpriseId.toInt(),
        PersonalizedCode:
            saleRequestTempPresenter.saleRequestTemp!.PersonalizedCode,
        SaleRequestTempId:
            saleRequestTempPresenter.saleRequestTemp!.SaleRequestTempId.toInt(),
        TotalLiquid: productsViewModel.SaleRetailPraticed.toDouble(),
        Products: products,
      );

      await updateSaleRequestTemp.update(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        entity: entity,
      );

      await saleRequestTempPresenter
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
}
