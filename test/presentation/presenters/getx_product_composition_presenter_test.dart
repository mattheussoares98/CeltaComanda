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
  late GetxProductCompositionPresenter sut;
  late HomePresenterSpy homePresenter;
  late SaleRequestTempPresenterSpy saleRequestTempPresenter;

  late GetProductCompositionSpy getProductComposition;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;

  late List<ProductCompositionEntity> optionalFathers;
  late List<ProductCompositionEntity> obligatoryFathers;
  late int internalCodeOnErp;
  late UpdateSaleRequestTempEntity updateSaleRequestTempEntity;
  late SaleRequestTempEntity saleRequestTempEntity;
  late List<UpdateSaleRequestTempProductEntity> products;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initPresenters() {
    sut = GetxProductCompositionPresenter(
      getProductComposition: getProductComposition,
      updateSaleRequestTemp: updateSaleRequestTemp,
    );
    homePresenter = HomePresenterSpy();
    saleRequestTempPresenter = SaleRequestTempPresenterSpy();
  }

  void initUsecases() {
    getProductComposition = GetProductCompositionSpy();
    updateSaleRequestTemp = UpdateSaleRequestTempSpy();
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
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
    obligatoryFathers =
        EntityFactory.makeProductsCompositionsEntity(isOptionalItem: false);
    internalCodeOnErp = faker.randomGenerator.integer(99);
    saleRequestTempEntity = EntityFactory.makeSaleRequestTempEntity();

    saleRequestTempPresenter.saleRequestTempMock =
        SaleRequestTempViewModel.fromEntity(saleRequestTempEntity);

    products = [EntityFactory.makeUpdateSaleRequestTempProductEntity()];

    updateSaleRequestTempEntity = UpdateSaleRequestTempEntity(
      DeliveryControl: int.parse(
          saleRequestTempPresenter.saleRequestTempMock!.DeliveryControl),
      EnterpriseId:
          int.parse(saleRequestTempPresenter.saleRequestTempMock!.EnterpriseId),
      PersonalizedCode:
          saleRequestTempPresenter.saleRequestTempMock!.PersonalizedCode,
      SaleRequestTempId: int.parse(
          saleRequestTempPresenter.saleRequestTempMock!.SaleRequestTempId),
      TotalLiquid: products.fold(
          0, (previousValue, element) => previousValue + element.TotalLiquid),
      Products: products,
    );

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
    test('Should emit correct values on getProductsComposition throws',
        () async {
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
    test('Should call GetProductComposition with correct values', () async {
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

    test('Should call get childs', () async {
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
  });

  group("Validate combox", () {
    // test("Should return false if all fathers is obligatorys and not selecteds",
    //     () async {
    //   getProductComposition.mockGetFathers(obligatoryFathers);
    //   getProductComposition.mockGetChildsOfFather([
    //     ProductCompositionViewModel(
    //       ProductCompositionId:
    //           obligatoryFathers[0].ProductCompositionId.toString(),
    //       EnterpriseId: obligatoryFathers[0].EnterpriseId.toString(),
    //       InternalCodeOnERPCodeFather:
    //           obligatoryFathers[0].InternalCodeOnERPCodeFather.toString(),
    //       InternalCodeOnERPCodeChild:
    //           obligatoryFathers[0].InternalCodeOnERPCodeChild.toString(),
    //       PluChild: obligatoryFathers[0].PluChild.toString(),
    //       ChildName: obligatoryFathers[0].ChildName.toString(),
    //       Quantity: obligatoryFathers[0].Quantity.toString(),
    //       SalePrice: obligatoryFathers[0].SalePrice.toString(),
    //       OfferPrice: obligatoryFathers[0].OfferPrice.toString(),
    //       IncrementValue: obligatoryFathers[0].IncrementValue.toString(),
    //       IsOptionalItem: obligatoryFathers[0].IsOptionalItem.toString(),
    //       ProductOptions: obligatoryFathers[0].ProductOptions.toString(),
    //       indexOfSelectedChild: null,
    //     ),
    //   ]);

    //   await sut.loadProductComposition(
    //     url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
    //     enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
    //     internalCodeOnErp: internalCodeOnErp,
    //   );

    //   final isValid = sut.comboxIsValid();

    //   expect(isValid, false);
    // });

    // test("Should return true if all fathers is obligatorys and are selecteds",
    //     () async {
    //   getProductComposition.mockGetFathers(obligatoryFathers);
    //   getProductComposition.mockGetChildsOfFather([
    //     ProductCompositionViewModel(
    //       ProductCompositionId:
    //           obligatoryFathers[0].ProductCompositionId.toString(),
    //       EnterpriseId: obligatoryFathers[0].EnterpriseId.toString(),
    //       InternalCodeOnERPCodeFather:
    //           obligatoryFathers[0].InternalCodeOnERPCodeFather.toString(),
    //       InternalCodeOnERPCodeChild:
    //           obligatoryFathers[0].InternalCodeOnERPCodeChild.toString(),
    //       PluChild: obligatoryFathers[0].PluChild.toString(),
    //       ChildName: obligatoryFathers[0].ChildName.toString(),
    //       Quantity: obligatoryFathers[0].Quantity.toString(),
    //       SalePrice: obligatoryFathers[0].SalePrice.toString(),
    //       OfferPrice: obligatoryFathers[0].OfferPrice.toString(),
    //       IncrementValue: obligatoryFathers[0].IncrementValue.toString(),
    //       IsOptionalItem: obligatoryFathers[0].IsOptionalItem.toString(),
    //       ProductOptions: obligatoryFathers[0].ProductOptions.toString(),
    //       indexOfSelectedChild: 0,
    //     ),
    //   ]);

    //   await sut.loadProductComposition(
    //     url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
    //     enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
    //     internalCodeOnErp: internalCodeOnErp,
    //   );

    //   final isValid = sut.comboxIsValid();

    //   expect(isValid, true);
    // });

    // test("Should return true if all fathers is optional and not selecteds",
    //     () async {
    //   getProductComposition.mockGetFathers(optionalFathers);
    //   getProductComposition.mockGetChildsOfFather([
    //     ProductCompositionViewModel(
    //       ProductCompositionId:
    //           optionalFathers[0].ProductCompositionId.toString(),
    //       EnterpriseId: optionalFathers[0].EnterpriseId.toString(),
    //       InternalCodeOnERPCodeFather:
    //           optionalFathers[0].InternalCodeOnERPCodeFather.toString(),
    //       InternalCodeOnERPCodeChild:
    //           optionalFathers[0].InternalCodeOnERPCodeChild.toString(),
    //       PluChild: optionalFathers[0].PluChild.toString(),
    //       ChildName: optionalFathers[0].ChildName.toString(),
    //       Quantity: optionalFathers[0].Quantity.toString(),
    //       SalePrice: optionalFathers[0].SalePrice.toString(),
    //       OfferPrice: optionalFathers[0].OfferPrice.toString(),
    //       IncrementValue: optionalFathers[0].IncrementValue.toString(),
    //       IsOptionalItem: optionalFathers[0].IsOptionalItem.toString(),
    //       ProductOptions: optionalFathers[0].ProductOptions.toString(),
    //       indexOfSelectedChild: null,
    //     ),
    //   ]);

    //   await sut.loadProductComposition(
    //     url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
    //     enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
    //     internalCodeOnErp: internalCodeOnErp,
    //   );

    //   final isValid = sut.comboxIsValid();

    //   expect(isValid, true);
    // });
    // test("Should return true if all fathers is optional and selecteds",
    //     () async {
    //   getProductComposition.mockGetFathers(optionalFathers);
    //   getProductComposition.mockGetChildsOfFather([
    //     ProductCompositionViewModel(
    //       ProductCompositionId:
    //           optionalFathers[0].ProductCompositionId.toString(),
    //       EnterpriseId: optionalFathers[0].EnterpriseId.toString(),
    //       InternalCodeOnERPCodeFather:
    //           optionalFathers[0].InternalCodeOnERPCodeFather.toString(),
    //       InternalCodeOnERPCodeChild:
    //           optionalFathers[0].InternalCodeOnERPCodeChild.toString(),
    //       PluChild: optionalFathers[0].PluChild.toString(),
    //       ChildName: optionalFathers[0].ChildName.toString(),
    //       Quantity: optionalFathers[0].Quantity.toString(),
    //       SalePrice: optionalFathers[0].SalePrice.toString(),
    //       OfferPrice: optionalFathers[0].OfferPrice.toString(),
    //       IncrementValue: optionalFathers[0].IncrementValue.toString(),
    //       IsOptionalItem: optionalFathers[0].IsOptionalItem.toString(),
    //       ProductOptions: optionalFathers[0].ProductOptions.toString(),
    //       indexOfSelectedChild: 0,
    //     ),
    //   ]);

    //   await sut.loadProductComposition(
    //     url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
    //     enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
    //     internalCodeOnErp: internalCodeOnErp,
    //   );

    //   final isValid = sut.comboxIsValid();

    //   expect(isValid, true);
    // });
  });

  group("sut.UpdateSaleRequestTemp", () {
    test("Should call sut.updateSaleRequest with correct values", () async {
      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: updateSaleRequestTempEntity,
          )).called(1);
    });
    test("Should emit correct events on sut.pdateSaleRequest success",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
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
      );
    });
    test(
        "Should call saleRequestTempPresenter.loadSaleRequest with correct values",
        () async {
      await sut.updateSaleRequest(
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
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
      );
    });
  });
}
