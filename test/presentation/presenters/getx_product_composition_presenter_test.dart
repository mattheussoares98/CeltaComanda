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

  late List<ProductCompositionEntity> productsCompositions;
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
    getProductComposition.mockGetProductComposition(productsCompositions);
  }

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    productsCompositions = EntityFactory.makeProductsCompositionsEntity();
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
                  productsCompositions,
                ),
                ProductCompositionViewModel.fromEntityWithChilds(
                  productComposition[1].toEntity(),
                  productsCompositions,
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
      getProductComposition.mockGetProductCompositionError();

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

      verify(() => getProductComposition.get(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            internalCodeOnErp: internalCodeOnErp,
          )).called(1);
    });
  });
}
