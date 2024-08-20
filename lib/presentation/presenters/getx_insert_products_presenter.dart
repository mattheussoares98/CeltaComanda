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

  void _insertProductDataInInsertViewModelTempList({
    required List<InsertProductsViewModel> insertViewModel,
    required ProductsViewModel product,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) {
    bool productHasComment =
        expansibleGroupFromProductPresenter.productHasComment(
      product: product,
      indexOfChild: _selectedOptionIndex.value,
    );
    bool productHasObligatoryOptions =
        expansibleGroupFromProductPresenter.productHasObligatoryOption(
      product: product,
      indexOfChild: _selectedOptionIndex.value,
    );

    if (productHasComment) {
      insertViewModel.add(InsertProductsViewModel(selectedOptions: {
        SelectedOptionType.optionalExpansibleGroup:
            expansibleGroupFromProductPresenter.loadedComments
                .where(
                  (e) =>
                      e.ProductInternalCodeOnErp == product.InternalCodeOnERP,
                )
                .toList(),
      }));
    }
    if (productHasObligatoryOptions) {
      insertViewModel.add(InsertProductsViewModel(
        selectedOptions: {
          SelectedOptionType.obligatoryExpansibleGroup:
              expansibleGroupFromProductPresenter.loadedObligatoryOptions
                  .where(
                    (e) =>
                        e.ProductInternalCodeOnErp == product.InternalCodeOnERP,
                  )
                  .toList(),
        },
      ));
    }
  }

  void _insertFatherDataInInsertViewModelTempList({
    required List<InsertProductsViewModel> insertViewModel,
    required ProductsViewModel product,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) {
    for (int index = 0; index < product.childsComposition!.length; index++) {
      final father = product.childsComposition![index];
      bool fatherHasComment =
          expansibleGroupFromProductPresenter.productHasComment(
        product: product,
        indexOfChild: index,
      );
      bool fatherHasObligatoryOptions =
          expansibleGroupFromProductPresenter.productHasObligatoryOption(
        product: product,
        indexOfChild: index,
      );

      insertViewModel.add(
        InsertProductsViewModel(
          selectedOptions: {
            SelectedOptionType.fatherComposition: father,
          },
        ),
      );

      if (fatherHasComment) {
        insertViewModel.add(InsertProductsViewModel(
          selectedOptions: {
            SelectedOptionType.optionalExpansibleGroup:
                expansibleGroupFromProductPresenter.loadedObligatoryOptions
                    .where(
                      (e) =>
                          e.ProductInternalCodeOnErp ==
                          father.InternalCodeOnERPCodeChild,
                    )
                    .toList(),
          },
        ));
      }
      if (fatherHasObligatoryOptions) {
        insertViewModel.add(InsertProductsViewModel(
          selectedOptions: {
            SelectedOptionType.obligatoryExpansibleGroup:
                expansibleGroupFromProductPresenter.loadedObligatoryOptions
                    .where(
                      (e) =>
                          e.ProductInternalCodeOnErp ==
                          father.InternalCodeOnERPCodeChild,
                    )
                    .toList(),
          },
        ));
      }
    }
  }

  @override
  Future<void> updateSelectedProduct({
    required ProductsViewModel product,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) async {
    totalProductsQuantity = 1;

    selectedComboxProduct = product;

    List<InsertProductsViewModel> insertViewModel = [];

    if (product.childsComposition == null) {
      _insertProductDataInInsertViewModelTempList(
        insertViewModel: insertViewModel,
        product: product,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    } else {
      _insertFatherDataInInsertViewModelTempList(
        insertViewModel: insertViewModel,
        product: product,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    }

    insertViewModel.add(
      const InsertProductsViewModel(
        selectedOptions: {
          SelectedOptionType.quantity: null,
        },
      ),
    );
    _insertProductsViewModel.value = insertViewModel;

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
        Peoples: cartPresenter.saleRequestTemp!.Peoples.toInt(),
        Comments: cartPresenter.saleRequestTemp!.Comments,
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
      if (selectedProductValue?.MaximumQuantityForSale != null &&
          selectedProductValue!.MaximumQuantityForSale!.toDouble() > 1 &&
          totalProductsQuantity + 1 >
              (selectedProductValue?.MaximumQuantityForSale!.toDouble() ??
                  99)) {
        mainError = UIError.maximumQuantityAchieved;
      } else {
        totalProductsQuantity = totalProductsQuantity + 1;
      }
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
  void updateOptionIndex({
    required int newIndex,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) {
    if (newIndex <= _selectedOptionIndex.value) {
      selectedOptionIndex = newIndex;
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
    selectedOptionIndex = 0;
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
  void advanceOptionIndex(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  ) {
    doScroll = true;
    final atualOption = _insertProductsViewModel
        .value![_selectedOptionIndex.value].selectedOptions.keys.first;
    final atualValue = _insertProductsViewModel
        .value![_selectedOptionIndex.value].selectedOptions.values.first;

    if (atualOption == SelectedOptionType.optionalExpansibleGroup) {
      _selectedOptionIndex.value = _selectedOptionIndex.value + 1;
    } else if (atualOption == SelectedOptionType.fatherComposition) {
      if (fatherIsValid(atualValue as ProductCompositionViewModel)) {
        _selectedOptionIndex.value = _selectedOptionIndex.value + 1;
      }
    } else if (atualOption == SelectedOptionType.obligatoryExpansibleGroup) {
      ExpansibleGroupFromProductViewModel? selectedGroup =
          expansibleGroupFromProductPresenter.loadedObligatoryOptions
              .firstWhereOrNull((e) => e.selected);

      if (selectedGroup != null) {
        _selectedOptionIndex.value = _selectedOptionIndex.value + 1;
      }
    }

    updateCanAdvanceIndex(expansibleGroupFromProductPresenter);
  }

  @override
  void updateCanAdvanceIndex(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  ) {
    final atualOption = _insertProductsViewModel
        .value![_selectedOptionIndex.value].selectedOptions.keys.first;
    final atualValue = _insertProductsViewModel
        .value![_selectedOptionIndex.value].selectedOptions.values.first;

    if (atualOption == SelectedOptionType.quantity) {
      canAdvanceIndex = true;
    } else if (atualOption == SelectedOptionType.optionalExpansibleGroup) {
      canAdvanceIndex = true;
    } else if (atualOption == SelectedOptionType.fatherComposition) {
      final selectedFather = (atualValue as ProductCompositionViewModel);

      if (fatherIsValid((selectedFather))) {
        canAdvanceIndex = true;
      } else {
        canAdvanceIndex = false;
      }
    } else if (atualOption == SelectedOptionType.obligatoryExpansibleGroup) {
      ExpansibleGroupFromProductViewModel? selectedGroup =
          expansibleGroupFromProductPresenter.loadedObligatoryOptions
              .firstWhereOrNull((e) => e.selected);

      if (selectedGroup != null) {
        canAdvanceIndex = true;
      } else {
        canAdvanceIndex = false;
      }
    } else {
      canAdvanceIndex = false;
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

  final _selectedOptionIndex = Rx<int>(0);
  set selectedOptionIndex(int value) {
    _selectedOptionIndex.value = value;
  }

  @override
  Stream<int> get selectedLeftIndexStream => _selectedOptionIndex.stream;

  final _insertProductsViewModel = Rx<List<InsertProductsViewModel>?>(null);
  @override
  Stream<List<InsertProductsViewModel>?> get insertProductsViewModelStream =>
      _insertProductsViewModel.stream;

  @override
  ProductCompositionViewModel? getLastSelectedFather(int indexOfAtualOption) {
    final atualInsertProductViewModel =
        _insertProductsViewModel.value?[indexOfAtualOption];

    if (atualInsertProductViewModel == null) {
      return null;
    }

    int? index =
        _insertProductsViewModel.value?.indexOf(atualInsertProductViewModel);

    if (selectedProductValue?.childsComposition == null) {
      return null;
    } else if (atualInsertProductViewModel.selectedOptions.keys.first ==
        SelectedOptionType.fatherComposition) {
      return (atualInsertProductViewModel.selectedOptions.values.first
          as ProductCompositionViewModel);
    } else if (_insertProductsViewModel
            .value?[(index ?? 0) - 1].selectedOptions.keys.first ==
        SelectedOptionType.fatherComposition) {
      return (_insertProductsViewModel.value?[(index ?? 0) - 1].selectedOptions
          .values.first as ProductCompositionViewModel);
    } else if (_insertProductsViewModel
            .value?[(index ?? 0) - 2].selectedOptions.keys.first ==
        SelectedOptionType.fatherComposition) {
      return (_insertProductsViewModel.value?[(index ?? 0) - 2].selectedOptions
          .values.first as ProductCompositionViewModel);
    } else {
      return null;
    }
  }
}
