import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import '../../ui/mocks/mocks.dart';

void main() {
  late GetxInsertProductsPresenter sut;
  late HomePresenterSpy homePresenter;
  late CartPresenterSpy cartPresenter;
  late ExpansibleGroupFromProductPresenterSpy
      expansibleGroupFromProductPresenter;

  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late ValidateComboxSpy validateCombox;

  late List<ProductCompositionEntity> optionalFathers;
  late ProductCompositionViewModel obligatoryFather;
  late SaleRequestTempEntity saleRequestTempEntity;
  late ProductsViewModel selectedProduct;
  late ProductCompositionViewModel validFather;
  late ProductCompositionViewModel invalidFather;
  late InsertProductsViewModel obligatoryOptionsInsertProductsViewModel;
  late InsertProductsViewModel optionalOptionsInsertProductsViewModel;
  late InsertProductsViewModel quantityInsertProductsViewModel;
  late InsertProductsViewModel fatherInsertProductsViewModel;
  late InsertProductsViewModel fatherOptionalInsertProductsViewModel;
  late InsertProductsViewModel fatherObligatoryInsertProductsViewModel;

  UpdateSaleRequestTempEntity makeUpdateSaleRequestTempEntity({
    required ProductCompositionViewModel productCompositionViewModel,
    required double totalLiquid,
    required double productValue,
  }) {
    final updateSaleRequestTempEntity = UpdateSaleRequestTempEntity(
        PlaceId: cartPresenter.saleRequestTempMock!.PlaceId,
        Peoples: cartPresenter.saleRequestTempMock!.Peoples?.toInt(),
        SellerCode: cartPresenter.saleRequestTempMock!.SellerCode,
        Comments: cartPresenter.saleRequestTempMock!.Comments,
        DeliveryControl:
            cartPresenter.saleRequestTempMock!.DeliveryControl.toInt(),
        EnterpriseId: cartPresenter.saleRequestTempMock!.EnterpriseId.toInt(),
        PersonalizedCode: cartPresenter.saleRequestTempMock!.PersonalizedCode,
        SaleRequestTempId:
            cartPresenter.saleRequestTempMock!.SaleRequestTempId.toInt(),
        TotalLiquid: totalLiquid,
        CustomerCode: cartPresenter.saleRequestTempMock!.CustomerCode?.toInt(),
        CovenantCode: cartPresenter.saleRequestTempMock!.CovenantCode?.toInt(),
        IncrementValue:
            EnterpriseBuilder.entity?.serviceChargePercentageOrValue,
        IncrementType: 1,
        Products: [
          UpdateSaleRequestTempProductEntity(
            ProductInternalCodeOnErp: 1,
            ProductPriceLookUpCode: "PluChild",
            Quantity:
                productCompositionViewModel.Quantity.toString().toDouble(),
            SaleRequestTempId:
                cartPresenter.saleRequestTempMock!.SaleRequestTempId.toInt(),
            TotalLiquid: totalLiquid,
            Value: productValue,
            Comments: "",
            SaleRequestProductIdOfFather: productCompositionViewModel
                .InternalCodeOnERPCodeFather?.toInt(),
            ProductIsFatherComposition: false,
          ),
        ]);

    return updateSaleRequestTempEntity;
  }

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initPresenters() {
    sut = GetxInsertProductsPresenter(
      updateSaleRequestTemp: updateSaleRequestTemp,
      validateCombox: validateCombox,
    );
    homePresenter = HomePresenterSpy();
    cartPresenter = CartPresenterSpy();
    expansibleGroupFromProductPresenter =
        ExpansibleGroupFromProductPresenterSpy();
  }

  void initUsecases() {
    updateSaleRequestTemp = UpdateSaleRequestTempSpy();
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    validateCombox = ValidateComboxSpy();
  }

  void initMocks() {
    loadSaleRequestTemp.mockLoadSaleRequestTemp(saleRequestTempEntity);
    expansibleGroupFromProductPresenter.mockProductHasComment(true);
    expansibleGroupFromProductPresenter.mockProductHasObligatoryOptions(true);
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
    optionalFathers =
        EntityFactory.makeProductsCompositionsEntity(isOptionalItem: true);
    saleRequestTempEntity = EntityFactory.makeSaleRequestTempEntity(0);

    cartPresenter.saleRequestTempMock =
        SaleRequestTempViewModel.fromEntity(saleRequestTempEntity);

    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();

    homePresenter.commandEntityController = CommandEntity(
      commandNumber:
          faker.randomGenerator.integer(100).toString().padLeft(3, "0"),
      isFixedCommandNumber: faker.randomGenerator.boolean(),
      pdv: EntityFactory.makePdvEntity(),
    );

    obligatoryFather = EntityFactory.makeProductCompositionViewModel(
      quantity: faker.randomGenerator.decimal(),
      salePrice: faker.randomGenerator.decimal(),
      offerPrice: faker.randomGenerator.decimal(),
      fatherIncrement: faker.randomGenerator.decimal(),
      childIncrement: faker.randomGenerator.decimal(),
      isOptionalItem: false,
      indexOfSelectedChild: null,
      insertChilds: false,
      isPromoCombox: false,
    );

    selectedProduct = EntityFactory.makeProductsViewModel(
      insertChildsComposition: true,
      isOptionalChilds: false,
      maximumProductQuantity: 3,
    );

    invalidFather = EntityFactory.makeProductCompositionViewModel(
      quantity: faker.randomGenerator.decimal(),
      salePrice: faker.randomGenerator.decimal(),
      offerPrice: faker.randomGenerator.decimal(),
      fatherIncrement: faker.randomGenerator.decimal(),
      childIncrement: faker.randomGenerator.decimal(),
      isOptionalItem: false,
      indexOfSelectedChild: null,
      insertChilds: false,
      isPromoCombox: false,
    );
    validFather = EntityFactory.makeProductCompositionViewModel(
      quantity: faker.randomGenerator.decimal(),
      salePrice: faker.randomGenerator.decimal(),
      offerPrice: faker.randomGenerator.decimal(),
      fatherIncrement: faker.randomGenerator.decimal(),
      childIncrement: faker.randomGenerator.decimal(),
      isOptionalItem: false,
      indexOfSelectedChild: 0,
      insertChilds: false,
      isPromoCombox: false,
    );

    optionalOptionsInsertProductsViewModel = InsertProductsViewModel(
      selectedOptions: {
        SelectedOptionType.optionalExpansibleGroup:
            expansibleGroupFromProductPresenter.loadedComments
                .where(
                  (e) =>
                      e.ProductInternalCodeOnErp ==
                      selectedProduct.InternalCodeOnERP,
                )
                .toList(),
      },
    );
    obligatoryOptionsInsertProductsViewModel = InsertProductsViewModel(
      selectedOptions: {
        SelectedOptionType.obligatoryExpansibleGroup:
            expansibleGroupFromProductPresenter.loadedObligatoryOptions
                .where(
                  (e) =>
                      e.ProductInternalCodeOnErp ==
                      selectedProduct.InternalCodeOnERP,
                )
                .toList(),
      },
    );
    quantityInsertProductsViewModel = const InsertProductsViewModel(
      selectedOptions: {
        SelectedOptionType.quantity: null,
      },
    );
    fatherInsertProductsViewModel = InsertProductsViewModel(
      selectedOptions: {
        SelectedOptionType.fatherComposition:
            selectedProduct.childsComposition![0],
      },
    );
    fatherOptionalInsertProductsViewModel =
        InsertProductsViewModel(selectedOptions: {
      SelectedOptionType.optionalExpansibleGroup:
          expansibleGroupFromProductPresenter.loadedComments
              .where((e) =>
                  e.ProductInternalCodeOnErp ==
                  selectedProduct
                      .childsComposition![0].InternalCodeOnERPCodeChild)
              .toList(),
    });
    fatherObligatoryInsertProductsViewModel =
        InsertProductsViewModel(selectedOptions: {
      SelectedOptionType.obligatoryExpansibleGroup:
          expansibleGroupFromProductPresenter.loadedObligatoryOptions
              .where((e) =>
                  e.ProductInternalCodeOnErp ==
                  selectedProduct
                      .childsComposition![0].InternalCodeOnERPCodeChild)
              .toList(),
    });
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMocks();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseData());
    registerFallbackValue(EntityFactory.makeUpdateSaleRequestTempEntity());
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    registerFallbackValue(EntityFactory.makeCartProductEntity(
      maximumProductQuantity: 0,
      minimumProductQuantity: 0,
    ));
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
  });

  group("updateSelectedProduct", () {
    test(
        'Should change totalComboxQuantity correctly when updateValue and to 1 when call LoadProductComposition',
        () async {
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      sut.updateTotalProductsQuantity(isAddingQuantity: true);
      expect(sut.totalProductsQuantity, 2);
      sut.updateTotalProductsQuantity(isAddingQuantity: true);
      expect(sut.totalProductsQuantity, 3);
      sut.updateTotalProductsQuantity(isAddingQuantity: false);
      expect(sut.totalProductsQuantity, 2);

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.totalProductsQuantity, 1);
    });

    test(
        'Should update indexOfSelctedChild if father is obligatory and childs is empty',
        () async {
      selectedProduct.childsComposition!.first.indexOfSelectedChild = 0;
      //quando o produto é obrigatório e não tem filhos, precisa ter um índice
      //selecionado pra na tela da composição, aparecer que ele já foi
      //selecionado. Por isso faz essa alteração

      expectLater(sut.selectedProductStream, emits(selectedProduct));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });

    test(
        'Should update selectedComboxProduct when call sut.updateSelectedProduct',
        () async {
      expectLater(sut.selectedProductStream, emits(selectedProduct));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
  });

  group("UpdateSelectedFather", () {
    test("Should not advance selectedOptionIndex if atual father is invalid",
        () async {
      selectedProduct.childsComposition = [
        EntityFactory.makeProductCompositionViewModel(
          quantity: faker.randomGenerator.decimal(),
          salePrice: faker.randomGenerator.decimal(),
          offerPrice: faker.randomGenerator.decimal(),
          fatherIncrement: faker.randomGenerator.decimal(),
          childIncrement: faker.randomGenerator.decimal(),
          isOptionalItem: false,
          indexOfSelectedChild: null,
          insertChilds: false,
          isPromoCombox: false,
        )
      ];

      expectLater(sut.selectedLeftIndexStream, emits(0));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateOptionIndex(
        newIndex: 0,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateOptionIndex(
        newIndex: 1,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });

    test("Should never advance index if newIndex is greather than atual index",
        () async {
      selectedProduct.childsComposition = [
        validFather,
        validFather,
        validFather,
      ];

      expectLater(sut.selectedLeftIndexStream, emits(0));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateOptionIndex(
        newIndex: 0,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateOptionIndex(
        newIndex: 1,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateOptionIndex(
        newIndex: 2,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });

    test("Should emit correct values on doScrollStream", () async {
      expectLater(sut.doScrollStream, emitsInOrder([true, false]));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      sut.updateOptionIndex(
        newIndex: 0,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
  });

  group("clearSelectedComboxData", () {
    test("Should update index of selected father to zero", () async {
      expectLater(sut.selectedLeftIndexStream, emitsInOrder([1, 0]));
      selectedProduct.childsComposition = null;

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.advanceOptionIndex(expansibleGroupFromProductPresenter);
      sut.clearData(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });

    test("Should update index of all selected childs to null", () {
      for (var child in selectedProduct.childsComposition!) {
        child.indexOfSelectedChild = 0;
      }
      expect(selectedProduct.childsComposition![0].indexOfSelectedChild, 0);

      sut.clearData(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(selectedProduct.childsComposition![0].indexOfSelectedChild, null);
    });

    test("Should clear all comments", () {
      for (var child in selectedProduct.childsComposition!) {
        child.commentFather = "comentário";
      }
      expect(selectedProduct.childsComposition![0].commentFather, "comentário");

      sut.clearData(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(selectedProduct.childsComposition![0].commentFather, null);
    });

    test("Should update combox quantity to 1", () async {
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      sut.updateTotalProductsQuantity(isAddingQuantity: true);
      expect(sut.totalProductsQuantity, 2);

      sut.clearData(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(sut.totalProductsQuantity, 1);
    });

    test("Should not reduce quantity when atual quantity is 1", () {
      sut.updateTotalProductsQuantity(isAddingQuantity: false);
      sut.updateTotalProductsQuantity(isAddingQuantity: false);
      sut.updateTotalProductsQuantity(isAddingQuantity: false);
      expect(sut.totalProductsQuantity, 1);
    });

    test("Should call expansibleGroupFromProductPresenter.unselectAllComments",
        () {
      sut.clearData(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => expansibleGroupFromProductPresenter.unselectAllComments())
          .called(1);
    });
  });
  group("sut.UpdateSaleRequestTemp", () {
    test(
        "Should call sut.updateSaleRequest with correct values of price and totalLiquid 1",
        () async {
      final case1 = EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 0,
        fatherIncrement: 0,
        isOptionalItem: false,
        indexOfSelectedChild: 0,
        insertChilds: false,
        childIncrement: 0,
        isPromoCombox: false,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case1],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: makeUpdateSaleRequestTempEntity(
              productCompositionViewModel: case1,
              totalLiquid: 10,
              productValue: 10,
            ),
          )).called(1);
    });
    test(
        "Should call sut.updateSaleRequest with correct values of price and totalLiquid 2",
        () async {
      final case2 = EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 8,
        fatherIncrement: 0,
        isOptionalItem: false,
        indexOfSelectedChild: 0,
        insertChilds: false,
        childIncrement: 0,
        isPromoCombox: false,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case2],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: makeUpdateSaleRequestTempEntity(
              productCompositionViewModel: case2,
              totalLiquid: 8,
              productValue: 8,
            ),
          )).called(1);
    });
    test(
        "Should call sut.updateSaleRequest with correct values of price and totalLiquid 3",
        () async {
      final case3 = EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 8,
        fatherIncrement: 0,
        isOptionalItem: true,
        indexOfSelectedChild: 0,
        insertChilds: false,
        childIncrement: 0,
        isPromoCombox: false,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case3],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: makeUpdateSaleRequestTempEntity(
              productCompositionViewModel: case3,
              totalLiquid: 0,
              productValue: 0,
            ),
          )).called(1);
    });
    test(
        "Should call sut.updateSaleRequest with correct values of price and totalLiquid 4",
        () async {
      final case4 = EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 8,
        fatherIncrement: 5,
        isOptionalItem: true,
        indexOfSelectedChild: 0,
        insertChilds: false,
        childIncrement: 0,
        isPromoCombox: false,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case4],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: makeUpdateSaleRequestTempEntity(
              productCompositionViewModel: case4,
              totalLiquid: 5,
              productValue: 5,
            ),
          )).called(1);
    });
    test(
        "Should call sut.updateSaleRequest with correct values of price and totalLiquid 5",
        () async {
      final case5 = EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 8,
        fatherIncrement: 5,
        isOptionalItem: false,
        indexOfSelectedChild: 0,
        insertChilds: false,
        childIncrement: 0,
        isPromoCombox: false,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case5],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: makeUpdateSaleRequestTempEntity(
              productCompositionViewModel: case5,
              totalLiquid: 13,
              productValue: 13,
            ),
          )).called(1);
    });
    test(
        "Should call sut.updateSaleRequest with correct values of price and totalLiquid 6",
        () async {
      final case6 = EntityFactory.makeProductCompositionViewModel(
        quantity: 2,
        salePrice: 10,
        offerPrice: 8,
        fatherIncrement: 5,
        isOptionalItem: false,
        indexOfSelectedChild: 0,
        insertChilds: false,
        childIncrement: 0,
        isPromoCombox: false,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case6],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: makeUpdateSaleRequestTempEntity(
              productCompositionViewModel: case6,
              totalLiquid: 26,
              productValue: 13,
            ),
          )).called(1);
    });
    test(
        "Should call sut.updateSaleRequest with correct values of price and totalLiquid 7",
        () async {
      final case7 = EntityFactory.makeProductCompositionViewModel(
        quantity: 2,
        salePrice: 10,
        offerPrice: 8,
        fatherIncrement: 5,
        isOptionalItem: true,
        indexOfSelectedChild: 0,
        insertChilds: false,
        childIncrement: 0,
        isPromoCombox: false,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case7],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: makeUpdateSaleRequestTempEntity(
              productCompositionViewModel: case7,
              totalLiquid: 10,
              productValue: 5,
            ),
          )).called(1);
    });
    test(
        "Should call sut.updateSaleRequest with correct values of price and totalLiquid 8",
        () async {
      final case8 = EntityFactory.makeProductCompositionViewModel(
        quantity: 2,
        salePrice: 10,
        offerPrice: 8,
        fatherIncrement: 0,
        isOptionalItem: false,
        indexOfSelectedChild: 0,
        insertChilds: true,
        childIncrement: 20,
        isPromoCombox: true,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case8],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: makeUpdateSaleRequestTempEntity(
              productCompositionViewModel: case8,
              totalLiquid: 56,
              productValue: 28,
            ),
          )).called(1);
    });
    test("Should emit correct events on sut.updateSaleRequest success",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.comboxIsValidStream, emits(true));

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: optionalFathers
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );
    });
    test("Should return true on updateSaleRequest success", () async {
      final updated = await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: optionalFathers
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );

      expect(updated, true);
    });
    test("Should return false on updateSaleRequest throws", () async {
      updateSaleRequestTemp
          .mockUpdateSaleRequestTempError(DomainError.unexpected);
      final updated = await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: optionalFathers
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );

      expect(updated, false);
    });
    test("Should call validateCombox on updateSaleRequest", () async {
      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: optionalFathers
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );

      verify(() => validateCombox.comboxIsValid(optionalFathers
          .map((element) => ProductCompositionViewModel.fromEntity(element))
          .toList())).called(1);
    });

    test("Should emit correct values when validateCombox return false",
        () async {
      validateCombox.mockValidateCombox(false);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.invalidCombox]));
      expectLater(sut.comboxIsValidStream, emits(false));

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: optionalFathers
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );
    });
    test(
        "Should not call updateSaleRequest and loadSaleRequest when combox is invalid",
        () async {
      validateCombox.mockValidateCombox(false);
      final case1 = EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 0,
        fatherIncrement: 0,
        isOptionalItem: false,
        indexOfSelectedChild: 0,
        insertChilds: false,
        childIncrement: 0,
        isPromoCombox: false,
      );

      await sut.updateSaleRequest(
          homePresenter: homePresenter,
          cartPresenter: cartPresenter,
          productsCompositions: [case1]);

      verifyNever(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: makeUpdateSaleRequestTempEntity(
              productCompositionViewModel: case1,
              totalLiquid: 10,
              productValue: 10,
            ),
          ));

      verifyNever(() => cartPresenter.getSaleRequestTemp(
          homePresenter.commandEntityController!.commandNumber!));
    });
    test("Should call updateSaleRequestTemp on updateSaleRequest", () async {
      final case1 = EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 0,
        fatherIncrement: 0,
        isOptionalItem: false,
        indexOfSelectedChild: 0,
        insertChilds: false,
        childIncrement: 0,
        isPromoCombox: false,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case1],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: makeUpdateSaleRequestTempEntity(
              productCompositionViewModel: case1,
              totalLiquid: 10,
              productValue: 10,
            ),
          ));
    });
    test(
        "Should emit correct events on updateSaleRequestTemp.update throws (unexpected)",
        () async {
      updateSaleRequestTemp
          .mockUpdateSaleRequestTempError(DomainError.unexpected);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: optionalFathers
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );
    });
    test(
        "Should emit correct events on updateSaleRequestTemp.update throws (commandNotAvailable)",
        () async {
      updateSaleRequestTemp
          .mockUpdateSaleRequestTempError(DomainError.commandNotAvailable);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: optionalFathers
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );
    });
    test("Should call cartPresenter.loadSaleRequest with correct values",
        () async {
      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: optionalFathers
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );

      verify(() => cartPresenter.getSaleRequestTemp(
          homePresenter.commandEntityController!.commandNumber!)).called(1);
    });
    test("Should emit correct values on cartPresenter.load throws unexpected",
        () async {
      cartPresenter.mockLoadSaleRequestTempError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: optionalFathers
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );
    });
    test(
        "Should emit correct values on cartPresenter.load throws commandNotAvailable",
        () async {
      cartPresenter
          .mockLoadSaleRequestTempError(DomainError.commandNotAvailable);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: optionalFathers
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );
    });

    test('Should return correct entity on success to loadSaleRequestTemp',
        () async {
      final value = await loadSaleRequestTemp.load(
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
      );

      expect(value, saleRequestTempEntity);
    });

    test(
        "Should emit CommandNotAvailable on cartPresenter.loadSaleRequest throws CommandNotAvailable",
        () async {
      cartPresenter
          .mockLoadSaleRequestTempError(DomainError.commandNotAvailable);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: optionalFathers
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );
    });
    test(
        "Should emit unexpected on cartPresenter.loadSaleRequest throws unexpected",
        () async {
      cartPresenter.mockLoadSaleRequestTempError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: optionalFathers
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );
    });
  });

  group("update selected child", () {
    test(
        "Should update selected index of child if click in product that have child",
        () async {
      final optionalFather =
          ProductCompositionViewModel.fromEntity(optionalFathers[0]);

      expect(optionalFather.indexOfSelectedChild, null);

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateSelectedIndexOfProduct(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        father: optionalFather,
        index: 0,
      );
      expect(optionalFather.indexOfSelectedChild, 0);
    });
    test(
        "Should not update index if click in the same product and father is not optional",
        () async {
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateSelectedIndexOfProduct(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        father: obligatoryFather,
        index: 0,
      );
      sut.updateSelectedIndexOfProduct(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        father: obligatoryFather,
        index: 0,
      );

      expect(obligatoryFather.indexOfSelectedChild, 0);
    });
    test("Should update index if click in the same product and is optional",
        () async {
      final optionalFather =
          ProductCompositionViewModel.fromEntity(optionalFathers[0]);

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      sut.updateSelectedIndexOfProduct(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        father: optionalFather,
        index: 0,
      );
      sut.updateSelectedIndexOfProduct(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        father: optionalFather,
        index: 0,
      );

      expect(optionalFather.indexOfSelectedChild, null);
    });
  });

  group("Father is valid", () {
    test("Should return false if father is null", () {
      final isValid = sut.fatherIsValid(null);

      expect(isValid, false);
    });
    test("Should return true if father is obligatory and index is not null",
        () {
      final isValid = sut.fatherIsValid(validFather);

      expect(isValid, true);
    });
    test("Should return false if father is obligatory and index is null", () {
      final isValid = sut.fatherIsValid(invalidFather);

      expect(isValid, false);
    });
  });

  group("Advance Father index", () {
    test("Should advance index if atual option is optionalExpansibleGroup",
        () async {
      selectedProduct.childsComposition = null;

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expectLater(sut.selectedLeftIndexStream, emits(1));

      sut.advanceOptionIndex(expansibleGroupFromProductPresenter);
    });
    test(
        "Should advance index if atual option is fatherComposition and father is valid",
        () async {
      selectedProduct.childsComposition = [validFather];

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expectLater(sut.selectedLeftIndexStream, emits(1));

      sut.advanceOptionIndex(expansibleGroupFromProductPresenter);
    });
    test(
        "Should advance index if atual option is obligatoryExpansibleGroup and has selected option",
        () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      expansibleGroupFromProductPresenter.loadedObligatoryOptionsController = [
        EntityFactory.makeExpansibleGroupFromProductViewModel(selected: true)
      ];
      selectedProduct.childsComposition = null;

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expectLater(sut.selectedLeftIndexStream, emits(1));

      sut.advanceOptionIndex(expansibleGroupFromProductPresenter);
    });

    test("Should emit correct values doScrollStream when advanceOptionIndex",
        () async {
      expectLater(sut.doScrollStream, emitsInOrder([true, false]));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      sut.advanceOptionIndex(expansibleGroupFromProductPresenter);
    });
  });

  group("Update can advance index", () {
    test("Should emit only true if pass a true value", () {
      expectLater(sut.canAdvanceIndexStream, emits(true));

      sut.updateCanAdvanceIndex(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        value: true,
      );
    });
    test("Should emit only false if pass a false value", () {
      expectLater(sut.canAdvanceIndexStream, emits(false));

      sut.updateCanAdvanceIndex(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        value: false,
      );
    });
    test("Should emit true if atual option is quantity", () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      expansibleGroupFromProductPresenter
          .mockProductHasObligatoryOptions(false);
      selectedProduct.childsComposition = null;

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expectLater(sut.canAdvanceIndexStream, emits(true));

      sut.updateCanAdvanceIndex(
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter);
    });

    test("Should emit true if atual option is optionalExpansibleGroup",
        () async {
      selectedProduct.childsComposition = null;

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expectLater(sut.canAdvanceIndexStream, emits(true));

      sut.updateCanAdvanceIndex(
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter);
    });
    test(
        "Should emit true if atual option is fatherComposition and has a valid father",
        () async {
      selectedProduct.childsComposition = [validFather];

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expectLater(sut.canAdvanceIndexStream, emits(true));

      sut.updateCanAdvanceIndex(
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter);
    });
    test(
        "Should emit false if atual option is fatherComposition and has a invalid father",
        () async {
      selectedProduct.childsComposition = [invalidFather];

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expectLater(sut.canAdvanceIndexStream, emits(false));

      sut.updateCanAdvanceIndex(
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter);
    });
    test(
        "Should emit true if atual option is obligatoryExpansibleGroup and has a ooption selected",
        () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      expansibleGroupFromProductPresenter.loadedObligatoryOptionsController = [
        EntityFactory.makeExpansibleGroupFromProductViewModel(selected: true)
      ];
      selectedProduct.childsComposition = null;

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expectLater(sut.canAdvanceIndexStream, emits(true));

      sut.updateCanAdvanceIndex(
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter);
    });
    test(
        "Should emit false if atual option is obligatoryExpansibleGroup and has a ooption selected",
        () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      expansibleGroupFromProductPresenter.loadedObligatoryOptionsController = [
        EntityFactory.makeExpansibleGroupFromProductViewModel(selected: false)
      ];
      selectedProduct.childsComposition = null;

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expectLater(sut.canAdvanceIndexStream, emits(false));

      sut.updateCanAdvanceIndex(
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter);
    });
  });

  group("Update product price without childsComposition", () {
    test("Should update price when update selected product", () async {
      expectLater(
          sut.totalPriceStream,
          emits(
            selectedProduct.SaleRetailPraticed.toDouble(),
          ));

      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test("Should update price add product quantity", () async {
      expectLater(
          sut.totalPriceStream,
          emitsInOrder([
            selectedProduct.SaleRetailPraticed.toDouble(),
            selectedProduct.SaleRetailPraticed.toDouble() * 2,
            selectedProduct.SaleRetailPraticed.toDouble() * 3,
            selectedProduct.SaleRetailPraticed.toDouble() * 2,
          ]));

      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateTotalProductsQuantity(isAddingQuantity: true);
      sut.updateTotalProductsQuantity(isAddingQuantity: true);
      sut.updateTotalProductsQuantity(isAddingQuantity: false);
    });
    test("Should update total liquid when update selected product", () async {
      expectLater(
          sut.totalPriceStream,
          emits(
            selectedProduct.SaleRetailPraticed.toDouble(),
          ));

      selectedProduct.childsComposition = null;

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });

    test(
        "Should update insertProductViewModel correctly when has obligatory and optional groups",
        () async {
      expectLater(
          sut.insertProductsViewModelStream,
          emits(
            [
              optionalOptionsInsertProductsViewModel,
              obligatoryOptionsInsertProductsViewModel,
              quantityInsertProductsViewModel,
            ],
          ));

      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test(
        "Should update insertProductViewModel correctly when dont have obligatory groups",
        () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);

      expectLater(
          sut.insertProductsViewModelStream,
          emits(
            [
              obligatoryOptionsInsertProductsViewModel,
              quantityInsertProductsViewModel,
            ],
          ));

      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test(
        "Should update insertProductViewModel correctly when dont have optional groups",
        () async {
      expansibleGroupFromProductPresenter
          .mockProductHasObligatoryOptions(false);

      expectLater(
          sut.insertProductsViewModelStream,
          emits(
            [
              optionalOptionsInsertProductsViewModel,
              quantityInsertProductsViewModel,
            ],
          ));

      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
  });
  group("Update product price with childsComposition", () {
    test("Should update price when update selected product", () async {
      expectLater(
          sut.totalPriceStream,
          emits(
            sut.calculateProductCompositionTotalLiquid(
              product: selectedProduct.childsComposition![0],
            ),
          ));

      selectedProduct.childsComposition![0].indexOfSelectedChild = 0;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test("Should update price add product quantity", () async {
      expectLater(
          sut.totalPriceStream,
          emitsInOrder([
            sut.calculateProductCompositionTotalLiquid(
              product: selectedProduct.childsComposition![0],
            ),
            sut.calculateProductCompositionTotalLiquid(
                  product: selectedProduct.childsComposition![0],
                ) *
                2,
            sut.calculateProductCompositionTotalLiquid(
                  product: selectedProduct.childsComposition![0],
                ) *
                3,
            sut.calculateProductCompositionTotalLiquid(
                  product: selectedProduct.childsComposition![0],
                ) *
                2,
          ]));

      selectedProduct.childsComposition![0].indexOfSelectedChild = 0;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateTotalProductsQuantity(isAddingQuantity: true);
      sut.updateTotalProductsQuantity(isAddingQuantity: true);
      sut.updateTotalProductsQuantity(isAddingQuantity: false);
    });
    test("Should update total liquid when update selected product", () async {
      expectLater(
          sut.totalPriceStream,
          emits(
            sut.calculateProductCompositionTotalLiquid(
              product: selectedProduct.childsComposition![0],
            ),
          ));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test("Should emit correct values in insertProductsViewModelStream",
        () async {
      expectLater(
          sut.insertProductsViewModelStream,
          emits(
            [
              fatherInsertProductsViewModel,
              fatherOptionalInsertProductsViewModel,
              fatherObligatoryInsertProductsViewModel,
              quantityInsertProductsViewModel,
            ],
          ));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test(
        "Should emit correct values in insertProductsViewModelStream when dont have optional groups",
        () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      expectLater(
          sut.insertProductsViewModelStream,
          emits(
            [
              fatherInsertProductsViewModel,
              fatherObligatoryInsertProductsViewModel,
              quantityInsertProductsViewModel,
            ],
          ));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test(
        "Should emit correct values in insertProductsViewModelStream when dont have obligatory options",
        () async {
      expansibleGroupFromProductPresenter
          .mockProductHasObligatoryOptions(false);
      expectLater(
          sut.insertProductsViewModelStream,
          emits(
            [
              fatherInsertProductsViewModel,
              fatherOptionalInsertProductsViewModel,
              quantityInsertProductsViewModel,
            ],
          ));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
  });

  group("Get last selected father", () {
    test("Should return null if selected product is null", () async {
      final result = sut.getLastSelectedFather(0);

      expect(result, isNull);
    });
    test(
        "Should return ProductCompositionViewModel if atualInsertProductViewModel is fatherComposition",
        () async {
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      final result = sut.getLastSelectedFather(0);

      expect(result, selectedProduct.childsComposition?[0]);
    });
    test(
        "Should return last ProductCompositionViewModel if index of insertProductsViewModel -1 is equal fatherComposition",
        () async {
      selectedProduct.childsComposition = [validFather];

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      final result = sut.getLastSelectedFather(1);

      expect(result, selectedProduct.childsComposition?[0]);
    });
    test(
        "Should return last ProductCompositionViewModel if index of insertProductsViewModel -2 is equal fatherComposition",
        () async {
      selectedProduct.childsComposition = [validFather];

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      final result = sut.getLastSelectedFather(2);

      expect(result, selectedProduct.childsComposition?[0]);
    });
  });

  group("Update total products quantity", () {
    test("Should add quantity if is adding", () async {
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.totalProductsQuantity, 1);

      sut.updateTotalProductsQuantity(isAddingQuantity: true);

      expect(sut.totalProductsQuantity, 2);
    });
    test("Should emit error on try add more than the maximum quantity",
        () async {
      expect(sut.totalProductsQuantity, 1);

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.maximumQuantityAchieved]));

      sut.updateTotalProductsQuantity(isAddingQuantity: true);
      expect(sut.totalProductsQuantity, 2);
      sut.updateTotalProductsQuantity(isAddingQuantity: true);
      expect(sut.totalProductsQuantity, 3);
      sut.updateTotalProductsQuantity(
          isAddingQuantity: true); //o máximo é 3, por isso aqui emite o erro
      expect(sut.totalProductsQuantity, 3);
    });
    test(
        "Should not reduce quantity if is reducing and quantity is equal or less than 1",
        () async {
      expect(sut.totalProductsQuantity, 1);

      sut.updateTotalProductsQuantity(isAddingQuantity: false);
      sut.updateTotalProductsQuantity(isAddingQuantity: false);
      expect(sut.totalProductsQuantity, 1);
    });
    test("Should reduce quantity if atual quantity is more than 2", () async {
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.totalProductsQuantity, 1);

      sut.updateTotalProductsQuantity(isAddingQuantity: true);
      expect(sut.totalProductsQuantity, 2);
      sut.updateTotalProductsQuantity(isAddingQuantity: false);
      expect(sut.totalProductsQuantity, 1);
    });
  });

  group("Calculate product price", () {
    test("Sould return product composition price when have childcomposition",
        () async {
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(
        sut.calculateProductTotalLiquid(selectedProduct),
        sut.calculateProductCompositionTotalLiquid(
          product: selectedProduct.childsComposition![0],
        ),
      );
    });
    test("Sould return SaleRetailPraticedPrice when dont have childcomposition",
        () async {
      selectedProduct.childsComposition = null;
      selectedProduct.productQuantity = 10;

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(
        sut.calculateProductTotalLiquid(selectedProduct),
        selectedProduct.SaleRetailPraticed.toDouble() *
            selectedProduct.productQuantity,
      );
    });

    test("Should update quantity correctly when pass quantity as parameter",
        () {
      double quantity = faker.randomGenerator.decimal();

      sut.updateTotalProductsQuantity(newQuantity: quantity);

      expect(sut.totalProductsQuantity, quantity);
    });
    test("Should update quantity to 1 if is minor than zero", () {
      double quantity = faker.randomGenerator.decimal() - 1;

      sut.updateTotalProductsQuantity(newQuantity: quantity);

      expect(sut.totalProductsQuantity, 1);
    });
    test(
        "Should update to maximum quantity if try to insert a quantity greater than the maximum",
        () {
      sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      double maximumQuantity =
          (selectedProduct.MaximumQuantityForSale?.toDouble() ?? 99);
      double newQuantity = maximumQuantity + 1;

      sut.updateTotalProductsQuantity(newQuantity: newQuantity);

      expect(sut.totalProductsQuantity, maximumQuantity);
    });
  });

  group("Update total liquid", () {
    test("Should return correct price if childs is not empty", () async {
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      double totalChildsPrice = selectedProduct.childsComposition!
          .map((e) =>
              sut.calculateProductCompositionPrice(e) * e.Quantity!.toDouble())
          .first;

      sut.calculateProductCompositionPrice(
          selectedProduct.childsComposition!.first);

      expectLater(
        sut.totalPriceStream,
        emits(totalChildsPrice),
      );

      sut.updateTotalLiquid(selectedProduct);
    });
    test("Should return correct price if childs empty", () async {
      selectedProduct.childsComposition = [];

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expectLater(
        sut.totalPriceStream,
        emits(selectedProduct.SaleRetailPraticed.toDouble()),
      );

      sut.updateTotalLiquid(selectedProduct);
    });
    test("Should return correct price if childs null", () async {
      selectedProduct.childsComposition = null;

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expectLater(
        sut.totalPriceStream,
        emits(selectedProduct.SaleRetailPraticed.toDouble()),
      );

      sut.updateTotalLiquid(selectedProduct);
    });
    test("Should emit false value if total liquid is minor than 0.001",
        () async {
      expectLater(sut.canAdvanceIndexStream, emits(false));

      sut.updateTotalLiquid(
        EntityFactory.makeProductsViewModel(
          productQuantity: 1,
          saleRetailPrice: faker.randomGenerator.integer(1) / 1000,
        ),
      );
    });
    test("Should emit true value if total liquid equal or greater than 0.01",
        () async {
      expectLater(sut.canAdvanceIndexStream, emits(true));

      sut.updateTotalLiquid(
        EntityFactory.makeProductsViewModel(
          productQuantity: 0.001,
          saleRetailPrice: faker.randomGenerator.integer(10000, min: 1) / 100,
        ),
      );
    });
    test("Should emit false if quantity is minor than 0.001", () async {
      expectLater(sut.canAdvanceIndexStream, emits(false));

      sut.updateTotalProductsQuantity(
        newQuantity: 0.001,
      );

      sut.updateTotalLiquid(selectedProduct);
    });
  });
}
