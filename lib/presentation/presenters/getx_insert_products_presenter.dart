import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxInsertProductsPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements InsertProductPresenter {
  final GetProductComposition getProductComposition;
  final UpdateSaleRequestTemp updateSaleRequestTemp;
  final ValidateCombox validateCombox;

  GetxInsertProductsPresenter({
    required this.getProductComposition,
    required this.updateSaleRequestTemp,
    required this.validateCombox,
  });

  final _totalPrice = Rx<double>(0);
  @override
  Stream<double> get totalPrice => _totalPrice.stream;

  int _totalProductsQuantity = 1;
  @override
  int get totalProductsQuantity => _totalProductsQuantity;

  final _comboxIsValidStream = RxBool(false);
  @override
  Stream<bool> get childsCompositionIsValidStream =>
      _comboxIsValidStream.stream;

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
    _totalProductsQuantity = 1;

    selectedComboxProduct = product;

    if (product.childsComposition != null) {
      _updateSelectedIndexOfObligatoryFatherAndEmptyChilds(
        product.childsComposition!,
      );
    }

    updateTotalLiquid(product);
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

      totalLiquid += calculateProductCompositionTotalLiquid(product: product);
    }

    return totalLiquid;
  }

  @override
  void updateTotalLiquid(ProductsViewModel product) {
    if (product.childsComposition == null) {
      _totalPrice.subject
          .add(product.SaleRetailPraticed.toDouble() * _totalProductsQuantity);
    } else {
      double totalLiquid = _getTotalLiquidCombox(product.childsComposition!) *
          _totalProductsQuantity;

      _totalPrice.subject.add(totalLiquid);
    }
  }

  @override
  double calculateProductCompositionIncrementValue(
      ProductCompositionViewModel product) {
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
  double calculateProductCompositionTotalLiquid({
    required ProductCompositionViewModel product,
  }) {
    return calculateProductCompositionPrice(product) *
        product.Quantity.toString().toDouble();
  }

  @override
  double calculateProductCompositionPrice(ProductCompositionViewModel product) {
    if (product.IsOptionalItem == "true") {
      return calculateProductCompositionIncrementValue(product);
    } else if (product.OfferPrice.toString().toDouble() > 0) {
      return product.OfferPrice.toString().toDouble() +
          calculateProductCompositionIncrementValue(product);
    } else {
      return product.SalePrice.toString().toDouble() +
          calculateProductCompositionIncrementValue(product);
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
          Quantity: selectedChild.Quantity!.toDouble() * totalProductsQuantity,
          SaleRequestTempId: saleRequestTempId,
          TotalLiquid: calculateProductCompositionTotalLiquid(
                product: product,
              ) *
              totalProductsQuantity,
          Value: calculateProductCompositionPrice(product),
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
            _getTotalLiquidCombox(productsCompositions) * totalProductsQuantity,
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
  void updateTotalProductsQuantity(bool isAddingQuantity) {
    if (isAddingQuantity) {
      _totalProductsQuantity++;
    } else if (_totalProductsQuantity <= 1) {
      return;
    } else {
      _totalProductsQuantity--;
    }

    if (_selectedProduct.value != null) {
      updateTotalLiquid(_selectedProduct.value!);
    }
  }

  @override
  void updateComment({
    required ExpansibleGroupFromProductPresenter commentsPresenter,
    required ProductCompositionViewModel father,
  }) {
    father.commentFather =
        commentsPresenter.getConcatenateSelectedCommentsAndObligatoryOptions(
            father.InternalCodeOnERPCodeChild!.toInt());
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

  final _selectedProduct = Rx<ProductsViewModel?>(null);
  @override
  Stream<ProductsViewModel?> get selectedProductStream =>
      _selectedProduct.stream;
  set selectedComboxProduct(ProductsViewModel? product) {
    _selectedProduct.value = product;
  }

  final _selectedFatherIndex = Rx<int>(0);
  set selectedFatherIndex(int value) => _selectedFatherIndex.value = value;
  @override
  Stream<int> get selectedLeftIndexStream => _selectedFatherIndex.stream;

  bool allPreviousFathersAreValids(int newIndex) {
    bool valid = true;

    if (_selectedProduct.value!.childsComposition == null) {
      return valid;
    }

    for (var i = 0; i < newIndex; i++) {
      final item = _selectedProduct.value!.childsComposition![i];
      if (!fatherIsValid(item)) {
        valid = false;
        break;
      }
    }

    return valid;
  }

  @override
  void updateSelectedLeftItem(int newIndex) {
    showComments = false;
    allPreviousFathersAreValids(newIndex);

    if (newIndex <= _selectedFatherIndex.value || newIndex == 0) {
      selectedFatherIndex = newIndex;
    } else if (allPreviousFathersAreValids(newIndex)) {
      selectedFatherIndex = newIndex;
    } else {
      //algum pai anterior ao índice selecionado não está válido
    }
    doScroll = true;
  }

  @override
  void clearData({
    required ProductsViewModel product,
    required ExpansibleGroupFromProductPresenter commentsPresenter,
  }) {
    showComments = false;
    selectedFatherIndex = 0;
    _totalProductsQuantity = 1;

    if (product.childsComposition != null) {
      for (var father in product.childsComposition!) {
        father.indexOfSelectedChild = null;
        father.commentFather = null;
      }
    }
    commentsPresenter.unselectAllComments();
  }

  @override
  bool fatherIsValid(ProductCompositionViewModel product) {
    if (product.IsOptionalItem == "false" &&
        product.indexOfSelectedChild == null) {
      return false;
    } else {
      return true;
    }
  }

  final _showComments = false.obs;
  @override
  Stream<bool> get showCommentsStream => _showComments.stream;
  set showComments(bool value) => _showComments.value = value;

  @override
  void advanceLeftIndex(ExpansibleGroupFromProductPresenter commentsPresenter) {
    if (_selectedProduct.value?.childsComposition == null) {
      if (commentsPresenter.productHasComment(
              product: _selectedProduct.value!, indexOfChild: -1) &&
          _selectedFatherIndex.value == 0) {
        showComments = true;
        _selectedFatherIndex.value++;
      }

      return;
    }

    final atualFather =
        _selectedProduct.value!.childsComposition![_selectedFatherIndex.value];

    bool productHasComment = commentsPresenter.productHasComment(
            product: _selectedProduct.value!, indexOfChild: -1) &&
        _selectedFatherIndex.value == 0;

    bool newIndexIsOfQuantity = _selectedFatherIndex.value + 1 ==
        _selectedProduct.value!.childsComposition!.length;

    if (!fatherIsValid(atualFather)) {
    } else if (productHasComment && _showComments.value == false) {
      showComments = true;
    } else if (newIndexIsOfQuantity && productHasComment) {
      showComments = false;
      _selectedFatherIndex.value++;
    } else {
      showComments = false;
      _selectedFatherIndex.value++;
    }

    doScroll = true;
  }

  final _doScrollStream = false.obs;
  @override
  Stream<bool> get doScrollStream => _doScrollStream.stream;
  set doScroll(bool _) {
    Future.delayed(const Duration(milliseconds: 50), () {
      _doScrollStream.subject.add(false);
      Future.delayed(const Duration(milliseconds: 50), () {
        _doScrollStream.subject.add(true);
      });
    });
  }

  @override
  bool get canAdvanceIndex {
    if (_selectedProduct.value?.childsComposition == null) {
      return true;
    }

    ProductCompositionViewModel selectedFather =
        _selectedProduct.value!.childsComposition![0];

    if (_selectedFatherIndex.value <
        _selectedProduct.value!.childsComposition!.length) {
      selectedFather = _selectedProduct
          .value!.childsComposition![_selectedFatherIndex.value];
    }

    return fatherIsValid(selectedFather);
  }

  @override
  double getProductPrice(ProductsViewModel product) {
    if (product.childsComposition == null) {
      return product.SaleRetailPraticed.toDouble();
    } else {
      double total = 0;
      for (var child in product.childsComposition!) {
        total += calculateProductCompositionTotalLiquid(product: child);
      }
      return total;
    }
  }

  @override
  bool get showComments {
    if (_selectedFatherIndex.value == 0 &&
        _selectedProduct.value!.childsComposition == null) {
      return false;
    }
    return false;
  }
}
