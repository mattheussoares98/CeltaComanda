import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxInsertProductsPresenter extends GetxController
    with
        LoadingManager,
        UIErrorManager,
        CanAdvanceIndexManager,
        ComboxIsValidManager,
        DoScrollManager,
        SelectedProductviewmodelManager,
        ShowObligatoryOptionsManager
    implements InsertProductPresenter {
  final GetProductComposition getProductComposition;
  final UpdateSaleRequestTemp updateSaleRequestTemp;
  final ValidateCombox validateCombox;

  GetxInsertProductsPresenter({
    required this.getProductComposition,
    required this.updateSaleRequestTemp,
    required this.validateCombox,
  });

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
  Future<void> updateSelectedProduct({
    required ProductsViewModel product,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) async {
    _totalProductsQuantity = 1;

    selectedComboxProduct = product;

    if (product.childsComposition != null) {
      _updateSelectedIndexOfObligatoryFatherAndEmptyChilds(
        product.childsComposition!,
      );
    }

    updateTotalLiquid(product);

    bool hasComment = expansibleGroupFromProductPresenter.productHasComment(
      product: product,
      indexOfChild: _selectedFatherIndex.value,
    );
    bool hasObligatoryOptions =
        expansibleGroupFromProductPresenter.productHasObligatoryOption(
      product: product,
      indexOfChild: _selectedFatherIndex.value,
    );

    if (hasComment && product.childsComposition == null) {
      showComments = true;
    } else if (hasObligatoryOptions && product.childsComposition == null) {
      showObligatoryOptions = true;
    }
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
        comboxIsValid = true;
      } else {
        comboxIsValid = false;
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

    if (selectedProductValue != null) {
      updateTotalLiquid(selectedProductValue!);
    }
  }

  @override
  void updateComment({
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required ProductCompositionViewModel father,
  }) {
    father.commentFather = expansibleGroupFromProductPresenter
        .getConcatenateSelectedCommentsAndObligatoryOptions(
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

  @override
  void updateFatherIndex(int newIndex) {
    if (newIndex <= _selectedFatherIndex.value) {
      selectedFatherIndex = newIndex;
      doScroll = true;
    }
  }

  @override
  void clearData({
    required ProductsViewModel product,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) {
    selectedFatherIndex = 0;
    _totalProductsQuantity = 1;

    if (product.childsComposition != null) {
      for (var father in product.childsComposition!) {
        father.indexOfSelectedChild = null;
        father.commentFather = null;
      }
    }
    expansibleGroupFromProductPresenter.unselectAllComments();
  }

  @override
  bool fatherIsValid(ProductCompositionViewModel? product) {
    if (product == null) {
      return false;
    } else if (product.IsOptionalItem == "false" &&
        product.indexOfSelectedChild == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void advanceFatherIndex(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  ) {
    bool productHasComment =
        expansibleGroupFromProductPresenter.productHasComment(
      product: selectedProductValue!,
      indexOfChild: _selectedFatherIndex.value,
    );

    bool productHasObligatoryOptions =
        expansibleGroupFromProductPresenter.productHasObligatoryOption(
      product: selectedProductValue!,
      indexOfChild: _selectedFatherIndex.value,
    );

    final atualFather =
        selectedProductValue!.childsComposition?[_selectedFatherIndex.value];

    bool newIndexIsOfQuantity = _selectedFatherIndex.value + 1 ==
        selectedProductValue!.childsComposition?.length;

    bool hasChilds = selectedProductValue?.childsComposition != null;

    if (hasChilds) {
      if (productHasComment &&
          !_showComments.value &&
          fatherIsValid(atualFather) &&
          !showObligatoryOptionValue) {
        showComments = true;
      } else if (productHasObligatoryOptions &&
          fatherIsValid(atualFather) &&
          !showObligatoryOptionValue) {
        showComments = false;
        showObligatoryOptions = true;
      } else {
        debugPrint(
            "Criar tratamento para ter pelo menos uma opção obrigatória selecionada");
        showObligatoryOptions = false;
        showComments = false;
        selectedFatherIndex = _selectedFatherIndex.value + 1;
      }
    } else {
      if (productHasComment && _selectedFatherIndex.value == 0) {
        selectedFatherIndex = _selectedFatherIndex.value + 1;
      } else if (newIndexIsOfQuantity && productHasComment) {
        selectedFatherIndex = _selectedFatherIndex.value + 1;
      } else {
        selectedFatherIndex = _selectedFatherIndex.value + 1;
      }
    }

    doScroll = true;
  }

  @override
  bool getCanAdvanceIndex(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  ) {
    List<ProductCompositionViewModel>? childsComposition =
        selectedProductValue?.childsComposition;

    if (showObligatoryOptionValue) {
      List<ExpansibleGroupFromProductViewModel> selectedOptions;
      if (childsComposition != null) {
        selectedOptions = expansibleGroupFromProductPresenter
            .loadedObligatoryOptions
            .where((e) =>
                e.ProductInternalCodeOnErp ==
                    childsComposition[_selectedFatherIndex.value]
                        .InternalCodeOnERPCodeChild &&
                e.selected)
            .toList();
      } else {
        selectedOptions = expansibleGroupFromProductPresenter
            .loadedObligatoryOptions
            .where((e) =>
                e.ProductInternalCodeOnErp ==
                    selectedProductValue!.InternalCodeOnERP &&
                e.selected)
            .toList();
      }

      if (selectedOptions.isEmpty) {
        return false;
      } else {
        return true;
      }
    }

    if (childsComposition == null) {
      return true;
    }

    ProductCompositionViewModel selectedFather =
        selectedProductValue!.childsComposition![0];

    if (_selectedFatherIndex.value <
        selectedProductValue!.childsComposition!.length) {
      selectedFather =
          selectedProductValue!.childsComposition![_selectedFatherIndex.value];
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
  bool getShowComments(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  ) {
    if (_showComments.value == true) {
      return true;
    }
    bool hasComment = expansibleGroupFromProductPresenter.productHasComment(
      product: selectedProductValue!,
      indexOfChild: _selectedFatherIndex.value,
    );
    if (_selectedFatherIndex.value == 0 &&
        selectedProductValue!.childsComposition == null &&
        !hasComment) {
      return false;
    } else if (_selectedFatherIndex.value == 0 &&
        selectedProductValue!.childsComposition == null &&
        hasComment) {
      return true;
    }
    return false;
  }

  @override
  bool getShowObligatoryOptions(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  ) {
    if (showObligatoryOptionValue == true) {
      return true;
    }
    bool hasComment = expansibleGroupFromProductPresenter.productHasComment(
      product: selectedProductValue!,
      indexOfChild: _selectedFatherIndex.value,
    );

    bool hasObligatoryOptions =
        expansibleGroupFromProductPresenter.productHasObligatoryOption(
      product: selectedProductValue!,
      indexOfChild: _selectedFatherIndex.value,
    );

    if (_selectedFatherIndex.value == 0 &&
        !hasComment &&
        selectedProductValue!.childsComposition == null &&
        hasObligatoryOptions) {
      return true;
    } else if (_selectedFatherIndex.value == 1 &&
        hasComment &&
        selectedProductValue!.childsComposition == null &&
        hasObligatoryOptions) {
      return true;
    }

    return false;
  }

  @override
  bool getShowUpdateQuantity(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  ) {
    bool hasComment = expansibleGroupFromProductPresenter.productHasComment(
      product: selectedProductValue!,
      indexOfChild: _selectedFatherIndex.value,
    );

    bool hasObligatoryOptions =
        expansibleGroupFromProductPresenter.productHasObligatoryOption(
      product: selectedProductValue!,
      indexOfChild: _selectedFatherIndex.value,
    );

    if (selectedProductValue?.childsComposition != null) {
      if (selectedProductValue?.childsComposition?.length ==
          _selectedFatherIndex.value) {
        return true;
      } else {
        return false;
      }
    } else {
      if (!hasObligatoryOptions && !hasComment) {
        return true;
      } else if ((!hasComment || !hasObligatoryOptions) &&
          _selectedFatherIndex.value == 1) {
        return true;
      } else if (hasComment &&
          hasObligatoryOptions &&
          _selectedFatherIndex.value == 2) {
        return true;
      } else {
        return false;
      }
    }
  }

  final _showComments = false.obs;
  @override
  Stream<bool> get showCommentsStream => _showComments.stream;
  set showComments(bool value) => _showComments.value = value;

  final _selectedFatherIndex = Rx<int>(0);
  set selectedFatherIndex(int value) {
    _selectedFatherIndex.value = value;
    showComments = false;
    showObligatoryOptions = false;
  }

  @override
  Stream<int> get selectedLeftIndexStream => _selectedFatherIndex.stream;

  final _totalPrice = Rx<double>(0);
  @override
  Stream<double> get totalPriceStream => _totalPrice.stream;

  int _totalProductsQuantity = 1;
  @override
  int get totalProductsQuantity => _totalProductsQuantity;
}
