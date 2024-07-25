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
  final ValidateCombox validateCombox;

  GetxProductCompositionPresenter({
    required this.getProductComposition,
    required this.updateSaleRequestTemp,
    required this.validateCombox,
  });

  final _totalPriceComboxStream = Rx<double>(0);
  @override
  Stream<double> get totalPriceComboxStream => _totalPriceComboxStream.stream;

  double _totalComboxQuantity = 1;
  @override
  double get totalComboxQuantity => _totalComboxQuantity;

  final _comboxIsValidStream = RxBool(false);
  @override
  Stream<bool> get comboxIsValidStream => _comboxIsValidStream.stream;

  void _updateSelectedIndexOfObligatoryFatherAndEmptyChilds(
    List<ProductCompositionViewModel> productsComposition,
  ) {
    for (var product in productsComposition) {
      if (product.IsOptionalItem == "false" &&
          product.childs?.isEmpty == true) {
        product.indexOfSelectedChild = 0;
      }
    }
  }

  @override
  Future<void> updateSelectedProduct(ProductsViewModel product) async {
    updateComboxQuantity(false, true);

    selectedComboxProduct = product;

    _updateSelectedIndexOfObligatoryFatherAndEmptyChilds(
      product.childsComposition!,
    );

    await Future.delayed(const Duration(milliseconds: 500), () {
      updateComboxIsValid(product.childsComposition!);
    });
  }

  double _getTotalLiquidCombox(
    List<ProductCompositionViewModel> productsCompositionsViewModel,
  ) {
    double totalLiquid = 0;
    for (var product in productsCompositionsViewModel) {
      if (product.IsOptionalItem == "true" &&
          product.indexOfSelectedChild == null) {
        continue;
      }

      totalLiquid += calculateTotalLiquid(product: product);
    }

    return totalLiquid;
  }

  @override
  void updateTotalLiquidCombox(
    List<ProductCompositionViewModel> productsCompositionsViewModel,
  ) {
    double totalLiquid = _getTotalLiquidCombox(productsCompositionsViewModel);

    _totalPriceComboxStream.subject.add(totalLiquid);
  }

  @override
  double calculateIncrementValue(ProductCompositionViewModel product) {
    if (product.IncrementValue.toString().toDouble() > 0) {
      //se houver acréscimo no produto pai, retorna ele
      return product.IncrementValue.toString().toDouble();
    } else if (product.childs?.isEmpty == false &&
        product.indexOfSelectedChild != null) {
      //se houver filho selecionado e o filho tiver acréscimo, retorna o acréscimo do filho
      final selectedChild = product.childs![product.indexOfSelectedChild!];

      if (selectedChild.IncrementValue.toString().toDouble() > 0) {
        return selectedChild.IncrementValue.toString().toDouble();
      }
      return 0;
    } else {
      return 0;
    }
  }

  @override
  double calculateTotalLiquid({
    required ProductCompositionViewModel product,
  }) {
    return calculateProductPrice(product) *
        product.Quantity.toString().toDouble();
  }

  @override
  double calculateProductPrice(ProductCompositionViewModel product) {
    if (product.IsOptionalItem == "true") {
      return calculateIncrementValue(product);
    } else if (product.OfferPrice.toString().toDouble() > 0) {
      return product.OfferPrice.toString().toDouble() +
          calculateIncrementValue(product);
    } else {
      return product.SalePrice.toString().toDouble() +
          calculateIncrementValue(product);
    }
  }

  List<UpdateSaleRequestTempProductEntity>
      _productsCompositionToUpdateSaleRequestTempProductEntity({
    required int saleRequestTempId,
    required List<ProductCompositionViewModel> productsCompositions,
  }) {
    List<UpdateSaleRequestTempProductEntity> products = [];

    try {
      for (var product in productsCompositions) {
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
          Quantity: selectedChild.Quantity!.toDouble() * totalComboxQuantity,
          SaleRequestTempId: saleRequestTempId,
          TotalLiquid: calculateTotalLiquid(
                product: product,
              ) *
              totalComboxQuantity,
          Value: calculateProductPrice(product),
          Comments: product.commentFather,
        );

        products.add(updateSaleRequestTempProductEntity);
      }
    } catch (e) {
      throw DomainError.unexpected;
    }

    return products;
  }

  @override
  Future<bool> updateSaleRequest({
    required HomePresenter homePresenter,
    required CartPresenter cartPresenter,
    required List<ProductCompositionViewModel> productsCompositions,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      if (validateCombox.comboxIsValid(productsCompositions)) {
        _comboxIsValidStream.value = true;
      } else {
        _comboxIsValidStream.value = false;
        throw DomainError.invalidCombox;
      }

      final entity = UpdateSaleRequestTempEntity(
        DeliveryControl: cartPresenter.saleRequestTemp!.DeliveryControl.toInt(),
        EnterpriseId: cartPresenter.saleRequestTemp!.EnterpriseId.toInt(),
        PersonalizedCode: cartPresenter.saleRequestTemp!.PersonalizedCode,
        SaleRequestTempId:
            cartPresenter.saleRequestTemp!.SaleRequestTempId.toInt(),
        TotalLiquid:
            _getTotalLiquidCombox(productsCompositions) * totalComboxQuantity,
        Products: _productsCompositionToUpdateSaleRequestTempProductEntity(
          saleRequestTempId:
              cartPresenter.saleRequestTemp!.SaleRequestTempId.toInt(),
          productsCompositions: productsCompositions,
        ),
      );

      await updateSaleRequestTemp.update(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        entity: entity,
      );

      await cartPresenter.loadSaleRequest(homePresenter.commandNumber!);
      return true;
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.invalidCombox:
          mainError = UIError.invalidCombox;
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
        default:
          mainError = UIError.unexpected;
      }
      return false;
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateComboxIsValid(
    List<ProductCompositionViewModel> productsCompositions,
  ) {
    _comboxIsValidStream.subject.add(
      validateCombox.comboxIsValid(productsCompositions),
    );
  }

  @override
  bool certifyComboxIsValid(
    List<ProductCompositionViewModel> productsCompositions,
  ) {
    mainError = null;
    try {
      _comboxIsValidStream.value =
          validateCombox.comboxIsValid(productsCompositions);

      if (_comboxIsValidStream.value == false) {
        throw Exception();
      }

      return _comboxIsValidStream.value;
    } catch (e) {
      mainError = UIError.invalidCombox;
      return _comboxIsValidStream.value;
    }
  }

  @override
  void updateComboxQuantity(bool isAddingQuantity,
      [bool clearTotalComboxQuantity = false]) {
    if (clearTotalComboxQuantity) {
      _totalComboxQuantity = 1;
    } else if (isAddingQuantity) {
      _totalComboxQuantity++;
    } else {
      _totalComboxQuantity--;
    }
  }

  @override
  void updateComment({
    required CommentsPresenter commentsPresenter,
    required ProductCompositionViewModel father,
  }) {
    father.commentFather = commentsPresenter.getConcatenateSelectedComments();
  }

  @override
  void updateSelectedIndexOfProduct({
    required ProductCompositionViewModel father,
    required int? index,
  }) {
    if (father.IsOptionalItem == "true" &&
        father.indexOfSelectedChild == index) {
      father.indexOfSelectedChild = null;
    } else {
      father.indexOfSelectedChild = index;
    }
  }

  final _selectedComboxProduct = Rx<ProductsViewModel?>(null);
  @override
  Stream<ProductsViewModel?> get selectedComboxProductStream =>
      _selectedComboxProduct.stream;
  set selectedComboxProduct(ProductsViewModel? product) {
    _selectedComboxProduct.value = null;
    _selectedComboxProduct.subject.add(product);
  }

  final _selectedFatherIndex = Rx<int>(0);
  set selectedFatherIndex(int value) => _selectedFatherIndex.value = value;
  @override
  Stream<int> get selectedFatherIndexStream => _selectedFatherIndex.stream;

  @override
  void updateSelectedFatherIndex(int index) => selectedFatherIndex = index;

  @override
  void clearComboxInformations(ProductsViewModel product) {
    selectedFatherIndex = 0;
    for (var father in product.childsComposition!) {
      father.indexOfSelectedChild = null;
      father.commentFather = null;
    }
  }
}
