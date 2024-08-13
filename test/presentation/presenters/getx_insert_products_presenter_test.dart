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
  late CommentsPresenterSpy expansibleGroupFromProductPresenter;

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
    expansibleGroupFromProductPresenter = CommentsPresenterSpy();
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

    selectedProduct = EntityFactory.makeProductViewModel(
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
    registerFallbackValue(EntityFactory.makeProductViewModel());
    registerFallbackValue(EntityFactory.makeCommentViewModel());
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(CommentsPresenterSpy());
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

      await sut.updateSelectedProduct(selectedProduct);

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

      await sut.updateSelectedProduct(selectedProduct);
    });

    test(
        'Should update selectedComboxProduct when call sut.updateSelectedProduct',
        () async {
      expectLater(sut.selectedProductStream, emits(selectedProduct));

      await sut.updateSelectedProduct(selectedProduct);
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

      await sut.updateSelectedProduct(selectedProduct);
      sut.updateSelectedLeftItem(0);
      sut.updateSelectedLeftItem(1);
    });
    test(
        "Should not advance selectedFatherIndex if one of all previous itens is invalid",
        () async {
      selectedProduct.childsComposition = [
        validFather,
        invalidFather,
        validFather,
      ];

      expectLater(sut.selectedLeftIndexStream, emitsInOrder([0, 1]));

      await sut.updateSelectedProduct(selectedProduct);
      sut.updateSelectedLeftItem(0);
      sut.updateSelectedLeftItem(1);
      sut.updateSelectedLeftItem(2);
    });
    test("Should advance selectedFatherIndex if all previous itens are valid",
        () async {
      selectedProduct.childsComposition = [
        validFather,
        validFather,
        invalidFather,
        validFather,
      ];

      expectLater(sut.selectedLeftIndexStream, emitsInOrder([0, 1, 2]));

      await sut.updateSelectedProduct(selectedProduct);
      sut.updateSelectedLeftItem(0);
      sut.updateSelectedLeftItem(1);
      sut.updateSelectedLeftItem(2);
      sut.updateSelectedLeftItem(3);
    });
  });

  group("clearSelectedComboxData", () {
    test("Should update index of selected father to zero", () async {
      expectLater(sut.selectedLeftIndexStream, emitsInOrder([1, 0]));

      await sut.updateSelectedProduct(selectedProduct);
      sut.updateSelectedLeftItem(1);
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
      expectLater(sut.childsCompositionIsValidStream, emits(true));

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
      expectLater(sut.childsCompositionIsValidStream, emits(false));

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
        father: optionalFather,
        index: 0,
      );
      expect(optionalFather.indexOfSelectedChild, 0);
    });
    test(
        "Should not update index if click in the same product and father is not optional",
        () {
      sut.updateSelectedIndexOfProduct(
        father: obligatoryFather,
        index: 0,
      );
      sut.updateSelectedIndexOfProduct(
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
        father: optionalFather,
        index: 0,
      );
      sut.updateSelectedIndexOfProduct(
        father: optionalFather,
        index: 0,
      );

      expect(optionalFather.indexOfSelectedChild, null);
    });
  });

  group("Father is valid", () {
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
    test("Should advance index if atual index is valid", () async {
      selectedProduct.childsComposition = [validFather];
      expectLater(sut.selectedLeftIndexStream, emitsInOrder([0, 1]));
      expansibleGroupFromProductPresenter.mockProductHasComment(false);

      await sut.updateSelectedProduct(selectedProduct);
      sut.updateSelectedLeftItem(0);
      sut.advanceLeftIndex(expansibleGroupFromProductPresenter);
    });
    test(
        "Should show comments if hasComment, comment not showing and atualFather is valid",
        () async {
      selectedProduct.childsComposition = [validFather];
      expectLater(sut.showCommentsStream, emits(true));

      await sut.updateSelectedProduct(selectedProduct);
      sut.advanceLeftIndex(expansibleGroupFromProductPresenter);
    });
    test(
        "Should emit correct values if childsComposition not null, productHasObligatoryOptions and fatherIsValid",
        () async {
      selectedProduct.childsComposition = [validFather];
      expectLater(sut.showCommentsStream, emitsInOrder([true, false]));
      expectLater(sut.showObligatoryOptionsStream, emits(true));

      await sut.updateSelectedProduct(selectedProduct);
      sut.advanceLeftIndex(expansibleGroupFromProductPresenter);
      sut.advanceLeftIndex(expansibleGroupFromProductPresenter);
    });
    test("Should not advance index if atual index is invalid", () async {
      selectedProduct.childsComposition = [invalidFather];
      expectLater(sut.selectedLeftIndexStream, emits(0));

      await sut.updateSelectedProduct(selectedProduct);
      sut.updateSelectedLeftItem(0);
      sut.advanceLeftIndex(expansibleGroupFromProductPresenter);
    });

    test(
        "Should emit correct values if already showing comments and advance index",
        () async {
      selectedProduct.childsComposition = [validFather];
      expansibleGroupFromProductPresenter.mockProductHasComment(false);

      expectLater(sut.selectedLeftIndexStream, emits(1));

      await sut.updateSelectedProduct(selectedProduct);
      sut.advanceLeftIndex(expansibleGroupFromProductPresenter);
    });

    test(
        "Should emit correct values if new index is the index of quantity and atual father is invalid ",
        () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      selectedProduct.childsComposition = [validFather, invalidFather];

      expectLater(sut.selectedLeftIndexStream, emits(1));

      await sut.updateSelectedProduct(selectedProduct);
      sut.updateSelectedLeftItem(1);
      sut.advanceLeftIndex(expansibleGroupFromProductPresenter);
    });

    test(
        "Should emit correct values if product has comment, dont is combox and index is equal zero",
        () async {
      selectedProduct.childsComposition = null;

      expectLater(sut.selectedLeftIndexStream, emits(1));

      await sut.updateSelectedProduct(selectedProduct);
      sut.updateSelectedLeftItem(1);
      sut.advanceLeftIndex(expansibleGroupFromProductPresenter);
    });
  });

  group("get can advance index", () {
    test("Should return true if childsComposition is null", () async {
      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(selectedProduct);

      expect(sut.canAdvanceIndex, true);
    });
    //não criei mais testes porque nas outras possibilidades chama a função
    //fatherIsValid, que já possui testes. Só passa o produto pai do índice
    //selecionado como parâmetro da função pra validar o pai
  });

  group("Update product price without childsComposition", () {
    test("Should update price when update selected product", () async {
      expectLater(
          sut.totalPrice,
          emits(
            selectedProduct.SaleRetailPraticed.toDouble(),
          ));

      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(selectedProduct);
    });
    test("Should update price add product quantity", () async {
      expectLater(
          sut.totalPrice,
          emitsInOrder([
            selectedProduct.SaleRetailPraticed.toDouble(),
            selectedProduct.SaleRetailPraticed.toDouble() * 2,
            selectedProduct.SaleRetailPraticed.toDouble() * 3,
            selectedProduct.SaleRetailPraticed.toDouble() * 2,
          ]));

      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(selectedProduct);
      sut.updateTotalProductsQuantity(true);
      sut.updateTotalProductsQuantity(true);
      sut.updateTotalProductsQuantity(false);
    });
    test("Should update total liquid when update selected product", () async {
      expectLater(
          sut.totalPrice,
          emits(
            selectedProduct.SaleRetailPraticed.toDouble(),
          ));

      selectedProduct.childsComposition = null;

      await sut.updateSelectedProduct(selectedProduct);
    });
  });
  group("Update product price with childsComposition", () {
    test("Should update price when update selected product", () async {
      expectLater(
          sut.totalPrice,
          emits(
            sut.calculateProductCompositionTotalLiquid(
              product: selectedProduct.childsComposition![0],
            ),
          ));

      selectedProduct.childsComposition![0].indexOfSelectedChild = 0;
      await sut.updateSelectedProduct(selectedProduct);
    });
    test("Should update price add product quantity", () async {
      expectLater(
          sut.totalPrice,
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
      await sut.updateSelectedProduct(selectedProduct);
      sut.updateTotalProductsQuantity(true);
      sut.updateTotalProductsQuantity(true);
      sut.updateTotalProductsQuantity(false);
    });
    test("Should update total liquid when update selected product", () async {
      expectLater(
          sut.totalPrice,
          emits(
            sut.calculateProductCompositionTotalLiquid(
              product: selectedProduct.childsComposition![0],
            ),
          ));

      await sut.updateSelectedProduct(selectedProduct);
    });
  });

  group("Get show comments", () {
    test(
        "Should return false if index is 0, dont have comments and dont have childs",
        () async {
      sut.updateSelectedIndexOfProduct(father: validFather, index: 0);
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      await sut.updateSelectedProduct(selectedProduct);

      expect(sut.getShowComments(expansibleGroupFromProductPresenter), false);
    });
    test("Should return true if index is 0, hascomment and dont have childs",
        () async {
      selectedProduct.childsComposition = null;
      sut.updateSelectedIndexOfProduct(father: validFather, index: 0);
      await sut.updateSelectedProduct(selectedProduct);

      expect(sut.getShowComments(expansibleGroupFromProductPresenter), true);
    });
  });

  group("Get show Obligatory Options", () {
    test(
        "Should return true if index == 0, dont have comment, childComposition is null and hasObligatoryOptions",
        () async {
      expansibleGroupFromProductPresenter.mockProductHasComment(false);
      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(selectedProduct);
      sut.updateSelectedLeftItem(0);

      expect(sut.getShowObligatoryOptions(expansibleGroupFromProductPresenter),
          true);
    });
    test(
        "Should return true if index == 1, have comment, childComposition is null and hasObligatoryOptions",
        () async {
      selectedProduct.childsComposition = null;
      await sut.updateSelectedProduct(selectedProduct);
      sut.updateSelectedLeftItem(1);

      expect(sut.getShowObligatoryOptions(expansibleGroupFromProductPresenter),
          true);
    });
  });
}
