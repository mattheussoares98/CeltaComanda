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
  late GetxMenuPresenter sut;
  late HomePresenterSpy homePresenter;
  late CartPresenterSpy cartPresenter;
  late PrintedProductsPresenterSpy printedProductsPresenter;
  late MenuPresenterSpy menuPresenter;

  late List<ExpansibleGroupEntity> expansibleGroups;
  late List<ExpansibleGroupsViewModel> expansibleGroupsViewModel;
  late List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>> menuList;

  late LoadExpansibleGroupsSpy loadExpansibleGroups;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late NavigateToSpy navigateTo;
  late TicketIsPermittedSpy ticketIsPermitted;
  late SearchProductByCodeSpy searchProductByCode;
  late BarcodeScannerSpy barcodeScanner;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late LoadProductsSpy loadProducts;

  late String productEan;
  late ProductEntity productEntity;
  late ProductsViewModel productsViewModel;
  late List<ProductEntity> products;
  late String newComment;

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
    loadProducts = LoadProductsSpy();
  }

  void initPresenters() {
    homePresenter = HomePresenterSpy();
    cartPresenter = CartPresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
    menuPresenter = MenuPresenterSpy();

    sut = GetxMenuPresenter(
      navigateTo: navigateTo,
      loadExpansibleGroups: loadExpansibleGroups,
      ticketIsPermitted: ticketIsPermitted,
      searchProductByCode: searchProductByCode,
      barcodeScanner: barcodeScanner,
      updateSaleRequestTemp: updateSaleRequestTemp,
      loadProducts: loadProducts,
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

    cartPresenter.saleRequestTempMock =
        EntityFactory.makeSaleRequestTempViewModel(
            EntityFactory.makeProductModel());

    products = EntityFactory.makeProductsEntitys();

    menuList = expansibleGroupsViewModel
        .map((expansibleGroup) => {
              expansibleGroup: products
                  .map((product) => ProductsViewModel.fromEntity(product))
                  .toList(),
            })
        .toList();
    newComment = faker.randomGenerator.string(20);
  }

  void mockSuccess() {
    loadExpansibleGroups.mockLoadExpansibleGroups(expansibleGroups);
    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    navigateTo.mockNavigate();
    searchProductByCode.mockSearchProductByCode(productEntity);
    loadProducts.mockLoadProducts(products);
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
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(const EnterpriseEntity(enterpriseName: ""));
    registerFallbackValue(EntityFactory.makeUpdateSaleRequestTempEntity());
  });

  group("Get groups and products", () {
    test('Should emit correct values on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.menuStream, emitsInOrder([[], menuList]));

      await sut.getGroupsAndProducts(homePresenter.commandNumberMock!);
    });
    test('Should emit correct values on throws CommandNotAvailable', () async {
      loadExpansibleGroups
          .mockLoadExpansibleGroupsError(DomainError.commandNotAvailable);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.getGroupsAndProducts(homePresenter.commandNumberMock!);
    });
    test('Should emit correct values on throws unexpected', () async {
      loadExpansibleGroups
          .mockLoadExpansibleGroupsError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.getGroupsAndProducts(homePresenter.commandNumberMock!);
    });
    test('Should call LoadExpansibleGroups and loadProducts', () async {
      await sut.getGroupsAndProducts(homePresenter.commandNumberMock!);

      verify(() => loadExpansibleGroups.load()).called(1);
      verify(() => loadProducts.load(expansibleGroups[0].ExpansibleGroupId))
          .called(1);
      verify(() => loadProducts.load(expansibleGroups[1].ExpansibleGroupId))
          .called(1);
    });

    test(
        'Should emit correct values on LoadExpansibleGroups throws unexpectedError',
        () async {
      loadExpansibleGroups
          .mockLoadExpansibleGroupsError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.getGroupsAndProducts(homePresenter.commandNumberMock!);
    });

    test('Should return correct value on success to load', () async {
      await sut.getGroupsAndProducts(homePresenter.commandNumberMock!);

      expect(sut.loadedMenu, menuList);
    });

    test('Should clear expansibleGroups', () async {
      await sut.getGroupsAndProducts(homePresenter.commandNumberMock!);
      expect(sut.loadedMenu, menuList);

      sut.clear();
      expect(sut.loadedMenu, []);
    });

    test('Should update index of selectedGroup when search groups again',
        () async {
      expectLater(sut.indexOfSelectedGroupStream, emits(0));
          
      await sut.getGroupsAndProducts(homePresenter.commandNumberMock!);
    });
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

      await sut.getGroupsAndProducts(homePresenter.commandNumberMock!);
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
      barcodeScanner.mockError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.readBarcodeAndSearchProduct();
    });

    test("Should emit correct events if barcodeScanner return empty value", () async {
      barcodeScanner.mockError(DomainError.barcodeNotRead);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.barcodeNotRead]));
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

  group("Load commandData", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );
    });

    test(
        "Should emit correct values on loadCommandData throws commandNotAvailable",
        () async {
      ticketIsPermitted.mockError();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );
    });

    test("Should update commandNumber", () async {
      homePresenter.commandNumberMock = "9999";

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      expect(homePresenter.commandNumberMock, "9999");
    });

    test("Should call clearData on LoadCommandData call", () async {
      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      expect(sut.loadedMenu, menuList);

      loadExpansibleGroups
          .mockLoadExpansibleGroupsError(DomainError.unexpected);

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      expect(sut.loadedMenu, []);
      verify(() => printedProductsPresenter.clear()).called(2);
      verify(() => cartPresenter.clear()).called(2);
      //como o sut não é mockado, fiz um teste primeiro com sucesso pra ter
      //certeza que vai colocar dados no expansibleGroups e outro teste com
      //erro, pra ter certeza que vai chamar a função para limpar a lista de
      //grupos expansíveis
    });

    test("Should call ticketIsPermitted only one time", () async {
      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
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
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      verify(() => loadExpansibleGroups.load()).called(1);
      verify(() => printedProductsPresenter
          .loadPrinted(homePresenter.commandNumberMock!)).called(1);
      verify(() => cartPresenter
          .loadSaleRequest(homePresenter.commandNumberMock!)).called(1);
    });

    test('Should call ticketIsPermitted on load data', () async {
      await sut.getGroupsAndProducts(homePresenter.commandNumberMock!);

      verify(() => ticketIsPermitted.verify(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            commandNumber: homePresenter.commandNumberMock!,
          )).called(1);
    });

    test(
        'Should emit correct values on ticketIsPermitted throws commandNotAvailable',
        () async {
      ticketIsPermitted.mockError();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.getGroupsAndProducts(homePresenter.commandNumberMock!);
    });
  });

  group("Navigation", () {
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
  });

  group("selected product", () {
    test('Should update indexOfSelectedProduct correctly', () async {
      expectLater(sut.indexOfSelectedGroupStream, emitsInOrder([1, 2, 0, 5]));

      sut.updateIndexOfSelectedGroup(1);
      sut.updateIndexOfSelectedGroup(2);
      sut.updateIndexOfSelectedGroup(0);
      sut.updateIndexOfSelectedGroup(5);
    });
    test('Should unselect product when change selected group', () async {
      expectLater(sut.selectedProductStream, emits(null));

      sut.updateIndexOfSelectedGroup(0);
    });

    test('Should update indexOfSelectedProduct correctly', () async {
      expectLater(
          sut.selectedProductStream, emitsInOrder([productsViewModel, null]));

      sut.updateSelectedProduct(productsViewModel);
      sut.updateSelectedProduct(productsViewModel);
    });

    test('Should clear product quantity when click in other product', () async {
      sut.updateSelectedProduct(productsViewModel);
      productsViewModel.productQuantity = 2;
      expect(productsViewModel.productQuantity, 2);

      sut.updateSelectedProduct(null);
      sut.updateSelectedProduct(productsViewModel);
      expect(productsViewModel.productQuantity, 1);
    });
  });

  group("Product comment", () {
    test("Should emit correct values on update product comment", () {
      expectLater(sut.productCommentStream, emits(newComment));

      sut.updateProductComment(newComment);
    });

    test("Should emit correct values on update selected product", () {
      expectLater(sut.productCommentStream, emits(null));

      sut.updateSelectedProduct(productsViewModel);
    });
  });
}
