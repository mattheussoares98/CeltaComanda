import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../../ui/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxExpansibleGroupsPresenter sut;
  late PrintedProductsPresenterSpy printedProductsPresenter;
  late SaleRequestTempPresenterSpy saleRequestTempPresenter;

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
  late TicketIsPermittedSpy ticketIsPermitted;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    commandNumber = "001";
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    loadExpansibleGroups = LoadExpansibleGroupsSpy();
    loadPrintedProducts = LoadPrintedProductsSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
    saleRequestTempPresenter = SaleRequestTempPresenterSpy();
    ticketIsPermitted = TicketIsPermittedSpy();

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
      ticketIsPermitted: ticketIsPermitted,
    );
  });

  setUpAll(() {
    registerFallbackValue(EnterpriseDataBuilder.enterpriseDataEntity);
    registerFallbackValue(const EnterpriseEntity(enterpriseName: ""));
    registerFallbackValue(EntityFactory.makeSaleRequestTempProductsViewModel());
  });

  test('Should call load products', () async {
    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

    verify(() => loadExpansibleGroups.load()).called(1);
  });

  test('Should throw DomainErrorUnexpected', () async {
    loadExpansibleGroups.mockLoadExpansibleGroupsError(DomainError.unexpected);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

    expect(sut.expansibleGroups, []);
  });

  test('Should emit correct events on success load expansible groups',
      () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

    expect(sut.expansibleGroups, expansibleGroupsViewModel);
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
    sut.goToSplashPage(
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

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
    expectLater(sut.mainErrorStream, emits(null));

    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );
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
    loadExpansibleGroups
        .mockLoadExpansibleGroupsError(DomainError.commandNotAvailable);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(
        sut.mainErrorStream, emitsInOrder([null, UIError.commandNotAvailable]));

    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );
  });

  test('Should call LoadSaleRequestTemp when load expansibleGroups', () async {
    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

    verify(() => saleRequestTempPresenter.load(commandNumber)).called(1);
  });

  test('Should call LoadPrinted when load expansibleGroups', () async {
    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

    verify(() => printedProductsPresenter.load(commandNumber)).called(1);
  });

  test('Should clear EnterpriseDataBuilder when go to SplashPage', () async {
    await sut.goToSplashPage(
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

    expect(
        EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName, isNotEmpty);
    expect(EnterpriseDataBuilder.enterpriseDataEntity?.url, null);
    expect(EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseId, null);
  });

  test('Should clear SaleRequestTemp when go to SplashPage', () async {
    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );
    await sut.goToSplashPage(
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

    expect(saleRequestTempPresenter.saleRequestTemp, null);
  });

  test('Should clear expansibleGroups when go to SplashPage', () async {
    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

    await sut.goToSplashPage(
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

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

  test('Should call clearPrintedProducts on load data', () async {
    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

    verify(() => printedProductsPresenter.clear()).called(1);
  });

  test('Should call clearSaleRequestTemp on load data', () async {
    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

    verify(() => saleRequestTempPresenter.clear()).called(1);
  });

  test('Should update commandNumber on load data', () async {
    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

    expect(sut.commandNumber, commandNumber);
  });

  test('Should call ticketIsPermitted on load data', () async {
    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

    verify(() => ticketIsPermitted.verify(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          commandNumber: commandNumber,
        )).called(1);
  });

  test(
      'Should correct events on ticketIsPermitted throws commandNotAvailable',
      () async {
    ticketIsPermitted.mockError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(
        sut.mainErrorStream, emitsInOrder([null, UIError.commandNotAvailable]));

    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );
  });
}
