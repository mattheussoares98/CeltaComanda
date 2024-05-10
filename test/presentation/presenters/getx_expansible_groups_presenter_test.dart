import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../../ui/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxExpansibleGroupsPresenter sut;
  late HomePresenterSpy homePresenter;

  late List<ExpansibleGroupEntity> expansibleGroups;
  late List<ExpansibleGroupsViewModel> expansibleGroupsViewModel;

  late LoadExpansibleGroupsSpy loadExpansibleGroups;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late NavigateToSpy navigateTo;
  late TicketIsPermittedSpy ticketIsPermitted;
  late SearchProductByCodeSpy searchProductByCode;
  late BarcodeScannerSpy barcodeScanner;

  late String productEan;
  late ProductEntity productEntity;
  late ProductsViewModel productsViewModel;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUseCases() {
    loadExpansibleGroups = LoadExpansibleGroupsSpy();
    ticketIsPermitted = TicketIsPermittedSpy();
    localEnterpriseData = LocalEnterpriseDataSpy();
    navigateTo = NavigateToSpy();
    searchProductByCode = SearchProductByCodeSpy();
    barcodeScanner = BarcodeScannerSpy();
  }

  void initPresenters() {
    homePresenter = HomePresenterSpy();

    sut = GetxExpansibleGroupsPresenter(
      navigateTo: navigateTo,
      loadExpansibleGroups: loadExpansibleGroups,
      ticketIsPermitted: ticketIsPermitted,
      searchProductByCode: searchProductByCode,
      barcodeScanner: barcodeScanner,
    );
  }

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    expansibleGroups = EntityFactory.makeExpansibleGroupsEntity();
    homePresenter.commandNumberMock =
        faker.randomGenerator.integer(3).toString();
    expansibleGroupsViewModel = expansibleGroups
        .map((e) => ExpansibleGroupsViewModel(
              Name: e.Name,
              ExpansibleGroupId: e.ExpansibleGroupId.toString(),
              ExpansibleGroupType: e.ExpansibleGroupType.toString(),
              OrderClassification: e.OrderClassification.toString(),
            ))
        .toList();
    productEan = faker.randomGenerator.integer(13).toString();
    productEntity = EntityFactory.makeProductsEntitys()[0];
    productsViewModel = ProductsViewModel.fromEntity(productEntity);
  }

  void mockSuccess() {
    loadExpansibleGroups.mockLoadExpansibleGroups(expansibleGroups);
    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    navigateTo.mockNavigate();
    searchProductByCode.mockSearchProductByCode(productEntity);
  }

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EnterpriseDataBuilder.enterpriseDataEntity);
    registerFallbackValue(EntityFactory.makeSaleRequestTempProductsViewModel());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(SaleRequestTempPresenterSpy());
    registerFallbackValue(ExpansibleGroupsPresenterSpy());
    registerFallbackValue(const EnterpriseEntity(enterpriseName: ""));
  });

  test('Should call LoadExpansibleGroups', () async {
    await sut.load(homePresenter.commandNumberMock!);

    verify(() => loadExpansibleGroups.load()).called(1);
  });

  test('Should throw DomainErrorUnexpected', () async {
    loadExpansibleGroups.mockLoadExpansibleGroupsError(DomainError.unexpected);

    final error = sut.load(homePresenter.commandNumberMock!);

    expect(sut.expansibleGroups, []);
    expect(error, throwsA(DomainError.unexpected));
  });

  test('Should return correct value on success to load', () async {
    await sut.load(homePresenter.commandNumberMock!);

    expect(sut.expansibleGroups, expansibleGroupsViewModel);
  });

  test('Should clear expansibleGroups', () async {
    await sut.load(homePresenter.commandNumberMock!);
    expect(sut.expansibleGroups, expansibleGroupsViewModel);

    sut.clear();
    expect(sut.expansibleGroups, []);
  });

  test('Should go to products page ExpansibleGroupItem click', () async {
    sut.goToProductsPage(expansibleGroups[0]);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.products,
        arguments: expansibleGroups[0],
      ),
    ).called(1);
  });

  test('Should call ticketIsPermitted on load data', () async {
    await sut.load(homePresenter.commandNumberMock!);

    verify(() => ticketIsPermitted.verify(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          commandNumber: homePresenter.commandNumberMock!,
        )).called(1);
  });

  test(
      'Should throw DomainError.commandNotAvailable on ticketIsPermitted throws commandNotAvailable',
      () async {
    ticketIsPermitted.mockError(DomainError.commandNotAvailable);

    final error = sut.load(homePresenter.commandNumberMock!);

    expect(error, throwsA(DomainError.commandNotAvailable));
  });

  test(
      'Should throw DomainError.unexpected on ticketIsPermitted throws unexpected',
      () async {
    ticketIsPermitted.mockError(DomainError.unexpected);

    final error = sut.load(homePresenter.commandNumberMock!);

    expect(error, throwsA(DomainError.unexpected));
  });

  group("SearchProductByCode", () {
    test(
        "Should call searchProductByCode with correct values and update string to correct format of plu",
        () async {
      await sut.searchProduct("123456");

      verify(() => searchProductByCode.search(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            value: "12345-6",
          )).called(1);

      await sut.searchProduct("12345");

      verify(() => searchProductByCode.search(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            value: "01234-5",
          )).called(1);

      await sut.searchProduct("1");

      verify(() => searchProductByCode.search(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            value: "00000-1",
          )).called(1);

      await sut.searchProduct("1234567890123");

      verify(() => searchProductByCode.search(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            value: "1234567890123",
          )).called(1);

      await sut.searchProduct("1234567");

      verify(() => searchProductByCode.search(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            value: "1234567",
          )).called(1);
    });

    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.searchProduct(productEan);
    });

    test(
        "Should emit correct values on searchProductByCode throws unexpectedError",
        () async {
      searchProductByCode.mockError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.searchProduct(productEan);
    });

    test("Should emit correct values on dont found product", () async {
      searchProductByCode.mockError(DomainError.productNotFound);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.productNotFound]));

      await sut.searchProduct(productEan);
    });

    test("Should return correct product on success", () async {
      expect(sut.searchedProduct, null);
      await sut.searchProduct(productEan);

      expect(sut.searchedProduct, productsViewModel);
    });

    test("Should return null if product not found", () async {
      searchProductByCode.mockSearchProductByCode(null);

      expect(sut.searchedProduct, null);
      await sut.searchProduct(productEan);

      expect(sut.searchedProduct, null);
    });

    test("Should clear searchedProduct when search command data", () async {
      expect(sut.searchedProduct, null);

      await sut.searchProduct(productEan);
      expect(sut.searchedProduct, productsViewModel);

      await sut.load(homePresenter.commandNumberMock!);
      expect(sut.searchedProduct, null);
    });

    test("Should clear searchedProduct not found product", () async {
      await sut.searchProduct(productEan);
      expect(sut.searchedProduct, productsViewModel);

      searchProductByCode.mockSearchProductByCode(null);
      await sut.searchProduct(productEan);
      expect(sut.searchedProduct, null);
    });
  });

  group("BarcodeScanner", () {
    test("Should search product if barcode is not empty", () async {
      barcodeScanner.mockBarcodeScanner("1234567890123");
      await sut.readBarcodeAndSearchProduct();

      verify(() => barcodeScanner.read()).called(1);
      verify(() => searchProductByCode.search(
            value: "1234567890123",
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          )).called(1);
    });

    test("Should not search product if barcode is empty", () async {
      barcodeScanner.mockBarcodeScanner("");
      await sut.readBarcodeAndSearchProduct();

      verify(() => barcodeScanner.read()).called(1);
      verifyNever(() => searchProductByCode.search(
            value: "",
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          ));
    });

    test("Should emit correct events if barcodeScanner throws", () async {
      barcodeScanner.mockBarcodeScannerError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.readBarcodeAndSearchProduct();
    });

    test("Should emit correct events on barcodeScanner success", () async {
      barcodeScanner.mockBarcodeScanner("1234567890123");

      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.readBarcodeAndSearchProduct();
    });

    test("Should update searchProductController correctly", () async {
      expect(sut.searchProductController.text, "");
      
      barcodeScanner.mockBarcodeScanner("1234567890123");
      await sut.readBarcodeAndSearchProduct();
      expect(sut.searchProductController.text, "1234567890123");

      barcodeScanner.mockBarcodeScanner("");
      await sut.readBarcodeAndSearchProduct();
      expect(sut.searchProductController.text, "");
    });
  });
}
