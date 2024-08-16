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

import '../../domain/mocks/validate_combox_spy.dart';
import '../../ui/mocks/mocks.dart';

void main() {
  late GetxInsertProductsPresenter sut;
  late HomePresenterSpy homePresenter;
  late CartPresenterSpy cartPresenter;
  late ExpansibleGroupFromProductPresenterSpy
      expansibleGroupFromProductPresenter;

  late GetProductCompositionSpy getProductComposition;
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
        DeliveryControl:
            cartPresenter.saleRequestTempMock!.DeliveryControl.toInt(),
        EnterpriseId: cartPresenter.saleRequestTempMock!.EnterpriseId.toInt(),
        PersonalizedCode: cartPresenter.saleRequestTempMock!.PersonalizedCode,
        SaleRequestTempId:
            cartPresenter.saleRequestTempMock!.SaleRequestTempId.toInt(),
        TotalLiquid: totalLiquid,
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
          ),
        ]);

    return updateSaleRequestTempEntity;
  }

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initPresenters() {
    sut = GetxInsertProductsPresenter(
      getProductComposition: getProductComposition,
      updateSaleRequestTemp: updateSaleRequestTemp,
      validateCombox: validateCombox,
    );
    homePresenter = HomePresenterSpy();
    cartPresenter = CartPresenterSpy();
    expansibleGroupFromProductPresenter =
        ExpansibleGroupFromProductPresenterSpy();
  }

  void initUsecases() {
    getProductComposition = GetProductCompositionSpy();
    updateSaleRequestTemp = UpdateSaleRequestTempSpy();
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    validateCombox = ValidateComboxSpy();
  }

  void initMocks() {
    getProductComposition.mockGetFathers(optionalFathers);
    getProductComposition.mockGetChildsOfFather(optionalFathers
        .map((element) => ProductCompositionViewModel.fromEntityWithChilds(
            element, optionalFathers))
        .toList());
    loadSaleRequestTemp.mockLoadSaleRequestTemp(saleRequestTempEntity);
    expansibleGroupFromProductPresenter.mockProductHasComment(true);
    expansibleGroupFromProductPresenter.mockProductHasObligatoryOptions(true);
  }

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    optionalFathers =
        EntityFactory.makeProductsCompositionsEntity(isOptionalItem: true);
    saleRequestTempEntity = EntityFactory.makeSaleRequestTempEntity(0);

    cartPresenter.saleRequestTempMock =
        SaleRequestTempViewModel.fromEntity(saleRequestTempEntity);

    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();

    homePresenter.commandNumberMock =
        faker.randomGenerator.integer(300).toString();

    obligatoryFather = EntityFactory.makeProductCompositionViewModel(
      quantity: faker.randomGenerator.decimal(),
      salePrice: faker.randomGenerator.decimal(),
      offerPrice: faker.randomGenerator.decimal(),
      fatherIncrement: faker.randomGenerator.decimal(),
      childIncrement: faker.randomGenerator.decimal(),
      isOptionalItem: false,
      indexOfSelectedChild: null,
      insertChilds: false,
    );

    selectedProduct = EntityFactory.makeProductsViewModel(
      insertChildsComposition: true,
      isOptionalChilds: false,
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
        EntityFactory.makeExpansibleGroupFromProductPresenter());
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
  });

  group("updateSelectedProduct", () {
    test(
        'Should change totalComboxQuantity correctly when updateValue and to 1 when call LoadProductComposition',
        () async {
      sut.updateTotalProductsQuantity(true);
      expect(sut.totalProductsQuantity, 2);
      sut.updateTotalProductsQuantity(true);
      expect(sut.totalProductsQuantity, 3);
      sut.updateTotalProductsQuantity(false);
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
    test(
        'Should emit true when product has comment and childsComposition is null',
        () async {
      expectLater(sut.showCommentsStream, emits(true));
      selectedProduct.childsComposition = null;

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test(
        'Should emit true when product dont have comment, have obligatoryOptions and childsComposition is null',
        () async {
      expectLater(sut.showObligatoryOptionsStream, emits(true));
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      selectedProduct.childsComposition = null;

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
  });

  group("UpdateSelectedFather", () {
    test("Should not advance selectedFatherIndex if atual father is invalid",
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
        )
      ];

      expectLater(sut.selectedLeftIndexStream, emits(0));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateFatherIndex(
        newIndex: 0,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateFatherIndex(
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
      sut.updateFatherIndex(
        newIndex: 0,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateFatherIndex(
        newIndex: 1,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateFatherIndex(
        newIndex: 2,
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
      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
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

    test("Should update combox quantity to 1", () {
      sut.updateTotalProductsQuantity(true);
      expect(sut.totalProductsQuantity, 2);

      sut.clearData(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(sut.totalProductsQuantity, 1);
    });

    test("Should not reduce quantity when atual quantity is 1", () {
      sut.updateTotalProductsQuantity(false);
      sut.updateTotalProductsQuantity(false);
      sut.updateTotalProductsQuantity(false);
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
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case1],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case2],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case3],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case4],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case5],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case6],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case7],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case8],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
      );

      await sut.updateSaleRequest(
          homePresenter: homePresenter,
          cartPresenter: cartPresenter,
          productsCompositions: [case1]);

      verifyNever(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: makeUpdateSaleRequestTempEntity(
              productCompositionViewModel: case1,
              totalLiquid: 10,
              productValue: 10,
            ),
          ));

      verifyNever(() =>
          cartPresenter.loadSaleRequest(homePresenter.commandNumberMock!));
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
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        productsCompositions: [case1],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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

      verify(() =>
              cartPresenter.loadSaleRequest(homePresenter.commandNumberMock!))
          .called(1);
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
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: homePresenter.commandNumberMock!,
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

  group("Product comment", () {
    test(
        "Should update correctly the comment according to what returned in expansibleGroupFromProductPresenter",
        () async {
      final father = EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 0,
        offerPrice: 0,
        fatherIncrement: 0,
        childIncrement: 0,
        isOptionalItem: false,
        indexOfSelectedChild: 0,
        insertChilds: true,
      );

      expansibleGroupFromProductPresenter
          .mockGetConcatenateSelectedComments("any");

      sut.updateComment(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        father: father,
      );

      expect(father.commentFather, "any");
    });
  });

  group("update selected child", () {
    test(
        "Should update selected index of child if click in product that have child",
        () {
      final optionalFather =
          ProductCompositionViewModel.fromEntity(optionalFathers[0]);

      expect(optionalFather.indexOfSelectedChild, null);
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
        () {
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
        () {
      final optionalFather =
          ProductCompositionViewModel.fromEntity(optionalFathers[0]);

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

  group("Advance Father index when childComposition is not null", () {
    test("Should advance index if atual index is valid", () async {
      selectedProduct.childsComposition = [validFather];
      expectLater(sut.selectedLeftIndexStream, emitsInOrder([0, 1]));
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      expansibleGroupFromProductPresenter
          .mockProductHasObligatoryOptions(false);

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateFatherIndex(
        newIndex: 0,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
    });
    test(
        "Should emit false if hasComment, comment not showing and atualFather is invalid",
        () async {
      selectedProduct.childsComposition = [invalidFather];
      expectLater(sut.showCommentsStream, emits(false));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
    });
    test(
        "Should emit true if hasComment, comment not showing and atualFather is valid",
        () async {
      selectedProduct.childsComposition = [validFather];
      expectLater(sut.showCommentsStream, emits(true));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
    });
    test(
        "Should emit correct values if childsComposition not null, productHasObligatoryOptions and fatherIsValid",
        () async {
      selectedProduct.childsComposition = [validFather];
      expectLater(sut.showCommentsStream, emitsInOrder([true, false]));
      expectLater(sut.showObligatoryOptionsStream, emits(true));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
    });

    test("Should not advance index if atual index is invalid", () async {
      selectedProduct.childsComposition = [invalidFather];
      expectLater(sut.selectedLeftIndexStream, emits(0));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateFatherIndex(
        newIndex: 0,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
    });

    test(
        "Should emit correct values if new index is the index of quantity and atual father is invalid ",
        () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      expansibleGroupFromProductPresenter
          .mockProductHasObligatoryOptions(false);
      selectedProduct.childsComposition = [validFather, invalidFather];

      expectLater(sut.selectedLeftIndexStream, emits(1));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
    });
  });

  group("Advance Father index when childComposition is null", () {
    test(
        "Should emit correct values if product has comment, dont is combox and index is equal zero",
        () async {
      selectedProduct.childsComposition = null;

      expectLater(sut.selectedLeftIndexStream, emits(1));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateFatherIndex(
        newIndex: 1,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
    });

    test("Should emit correct values on advance left index", () async {
      selectedProduct.childsComposition = null;
      expectLater(sut.selectedLeftIndexStream, emits(1));

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
    });
  });

  group("get can advance index", () {
    test("Should return true if childsComposition is null", () async {
      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expectLater(sut.canAdvanceIndexStream, emits(true));

      sut.updateCanAdvanceIndex(expansibleGroupFromProductPresenter);
    });

    test(
        "Should return true if has childs, is showing obligatory options and one option is selected",
        () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      expansibleGroupFromProductPresenter.loadedObligatoryOptionsController = [
        ExpansibleGroupFromProductViewModel(
          selected: true,
          ProductName: faker.randomGenerator.string(10),
          GroupName: faker.randomGenerator.string(10),
          ExpansibleGroupId: faker.randomGenerator.integer(10).toString(),
          ProductInternalCodeOnErp:
              validFather.InternalCodeOnERPCodeChild.toString(),
        ),
      ];
      selectedProduct.childsComposition = [validFather];
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
      expectLater(sut.canAdvanceIndexStream, emits(true));

      sut.updateCanAdvanceIndex(expansibleGroupFromProductPresenter);
    });
    test(
        "Should return false if has childs, is showing obligatory options and option IS NOT selected",
        () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      expansibleGroupFromProductPresenter.loadedObligatoryOptionsController = [
        ExpansibleGroupFromProductViewModel(
          selected: false,
          ProductName: faker.randomGenerator.string(10),
          GroupName: faker.randomGenerator.string(10),
          ExpansibleGroupId: faker.randomGenerator.integer(10).toString(),
          ProductInternalCodeOnErp:
              validFather.InternalCodeOnERPCodeChild.toString(),
        ),
      ];
      selectedProduct.childsComposition = [validFather];
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
      expectLater(sut.canAdvanceIndexStream, emits(false));

      sut.updateCanAdvanceIndex(expansibleGroupFromProductPresenter);
    });
    test(
        "Should return true if dont have childs, is showing obligatory options and obligatory is selected",
        () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      expansibleGroupFromProductPresenter.loadedObligatoryOptionsController = [
        ExpansibleGroupFromProductViewModel(
          selected: true,
          ProductName: faker.randomGenerator.string(10),
          GroupName: faker.randomGenerator.string(10),
          ExpansibleGroupId: faker.randomGenerator.integer(10).toString(),
          ProductInternalCodeOnErp: selectedProduct.InternalCodeOnERP!,
        ),
      ];
      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expectLater(sut.canAdvanceIndexStream, emits(true));

      sut.updateCanAdvanceIndex(expansibleGroupFromProductPresenter);
    });
    test(
        "Should return false if dont have childs, is showing obligatory options and obligatory is NOT selected",
        () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      expansibleGroupFromProductPresenter.loadedObligatoryOptionsController = [
        ExpansibleGroupFromProductViewModel(
          selected: false,
          ProductName: faker.randomGenerator.string(10),
          GroupName: faker.randomGenerator.string(10),
          ExpansibleGroupId: faker.randomGenerator.integer(10).toString(),
          ProductInternalCodeOnErp: selectedProduct.InternalCodeOnERP!,
        ),
      ];
      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expectLater(sut.canAdvanceIndexStream, emits(false));

      sut.updateCanAdvanceIndex(expansibleGroupFromProductPresenter);
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
      sut.updateTotalProductsQuantity(true);
      sut.updateTotalProductsQuantity(true);
      sut.updateTotalProductsQuantity(false);
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
      sut.updateTotalProductsQuantity(true);
      sut.updateTotalProductsQuantity(true);
      sut.updateTotalProductsQuantity(false);
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

  group("Get show comments", () {
    test(
        "Should return false if index is 0, dont have comments and dont have childs",
        () async {
      sut.updateSelectedIndexOfProduct(
        father: validFather,
        index: 0,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.getShowComments(expansibleGroupFromProductPresenter), false);
    });
    test("Should return true if index is 0, hascomment and dont have childs",
        () async {
      selectedProduct.childsComposition = null;
      sut.updateSelectedIndexOfProduct(
        father: validFather,
        index: 0,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.getShowComments(expansibleGroupFromProductPresenter), true);
    });
    test(
        "Should return true if childComposition is not null, father is valid, has product and click in advance index",
        () async {
      expectLater(sut.showCommentsStream, emits(true));
      selectedProduct.childsComposition = [validFather];

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
      expect(sut.getShowComments(expansibleGroupFromProductPresenter), true);
    });
  });

  group("Get show Obligatory Options", () {
    test(
        "Should return true if index == 0, dont have comment, childComposition is null and hasObligatoryOptions",
        () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateFatherIndex(
        newIndex: 0,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.getShowObligatoryOptions(expansibleGroupFromProductPresenter),
          true);
    });
    test(
        "Should return true if index == 1, have comment, childComposition is null and hasObligatoryOptions",
        () async {
      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);

      expect(sut.getShowObligatoryOptions(expansibleGroupFromProductPresenter),
          true);
    });
    test("Should return correct values when have comment and advance index",
        () async {
      expectLater(sut.showObligatoryOptionsStream, emits(true));
      selectedProduct.childsComposition = [validFather];

      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
      expect(sut.getShowObligatoryOptions(expansibleGroupFromProductPresenter),
          false); //primeiro vai pro comentário
      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
      expect(sut.getShowObligatoryOptions(expansibleGroupFromProductPresenter),
          true);
    });
  });

  group("Get show update quantity", () {
    test("Should return true if atual index is equal childComposition.length",
        () async {
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      expansibleGroupFromProductPresenter
          .mockProductHasObligatoryOptions(false);

      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);

      expect(
          sut.getShowUpdateQuantity(expansibleGroupFromProductPresenter), true);
    });
    test(
        "Should return true if product dont have comment and obligatoryOptions",
        () async {
      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      expansibleGroupFromProductPresenter
          .mockProductHasObligatoryOptions(false);

      expect(
          sut.getShowUpdateQuantity(expansibleGroupFromProductPresenter), true);
    });
    test("Should return true if product dont have comment atual index is 1",
        () async {
      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expansibleGroupFromProductPresenter.mockProductHasComment(false);

      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
      expect(
          sut.getShowUpdateQuantity(expansibleGroupFromProductPresenter), true);
    });
    test(
        "Should return true if product dont have obligatoryOptions atual index is 1",
        () async {
      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expansibleGroupFromProductPresenter
          .mockProductHasObligatoryOptions(false);

      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
      expect(
          sut.getShowUpdateQuantity(expansibleGroupFromProductPresenter), true);
    });
    test(
        "Should return true if product have obligatoryOptions and comments and atual index is 2",
        () async {
      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(
        product: selectedProduct,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
      sut.advanceFatherIndex(expansibleGroupFromProductPresenter);
      expect(
          sut.getShowUpdateQuantity(expansibleGroupFromProductPresenter), true);
    });
  });
}
