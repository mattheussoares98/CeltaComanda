import 'package:clean_celta_mobile/domain/entities/entities.dart';
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

void main() {
  late GetxProductCompositionPresenter sut;

  late GetProductCompositionSpy getProductComposition;

  late List<ProductCompositionEntity> optionalFathers;
  late List<ProductCompositionEntity> obligatoryFathers;
  late int internalCodeOnErp;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initPresenters() {
    sut = GetxProductCompositionPresenter(
      getProductComposition: getProductComposition,
    );
  }

  void initUsecases() {
    getProductComposition = GetProductCompositionSpy();
  }

  void initMocks() {
    getProductComposition.mockGetFathers(optionalFathers);
    getProductComposition.mockGetChildsOfFather(optionalFathers
        .map((element) => ProductCompositionViewModel.fromEntityWithChilds(
            element, optionalFathers))
        .toList());
  }

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    optionalFathers =
        EntityFactory.makeProductsCompositionsEntity(isOptionalItem: true);
    obligatoryFathers =
        EntityFactory.makeProductsCompositionsEntity(isOptionalItem: false);
    internalCodeOnErp = faker.randomGenerator.integer(99);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMocks();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseData());
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
    test("Should return false if all fathers is obligatorys and not selecteds",
        () async {
      getProductComposition.mockGetFathers(obligatoryFathers);
      getProductComposition.mockGetChildsOfFather([
        ProductCompositionViewModel(
          ProductCompositionId:
              obligatoryFathers[0].ProductCompositionId.toString(),
          EnterpriseId: obligatoryFathers[0].EnterpriseId.toString(),
          InternalCodeOnERPCodeFather:
              obligatoryFathers[0].InternalCodeOnERPCodeFather.toString(),
          InternalCodeOnERPCodeChild:
              obligatoryFathers[0].InternalCodeOnERPCodeChild.toString(),
          PluChild: obligatoryFathers[0].PluChild.toString(),
          ChildName: obligatoryFathers[0].ChildName.toString(),
          Quantity: obligatoryFathers[0].Quantity.toString(),
          SalePrice: obligatoryFathers[0].SalePrice.toString(),
          OfferPrice: obligatoryFathers[0].OfferPrice.toString(),
          IncrementValue: obligatoryFathers[0].IncrementValue.toString(),
          IsOptionalItem: obligatoryFathers[0].IsOptionalItem.toString(),
          ProductOptions: obligatoryFathers[0].ProductOptions.toString(),
          indexOfSelectedChild: null,
        ),
      ]);

      await sut.loadProductComposition(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        internalCodeOnErp: internalCodeOnErp,
      );

      final isValid = sut.comboxIsValid();

      expect(isValid, false);
    });

    test("Should return true if all fathers is obligatorys and are selecteds",
        () async {
      getProductComposition.mockGetFathers(obligatoryFathers);
      getProductComposition.mockGetChildsOfFather([
        ProductCompositionViewModel(
          ProductCompositionId:
              obligatoryFathers[0].ProductCompositionId.toString(),
          EnterpriseId: obligatoryFathers[0].EnterpriseId.toString(),
          InternalCodeOnERPCodeFather:
              obligatoryFathers[0].InternalCodeOnERPCodeFather.toString(),
          InternalCodeOnERPCodeChild:
              obligatoryFathers[0].InternalCodeOnERPCodeChild.toString(),
          PluChild: obligatoryFathers[0].PluChild.toString(),
          ChildName: obligatoryFathers[0].ChildName.toString(),
          Quantity: obligatoryFathers[0].Quantity.toString(),
          SalePrice: obligatoryFathers[0].SalePrice.toString(),
          OfferPrice: obligatoryFathers[0].OfferPrice.toString(),
          IncrementValue: obligatoryFathers[0].IncrementValue.toString(),
          IsOptionalItem: obligatoryFathers[0].IsOptionalItem.toString(),
          ProductOptions: obligatoryFathers[0].ProductOptions.toString(),
          indexOfSelectedChild: 0,
        ),
      ]);

      await sut.loadProductComposition(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        internalCodeOnErp: internalCodeOnErp,
      );

      final isValid = sut.comboxIsValid();

      expect(isValid, true);
    });

    test("Should return true if all fathers is optional and not selecteds",
        () async {
      getProductComposition.mockGetFathers(optionalFathers);
      getProductComposition.mockGetChildsOfFather([
        ProductCompositionViewModel(
          ProductCompositionId:
              optionalFathers[0].ProductCompositionId.toString(),
          EnterpriseId: optionalFathers[0].EnterpriseId.toString(),
          InternalCodeOnERPCodeFather:
              optionalFathers[0].InternalCodeOnERPCodeFather.toString(),
          InternalCodeOnERPCodeChild:
              optionalFathers[0].InternalCodeOnERPCodeChild.toString(),
          PluChild: optionalFathers[0].PluChild.toString(),
          ChildName: optionalFathers[0].ChildName.toString(),
          Quantity: optionalFathers[0].Quantity.toString(),
          SalePrice: optionalFathers[0].SalePrice.toString(),
          OfferPrice: optionalFathers[0].OfferPrice.toString(),
          IncrementValue: optionalFathers[0].IncrementValue.toString(),
          IsOptionalItem: optionalFathers[0].IsOptionalItem.toString(),
          ProductOptions: optionalFathers[0].ProductOptions.toString(),
          indexOfSelectedChild: null,
        ),
      ]);

      await sut.loadProductComposition(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        internalCodeOnErp: internalCodeOnErp,
      );

      final isValid = sut.comboxIsValid();

      expect(isValid, true);
    });
    test("Should return true if all fathers is optional and selecteds",
        () async {
      getProductComposition.mockGetFathers(optionalFathers);
      getProductComposition.mockGetChildsOfFather([
        ProductCompositionViewModel(
          ProductCompositionId:
              optionalFathers[0].ProductCompositionId.toString(),
          EnterpriseId: optionalFathers[0].EnterpriseId.toString(),
          InternalCodeOnERPCodeFather:
              optionalFathers[0].InternalCodeOnERPCodeFather.toString(),
          InternalCodeOnERPCodeChild:
              optionalFathers[0].InternalCodeOnERPCodeChild.toString(),
          PluChild: optionalFathers[0].PluChild.toString(),
          ChildName: optionalFathers[0].ChildName.toString(),
          Quantity: optionalFathers[0].Quantity.toString(),
          SalePrice: optionalFathers[0].SalePrice.toString(),
          OfferPrice: optionalFathers[0].OfferPrice.toString(),
          IncrementValue: optionalFathers[0].IncrementValue.toString(),
          IsOptionalItem: optionalFathers[0].IsOptionalItem.toString(),
          ProductOptions: optionalFathers[0].ProductOptions.toString(),
          indexOfSelectedChild: 0,
        ),
      ]);

      await sut.loadProductComposition(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        internalCodeOnErp: internalCodeOnErp,
      );

      final isValid = sut.comboxIsValid();

      expect(isValid, true);
    });
  });
}
