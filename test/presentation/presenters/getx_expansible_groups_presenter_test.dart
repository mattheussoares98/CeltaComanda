import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/mocks/load_expansible_groups_spy.dart';
import '../../domain/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxExpansibleGroupsPresenter sut;
  late EnterpriseEntity enterpriseEntity;
  late List<ExpansibleGroupEntity> expansibleGroups;
  late SaleRequestTempEntity saleRequestTempEntity;
  late List<ExpansibleGroupsViewModel> expansibleGroupsViewModel;
  late PrintedEntity printedProducts;
  late String commandNumber;
  late LoadExpansibleGroupsSpy loadExpansibleGroups;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late NavigateToSpy navigateTo;
  late LoadPrintedProductsSpy loadPrintedProducts;
  late ClearExpansibleGroupsSpy clearExpansibleGroups;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    commandNumber = "001";
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    loadExpansibleGroups = LoadExpansibleGroupsSpy();
    loadPrintedProducts = LoadPrintedProductsSpy();
    clearExpansibleGroups = ClearExpansibleGroupsSpy();

    expansibleGroups = EntityFactory.makeExpansibleGroupsEntity();
    printedProducts = EntityFactory.makePrintedProductsEntity();

    expansibleGroupsViewModel = expansibleGroups
        .map((e) => ExpansibleGroupsViewModel(
              Name: e.Name,
              ExpansibleGroupId: e.ExpansibleGroupId,
              ExpansibleGroupType: e.ExpansibleGroupType,
              OrderClassification: e.OrderClassification,
            ))
        .toList();

    loadExpansibleGroups.mockLoadExpansibleGroups(expansibleGroups);
    saleRequestTempEntity = EntityFactory.makeApiSaleRequestEntity();
    loadSaleRequestTemp.mockLoadSaleRequestTemp(saleRequestTempEntity);
    loadPrintedProducts.mockLoadPrintedProducts(printedProducts);

    navigateTo = NavigateToSpy();
    navigateTo.mockNavigate();
    localEnterpriseData = LocalEnterpriseDataSpy();

    enterpriseEntity = EnterpriseEntity(
      enterpriseName:
          EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
    );

    localEnterpriseData.mockAdd(enterpriseEntity);

    sut = GetxExpansibleGroupsPresenter(
      navigateTo: navigateTo,
      loadExpansibleGroups: loadExpansibleGroups,
      localEnterpriseData: localEnterpriseData,
      loadSaleRequestTemp: loadSaleRequestTemp,
      loadPrintedProducts: loadPrintedProducts,
      clearExpansibleGroups: clearExpansibleGroups,
    );
  });

  setUpAll(() {
    registerFallbackValue(EnterpriseDataBuilder.enterpriseDataEntity);
    registerFallbackValue(const EnterpriseEntity(enterpriseName: ""));
  });

  test('Should call load products', () async {
    await sut.getExpansibleGroups();

    verify(() => loadExpansibleGroups.load()).called(1);
  });

  test('Should throw DomainErrorUnexpected', () async {
    loadExpansibleGroups.mockLoadExpansibleGroupsError();

    final future = sut.getExpansibleGroups();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should emit correct events on success load expansible groups',
      () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.getExpansibleGroups();

    expect(sut.expansibleGroups, expansibleGroupsViewModel);
  });

  test('Should go to cart page on CartIcon click', () async {
    sut.goToCartPage();

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.cart,
      ),
    ).called(1);
  });

  test('Should go to products page ExpansibleGroupItem click', () async {
    sut.goToProductsPage(expansibleGroups[0].ExpansibleGroupId);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.products,
        arguments: expansibleGroups[0].ExpansibleGroupId,
      ),
    ).called(1);
  });

  test('Should go to SplashPage on logout click', () async {
    sut.goToSplashPage();

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.splash,
        clear: true,
      ),
    ).called(1);
  });

  test('Should clear local data on logout', () async {
    await sut.clearEnterpriseData();

    verify(() => localEnterpriseData.add(enterpriseEntity)).called(1);
  });

  test('Should emit correct events on verify command success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.load(commandNumber);
  });
  test('Should return correct value on loadSaleRequestTemp', () async {
    final value = await loadSaleRequestTemp.load(
      url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
      commandNumber: commandNumber,
    );

    expect(value, saleRequestTempEntity);
  });

  test('Should correct events on load command throws commandNotAvailable',
      () async {
    loadSaleRequestTemp.mockError(DomainError.commandNotAvailable);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.load(commandNumber);
  });

  test('Should emit correct events on get saleRequestTemp', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.load(commandNumber);

    final saleRequestTempViewModel =
        SaleRequestTempViewModel.fromEntity(saleRequestTempEntity);

    expect(sut.saleRequestTemp, saleRequestTempViewModel);
  });

  test('Should clear EnterpriseDataBuilder when go to SplashPage', () async {
    await sut.goToSplashPage();

    expect(
        EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName, isNotEmpty);
    expect(EnterpriseDataBuilder.enterpriseDataEntity?.url, null);
    expect(EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseId, null);
  });

  test('Should clear SaleRequestTemp when go to SplashPage', () async {
    await sut.load(commandNumber);
    await sut.goToSplashPage();

    expect(sut.saleRequestTemp, null);
  });

  test('Should clear expansibleGroups when go to SplashPage', () async {
    await sut.getExpansibleGroups();
    await sut.goToSplashPage();

    expect(sut.expansibleGroups, []);
  });

  test('Should return correct values on LoadPrintedProducts', () async {
    final result = await loadPrintedProducts.load(
      url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
      commandNumber: 1,
    );

    expect(result, printedProducts);
  });

  test('Should throws unexpected error when LoadPrintedProducts', () async {
    loadPrintedProducts.mockError(DomainError.unexpected);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.load(commandNumber);
  });

  test('Should call ClearExpansibleGroups on load data', () async {
    await sut.load(commandNumber);

    verify(() => clearExpansibleGroups.clear()).called(1);
  });
}
