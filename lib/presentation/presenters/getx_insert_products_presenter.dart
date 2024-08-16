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
        CanAdvanceIndexManager,
        ComboxIsValidManager,
        DoScrollManager,
        LoadingManager,
        SelectedProductviewmodelManager,
        ShowCommentsManager,
        ShowObligatoryOptionsManager,
        TotalPriceManager,
        TotalProductsQuantityManager,
        UIErrorManager
    implements InsertProductPresenter {
  final GetProductComposition getProductComposition;
  final UpdateSaleRequestTemp updateSaleRequestTemp;
  final ValidateCombox validateCombox;

  GetxInsertProductsPresenter({
    required this.getProductComposition,
    required this.updateSaleRequestTemp,
    required this.validateCombox,
  });

  @override
  Future<void> updateSelectedProduct({
    required ProductsViewModel product,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) async {
    totalProductsQuantity = 1;

    selectedComboxProduct = product;

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

    if (product.childsComposition == null) {
      final insertViewModel = [
        InsertProductsViewModel(
          selectedOptions: {
            SelectedOptionType.product: product,
          },
        ),
        if (hasComment)
          InsertProductsViewModel(selectedOptions: {
            SelectedOptionType.optionalExpansibleGroup:
                expansibleGroupFromProductPresenter.loadedComments
                    .where(
                      (e) =>
                          e.ProductInternalCodeOnErp ==
                          product.InternalCodeOnERP,
                    )
                    .toList(),
          }),
        if (hasObligatoryOptions)
          InsertProductsViewModel(
            selectedOptions: {
              SelectedOptionType.obligatoryExpansibleGroup:
                  expansibleGroupFromProductPresenter.loadedObligatoryOptions
                      .where(
                        (e) =>
                            e.ProductInternalCodeOnErp ==
                            product.InternalCodeOnERP,
                      )
                      .toList(),
            },
          ),
        const InsertProductsViewModel(
          selectedOptions: {
            SelectedOptionType.quantity: null,
          },
        ),
      ];
      _insertProductsViewModel.subject.add(insertViewModel);
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
      totalPrice =
          product.SaleRetailPraticed.toDouble() * totalProductsQuantity;
    } else {
      double totalLiquid = _getTotalLiquidCombox(product.childsComposition!) *
          totalProductsQuantity;

      totalPrice = totalLiquid;
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
      totalProductsQuantity = totalProductsQuantity + 1;
    } else if (totalProductsQuantity <= 1) {
      return;
    } else {
      totalProductsQuantity = totalProductsQuantity - 1;
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
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) {
    if (father.IsOptionalItem == "true" &&
        father.indexOfSelectedChild == index) {
      father.indexOfSelectedChild = null;
    } else {
      father.indexOfSelectedChild = index;
    }

    updateCanAdvanceIndex(expansibleGroupFromProductPresenter);
  }

  @override
  void updateFatherIndex({
    required int newIndex,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) {
    if (newIndex <= _selectedFatherIndex.value) {
      selectedFatherIndex = newIndex;
      doScroll = true;
    }
    updateCanAdvanceIndex(expansibleGroupFromProductPresenter);
  }

  @override
  void clearData({
    required ProductsViewModel product,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) {
    selectedFatherIndex = 0;
    totalProductsQuantity = 1;

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
          !showCommentsValue &&
          fatherIsValid(atualFather) &&
          !showObligatoryOptionValue &&
          (atualFather?.indexOfSelectedChild != null)) {
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
    updateCanAdvanceIndex(expansibleGroupFromProductPresenter);
  }

  @override
  void updateCanAdvanceIndex(
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
        canAdvanceIndex = false;
      } else {
        canAdvanceIndex = true;
      }
    } else if (childsComposition == null) {
      canAdvanceIndex = true;
    } else {
      ProductCompositionViewModel selectedFather =
          selectedProductValue!.childsComposition![0];

      if (_selectedFatherIndex.value <
          selectedProductValue!.childsComposition!.length) {
        selectedFather = selectedProductValue!
            .childsComposition![_selectedFatherIndex.value];
      }

      if (fatherIsValid(selectedFather)) {
        canAdvanceIndex = true;
      } else {
        canAdvanceIndex = false;
      }
    }
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
    if (showCommentsValue == true) {
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

  final _selectedFatherIndex = Rx<int>(0);
  set selectedFatherIndex(int value) {
    _selectedFatherIndex.value = value;
    showComments = false;
    showObligatoryOptions = false;
  }

  @override
  Stream<int> get selectedLeftIndexStream => _selectedFatherIndex.stream;

  final _insertProductsViewModel = Rx<List<InsertProductsViewModel>?>(null);
  @override
  Stream<List<InsertProductsViewModel>?> get insertProductsViewModelStream =>
      _insertProductsViewModel.stream;
}
