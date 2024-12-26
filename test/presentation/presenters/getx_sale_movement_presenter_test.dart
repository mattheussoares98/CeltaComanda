import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import '../../ui/mocks/mocks.dart';

void main() {
  late GetxSaleMovementPresenter sut;

  late LoadSaleMovementConcentratorSpy loadSaleMovementConcentrator;

  late String date;
  late List<SaleMovementConcentratorEntity> salesEntitys;
  late List<SaleMovementConcentratorModel> salesModels;

  void initUseCases() {
    loadSaleMovementConcentrator = LoadSaleMovementConcentratorSpy();
  }

  void initPresenters() {
    sut = GetxSaleMovementPresenter(
      loadSaleMovementConcentrator: loadSaleMovementConcentrator,
    );
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
    date = DateTime.now().toIso8601String();
    salesEntitys = [EntityFactory.makeSaleMovementConcentratorEntity()];
    salesModels = salesEntitys
        .map((e) => SaleMovementConcentratorModel.fromEntity(e))
        .toList();
  }

  void mockSuccess() {
    loadSaleMovementConcentrator.mockLoad(salesEntitys);
  }

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeCartProductEntity(
      maximumProductQuantity: 0,
      minimumProductQuantity: 0,
    ));
    registerFallbackValue(EntityFactory.makeEnterpriseData());
    registerFallbackValue(EntityFactory.makeCommandEntity());
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    registerFallbackValue(EntityFactory.makePdvEntity());
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
  });

  group("Load sale movement", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.salesStream, emitsInOrder([null, salesModels]));

      await sut.loadSales(date: date);
    });
    test("Should emit correct values on error", () async {
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.salesStream, emits(null));

      loadSaleMovementConcentrator.mockError();

      await sut.loadSales(date: date);
    });
    test("Should call load sale movement with correct date", () async {
      await sut.loadSales(date: date);

      verify(() => loadSaleMovementConcentrator.load(date: date)).called(1);
    });
  });
}
