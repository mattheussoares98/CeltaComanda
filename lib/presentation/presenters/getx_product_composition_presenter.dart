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

  final _totalPriceComboxStream = Rx<double>(0);
  @override
  Stream<double> get totalPriceComboxStream => _totalPriceComboxStream.stream;

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
  validateCombox() {
    for (var element in _productsComposition.subject.value!) {
      if (element.IsOptionalItem == "false" &&
          element.indexOfSelectedChild == null) {
        throw DomainError.invalidCombox;
      }
    }
  }

  @override
  void updateTotalLiquidCombox(
    List<ProductCompositionViewModel> productsCompositionsViewModel,
  ) {
    double totalLiquid = 0;
    for (var product in productsCompositionsViewModel) {
      if (product.IsOptionalItem == "true" &&
          product.indexOfSelectedChild == null) {
        continue;
      }

      totalLiquid += _calculateTotalLiquid(product);
    }
    _totalPriceComboxStream.subject.add(totalLiquid);
  }

  double _calculateIncrementValue(ProductCompositionViewModel product) {
    if (product.IncrementValue.toString().toDouble() > 0) {
      return product.IncrementValue.toString().toDouble() *
          product.Quantity.toString().toDouble();
    } else {
      return 0;
    }
  }

  double _calculateTotalLiquid(ProductCompositionViewModel product) {
    if (product.IsOptionalItem == "true") {
      return _calculateIncrementValue(product);
    } else if (product.OfferPrice!.toDouble() > 0) {
      return (product.OfferPrice!.toDouble() * product.Quantity!.toDouble()) +
          _calculateIncrementValue(product);
    } else {
      return (product.SalePrice!.toDouble() * product.Quantity!.toDouble()) +
          _calculateIncrementValue(product);
    }
  }

  double _calculatePrice(ProductCompositionViewModel product) {
    if (product.IsOptionalItem == "true") {
      return _calculateIncrementValue(product);
    } else if (product.OfferPrice.toString().toDouble() > 0) {
      return product.OfferPrice.toString().toDouble() +
          _calculateIncrementValue(product);
    } else {
      return product.SalePrice.toString().toDouble() +
          _calculateIncrementValue(product);
    }
  }

  List<UpdateSaleRequestTempProductEntity>
      _productsCompositionToUpdateSaleRequestTempProductEntity({
    required int saleRequestTempId,
  }) {
    List<UpdateSaleRequestTempProductEntity> products = [];

    try {
      for (var product in _productsComposition.value) {
        if (product.indexOfSelectedChild == null) {
          continue;
        }

        ProductCompositionViewModel selectedChild;
        if (product.childs?.isEmpty == true) {
          selectedChild = product;
        } else {
          selectedChild = product.childs![product.indexOfSelectedChild!];
        }

        final updateSaleRequestTempProductEntity =
            UpdateSaleRequestTempProductEntity(
          ProductInternalCodeOnErp:
              selectedChild.InternalCodeOnERPCodeChild.toString().toInt(),
          ProductPriceLookUpCode: selectedChild.PluChild!,
          Quantity: selectedChild.Quantity!.toDouble(),
          SaleRequestTempId: saleRequestTempId,
          TotalLiquid: _calculateTotalLiquid(selectedChild),
          Value: _calculatePrice(selectedChild),
          Comments: selectedChild.commentFather,
        );

        products.add(updateSaleRequestTempProductEntity);
      }
    } catch (e) {
      throw DomainError.unexpected;
    }

    return products;
  }

  @override
  Future<void> updateSaleRequest({
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      validateCombox();

      final entity = UpdateSaleRequestTempEntity(
        DeliveryControl:
            saleRequestTempPresenter.saleRequestTemp!.DeliveryControl.toInt(),
        EnterpriseId:
            saleRequestTempPresenter.saleRequestTemp!.EnterpriseId.toInt(),
        PersonalizedCode:
            saleRequestTempPresenter.saleRequestTemp!.PersonalizedCode,
        SaleRequestTempId:
            saleRequestTempPresenter.saleRequestTemp!.SaleRequestTempId.toInt(),
        TotalLiquid: _totalPriceComboxStream.value,
        Products: _productsCompositionToUpdateSaleRequestTempProductEntity(
          saleRequestTempId: saleRequestTempPresenter
              .saleRequestTemp!.SaleRequestTempId
              .toInt(),
        ),
      );

      await updateSaleRequestTemp.update(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        entity: entity,
      );

      await saleRequestTempPresenter
          .loadSaleRequest(homePresenter.commandNumber!);
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.invalidCombox:
          mainError = UIError.invalidCombox;
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
