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
  late SaleRequestTempPresenterSpy saleRequestTempPresenter;

  late GetProductCompositionSpy getProductComposition;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late ValidateComboxSpy validateCombox;

  late List<ProductCompositionEntity> optionalFathers;
  late int internalCodeOnErp;
  late SaleRequestTempEntity saleRequestTempEntity;

  UpdateSaleRequestTempEntity makeUpdateSaleRequestTempEntity({
    required ProductCompositionViewModel productCompositionViewModel,
    required double totalLiquid,
    required double productValue,
  }) {
    final updateSaleRequestTempEntity = UpdateSaleRequestTempEntity(
        DeliveryControl: saleRequestTempPresenter
            .saleRequestTempMock!.DeliveryControl
            .toInt(),
        EnterpriseId:
            saleRequestTempPresenter.saleRequestTempMock!.EnterpriseId.toInt(),
        PersonalizedCode:
            saleRequestTempPresenter.saleRequestTempMock!.PersonalizedCode,
        SaleRequestTempId: saleRequestTempPresenter
            .saleRequestTempMock!.SaleRequestTempId
            .toInt(),
        TotalLiquid: totalLiquid,
        Products: [
          UpdateSaleRequestTempProductEntity(
            ProductInternalCodeOnErp: 1,
            ProductPriceLookUpCode: "PluChild",
            Quantity:
                productCompositionViewModel.Quantity.toString().toDouble(),
            SaleRequestTempId: saleRequestTempPresenter
                .saleRequestTempMock!.SaleRequestTempId
                .toInt(),
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
    saleRequestTempPresenter = SaleRequestTempPresenterSpy();
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
    internalCodeOnErp = faker.randomGenerator.integer(99);
    saleRequestTempEntity = EntityFactory.makeSaleRequestTempEntity();

    saleRequestTempPresenter.saleRequestTempMock =
        SaleRequestTempViewModel.fromEntity(saleRequestTempEntity);

    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();

    homePresenter.commandNumberMock =
        faker.randomGenerator.integer(300).toString();
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
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(SaleRequestTempPresenterSpy());
    registerFallbackValue(ExpansibleGroupsPresenterSpy());
  });

  group("GetProductComposition", () {
    test('Should emit correct values on LoadProductComposition success',
        () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.productsCompositionStream.listen(
          expectAsync1((productComposition) => expect(productComposition, [
                ProductCompositionViewModel.fromEntityWithChilds(
                  productComposition[0].toEntity(),
                  optionalFathers,
                ),
                ProductCompositionViewModel.fromEntityWithChilds(
                  productComposition[1].toEntity(),
                  optionalFathers,
                ),
              ])));

      await sut.loadProductComposition(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        internalCodeOnErp: internalCodeOnErp,
      );
    });
    test('Should emit correct values on getFathers throw', () async {
      getProductComposition.mockGetFathersError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.productsCompositionStream.listen(
          expectAsync1((productComposition) => expect(productComposition, [])));

      await sut.loadProductComposition(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        internalCodeOnErp: internalCodeOnErp,
      );
    });

    test('Should emit correct values on getFathers throw', () async {
      getProductComposition.mockGetChildsOfFatherError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.productsCompositionStream.listen(
          expectAsync1((productComposition) => expect(productComposition, [])));

      await sut.loadProductComposition(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        internalCodeOnErp: internalCodeOnErp,
      );
    });
    test('Should call getFathers with correct values', () async {
      await sut.loadProductComposition(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        internalCodeOnErp: internalCodeOnErp,
      );

      verify(() => getProductComposition.getFathers(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            internalCodeOnErp: internalCodeOnErp,
          )).called(1);
    });

    test('Should call getChildsOfFather with correct values', () async {
      await sut.loadProductComposition(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        internalCodeOnErp: internalCodeOnErp,
      );

      verify(
        () => getProductComposition.getChildsOfFather(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          internalCodeOnErp: internalCodeOnErp,
          fathers: optionalFathers,
        ),
      );
    });
    test(
        'Should change totalComboxQuantity correctly when updateValue and to 1 when call LoadProductComposition',
        () async {
      sut.updateComboxQuantity(true);
      expect(sut.totalComboxQuantity, 2);
      sut.updateComboxQuantity(true);
      expect(sut.totalComboxQuantity, 3);
      sut.updateComboxQuantity(false);
      expect(sut.totalComboxQuantity, 2);

      await sut.loadProductComposition(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        internalCodeOnErp: internalCodeOnErp,
      );

      expect(sut.totalComboxQuantity, 1);
    });
  });

  group("sut.UpdateSaleRequestTemp", () {
    test(
        "Should call sut.updateSaleRequest with correct values of price and totalLiquid",
        () async {
      final case1 = EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 0,
        incrementValue: 0,
        isOptionalItem: false,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
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

      final case2 = EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 8,
        incrementValue: 0,
        isOptionalItem: false,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
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

      final case3 = EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 8,
        incrementValue: 0,
        isOptionalItem: true,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
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

      final case4 = EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 8,
        incrementValue: 5,
        isOptionalItem: true,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
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

      final case5 = EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 8,
        incrementValue: 5,
        isOptionalItem: false,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
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

      final case6 = EntityFactory.makeProductCompositionViewModel(
        quantity: 2,
        salePrice: 10,
        offerPrice: 8,
        incrementValue: 5,
        isOptionalItem: false,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
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

      final case7 = EntityFactory.makeProductCompositionViewModel(
        quantity: 2,
        salePrice: 10,
        offerPrice: 8,
        incrementValue: 5,
        isOptionalItem: true,
      );

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
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
    test("Should emit correct events on sut.pdateSaleRequest success",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        productsCompositions: [],
      );
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
        saleRequestTempPresenter: saleRequestTempPresenter,
        productsCompositions: [],
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
        saleRequestTempPresenter: saleRequestTempPresenter,
        productsCompositions: [],
      );
    });
    test(
        "Should call saleRequestTempPresenter.loadSaleRequest with correct values",
        () async {
      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        productsCompositions: [],
      );

      verify(() => saleRequestTempPresenter
          .loadSaleRequest(homePresenter.commandNumberMock!)).called(1);
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
        "Should emit CommandNotAvailable commandNotAvailable on saleRequestTempPresenter.loadSaleRequest throws CommandNotAvailable",
        () async {
      saleRequestTempPresenter
          .mockLoadSaleRequestTempError(DomainError.commandNotAvailable);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        productsCompositions: [],
      );
    });
    test(
        "Should emit unexpected unexpected on saleRequestTempPresenter.loadSaleRequest throws unexpected",
        () async {
      saleRequestTempPresenter
          .mockLoadSaleRequestTempError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        productsCompositions: [],
      );
    });
  });
}
