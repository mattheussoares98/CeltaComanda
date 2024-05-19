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
  late SaleRequestTempPresenterSpy saleRequestTempPresenter;
  late PrintedProductsPresenterSpy printedProductsPresenter;
  late ExpansibleGroupsPresenterSpy expansibleGroupsPresenter;

  late List<ExpansibleGroupEntity> expansibleGroups;
  late List<ExpansibleGroupsViewModel> expansibleGroupsViewModel;

  late LoadExpansibleGroupsSpy loadExpansibleGroups;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late NavigateToSpy navigateTo;
  late TicketIsPermittedSpy ticketIsPermitted;
  late SearchProductByCodeSpy searchProductByCode;
  late BarcodeScannerSpy barcodeScanner;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;

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
    updateSaleRequestTemp = UpdateSaleRequestTempSpy();
  }

  void initPresenters() {
    homePresenter = HomePresenterSpy();
    saleRequestTempPresenter = SaleRequestTempPresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
    expansibleGroupsPresenter = ExpansibleGroupsPresenterSpy();

    sut = GetxExpansibleGroupsPresenter(
      navigateTo: navigateTo,
      loadExpansibleGroups: loadExpansibleGroups,
      ticketIsPermitted: ticketIsPermitted,
      searchProductByCode: searchProductByCode,
      barcodeScanner: barcodeScanner,
      updateSaleRequestTemp: updateSaleRequestTemp,
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
    saleRequestTempPresenter.saleRequestTempMock =
        EntityFactory.makeSaleRequestTempViewModel(
            EntityFactory.makeProductModel());
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
    registerFallbackValue(EntityFactory.makeUpdateSaleRequestTempEntity());
  });

  test('Should call LoadExpansibleGroups', () async {
    await sut.loadGroups(homePresenter.commandNumberMock!);

    verify(() => loadExpansibleGroups.load()).called(1);
  });

  test('Should throw DomainErrorUnexpected', () async {
    loadExpansibleGroups.mockLoadExpansibleGroupsError(DomainError.unexpected);

    final error = sut.loadGroups(homePresenter.commandNumberMock!);

    expect(sut.expansibleGroups, []);
    expect(error, throwsA(DomainError.unexpected));
  });

  test('Should return correct value on success to load', () async {
    await sut.loadGroups(homePresenter.commandNumberMock!);

    expect(sut.expansibleGroups, expansibleGroupsViewModel);
  });

  test('Should clear expansibleGroups', () async {
    await sut.loadGroups(homePresenter.commandNumberMock!);
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
  test('Should go to ComboxPage', () async {
    await sut.searchProduct(productEan);

    sut.goToComboxPage(ProductsViewModel.fromEntity(productEntity));

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.productComposition,
        arguments: ProductsViewModel.fromEntity(productEntity),
      ),
    ).called(1);
  });

  test('Should call ticketIsPermitted on load data', () async {
    await sut.loadGroups(homePresenter.commandNumberMock!);

    verify(() => ticketIsPermitted.verify(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          commandNumber: homePresenter.commandNumberMock!,
        )).called(1);
  });

  test(
      'Should throw DomainError.commandNotAvailable on ticketIsPermitted throws commandNotAvailable',
      () async {
    ticketIsPermitted.mockError(DomainError.commandNotAvailable);

    final error = sut.loadGroups(homePresenter.commandNumberMock!);

    expect(error, throwsA(DomainError.commandNotAvailable));
  });

  test(
      'Should throw DomainError.unexpected on ticketIsPermitted throws unexpected',
      () async {
    ticketIsPermitted.mockError(DomainError.unexpected);

    final error = sut.loadGroups(homePresenter.commandNumberMock!);

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

      await sut.loadGroups(homePresenter.commandNumberMock!);
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

    test("Should update searchProductController correctly on success",
        () async {
      barcodeScanner.mockBarcodeScanner("1234567890123");

      await sut.readBarcodeAndSearchProduct();

      expect(sut.searchProductController.text, "");
    });

    test("Should update searchProductController correctly on error", () async {
      expect(sut.searchProductController.text, "");

      barcodeScanner.mockBarcodeScanner("1234567890123");
      searchProductByCode.mockError(DomainError.unexpected);
      await sut.readBarcodeAndSearchProduct();

      expect(sut.searchProductController.text, "1234567890123");
    });
  });

  group("Add product quantity (updateSaleRequest)", () {
    test("Should emit correct events on UpdateSaleRequest success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
      );
    });

    test("Should emit correct events on UpdateSaleRequest throws", () async {
      updateSaleRequestTemp.mockUpdateSaleRequestTempError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
      );
    });

    test("Should call updateSaleRequestTemp", () async {
      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
      );

      String numberAmerican =
          productsViewModel.SaleRetailPraticed.replaceAll(RegExp(r','), '.');

      double saleRetailPraticed = double.parse(numberAmerican);

      final entity = UpdateSaleRequestTempEntity(
        DeliveryControl: int.parse(
            saleRequestTempPresenter.saleRequestTempMock!.DeliveryControl),
        EnterpriseId: int.parse(
            saleRequestTempPresenter.saleRequestTempMock!.EnterpriseId),
        PersonalizedCode:
            saleRequestTempPresenter.saleRequestTempMock!.PersonalizedCode,
        SaleRequestTempId: int.parse(
            saleRequestTempPresenter.saleRequestTempMock!.SaleRequestTempId),
        TotalLiquid: saleRetailPraticed,
        Products: [
          UpdateSaleRequestTempProductEntity(
            ProductInternalCodeOnErp:
                int.parse(productsViewModel.InternalCodeOnERP.toString()),
            ProductPriceLookUpCode: productsViewModel.PriceLookupCode,
            Quantity: 1,
            SaleRequestTempId: int.parse(saleRequestTempPresenter
                .saleRequestTempMock!.SaleRequestTempId),
            TotalLiquid: saleRetailPraticed,
            Value: saleRetailPraticed,
          )
        ],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: entity,
          )).called(1);
    });

    test('Should call SaleRequestTempPresenter.load', () async {
      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
      );

      verify(() => saleRequestTempPresenter
          .loadSaleRequest(homePresenter.commandNumberMock!)).called(1);
    });
  });

  group("Load commandData", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        homePresenter: homePresenter,
      );
    });

    test(
        "Should emit correct values on loadCommandData throws commandNotAvailable",
        () async {
      ticketIsPermitted.mockError(DomainError.commandNotAvailable);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        homePresenter: homePresenter,
      );
    });

    test("Should emit correct values on loadCommandData throws", () async {
      ticketIsPermitted.mockError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        homePresenter: homePresenter,
      );
    });

    test("Should update commandNumber", () async {
      homePresenter.commandNumberMock = "9999";

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        homePresenter: homePresenter,
      );

      expect(homePresenter.commandNumberMock, "9999");
    });

    test("Should call clearData on LoadCommandData call", () async {
      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        homePresenter: homePresenter,
      );

      expect(
          sut.expansibleGroups,
          expansibleGroups
              .map((e) => ExpansibleGroupsViewModel.fromEntity(e))
              .toList());

      loadExpansibleGroups
          .mockLoadExpansibleGroupsError(DomainError.unexpected);

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        homePresenter: homePresenter,
      );

      expect(sut.expansibleGroups, []);
      verify(() => printedProductsPresenter.clear()).called(2);
      verify(() => saleRequestTempPresenter.clear()).called(2);
      //como o sut não é mockado, fiz um teste primeiro com sucesso pra ter
      //certeza que vai colocar dados no expansibleGroups e outro teste com
      //erro, pra ter certeza que vai chamar a função para limpar a lista de
      //grupos expansíveis
    });

    test("Should call ticketIsPermitted only one time", () async {
      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        homePresenter: homePresenter,
      );

      verify(() => ticketIsPermitted.verify(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            commandNumber: homePresenter.commandNumberMock!,
          )).called(1);
    });

    test("Should call loadGroups, saleRequestTemp and PrintedProducts",
        () async {
      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        homePresenter: homePresenter,
      );

      verify(() => loadExpansibleGroups.load()).called(1);
      verify(() => printedProductsPresenter
          .loadPrinted(homePresenter.commandNumberMock!)).called(1);
      verify(() => saleRequestTempPresenter
          .loadSaleRequest(homePresenter.commandNumberMock!)).called(1);
    });

    test(
        "Should update commandNumber with null value on error to LoadCommandData",
        () async {
      ticketIsPermitted.mockError(DomainError.unexpected);

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        homePresenter: homePresenter,
      );

      verify(() => homePresenter.updateCommandNumber(null)).called(1);
    });
  });
}
