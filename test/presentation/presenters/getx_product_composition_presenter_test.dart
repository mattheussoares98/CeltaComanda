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
  late GetxProductCompositionPresenter sut;
  late HomePresenterSpy homePresenter;
  late CartPresenterSpy cartPresenter;
  late CommentsPresenterSpy commentsPresenter;

  late GetProductCompositionSpy getProductComposition;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late ValidateComboxSpy validateCombox;

  late List<ProductCompositionEntity> optionalFathers;
  late ProductCompositionViewModel obligatoryFather;
  late SaleRequestTempEntity saleRequestTempEntity;
  late ProductsViewModel selectedProduct;

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
    sut = GetxProductCompositionPresenter(
      getProductComposition: getProductComposition,
      updateSaleRequestTemp: updateSaleRequestTemp,
      validateCombox: validateCombox,
    );
    homePresenter = HomePresenterSpy();
    cartPresenter = CartPresenterSpy();
    commentsPresenter = CommentsPresenterSpy();
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

    selectedProduct =
        EntityFactory.makeProductViewModel(insertChildsComposition: true);
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
    registerFallbackValue(CommentsPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
  });

  group("updateSelectedProduct", () {
    test(
        'Should change totalComboxQuantity correctly when updateValue and to 1 when call LoadProductComposition',
        () async {
      sut.updateComboxQuantity(true);
      expect(sut.totalComboxQuantity, 2);
      sut.updateComboxQuantity(true);
      expect(sut.totalComboxQuantity, 3);
      sut.updateComboxQuantity(false);
      expect(sut.totalComboxQuantity, 2);

      await sut.updateSelectedProduct(selectedProduct);

      expect(sut.totalComboxQuantity, 1);
    });

    test(
        'Should call validateCombox on loadProductComposition to change button confirmation style',
        () async {
      getProductComposition.mockGetFathers([]);
      getProductComposition.mockGetChildsOfFather([]);

      await sut.updateSelectedProduct(selectedProduct);

      verify(() =>
              validateCombox.comboxIsValid(selectedProduct.childsComposition!))
          .called(1);
    });

    test(
        'Should update indexOfSelctedChild if father is obligatory and childs is empty',
        () async {
      selectedProduct.childsComposition!.first.indexOfSelectedChild = 0;
      //quando o produto é obrigatório e não tem filhos, precisa ter um índice
      //selecionado pra na tela da composição, aparecer que ele já foi
      //selecionado. Por isso faz essa alteração

      await sut.updateSelectedProduct(selectedProduct);

      expect(sut.selectedComboxProduct, selectedProduct);
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
        "Should update correctly the comment according to what returned in commentsPresenter",
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

      commentsPresenter.mockGetConcatenateSelectedComments("any");

      sut.updateComment(
        commentsPresenter: commentsPresenter,
        father: father,
      );

      expect(father.commentFather, "any");
    });
  });

  group("validate combox", () {
    test("Should emit correct envets on certifyComboxIsValid return true", () {
      expectLater(sut.comboxIsValidStream, emits(true));
      expectLater(sut.mainErrorStream, emits(null));

      sut.certifyComboxIsValid([]);
    });
    test("Should emit correct envets on certifyComboxIsValid return false", () {
      validateCombox.mockValidateCombox(false);

      expectLater(sut.comboxIsValidStream, emits(false));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.invalidCombox]));

      sut.certifyComboxIsValid([]);
    });
    test("Should update comboxIsValidStream correctly on combox is valid", () {
      validateCombox.mockValidateCombox(true);

      expectLater(sut.comboxIsValidStream, emits(true));

      sut.updateComboxIsValid([]);
    });
    test("Should update comboxIsValidStream correctly on combox is invalid",
        () {
      validateCombox.mockValidateCombox(false);

      expectLater(sut.comboxIsValidStream, emits(false));

      sut.updateComboxIsValid([]);
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
}
