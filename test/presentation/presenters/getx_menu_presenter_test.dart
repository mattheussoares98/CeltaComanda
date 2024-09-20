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
  late ExpansibleGroupFromProductPresenterSpy
      expansibleGroupFromProductPresenter;

  late List<ExpansibleGroupEntity> expansibleGroups;
  late List<ExpansibleGroupsViewModel> expansibleGroupsViewModel;
  late List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>
      menuListWithoutPromoCombox;
  late List<SuggestionSaleEntity> suggestions;
  late List<ProductsViewModel> suggestionsProductsViewModel;

  late LoadExpansibleGroupsSpy loadExpansibleGroups;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late NavigateToSpy navigateTo;
  late CommandInformationsSpy ticketIsPermitted;
  late SearchProductByCodeSpy searchProductByCode;
  late BarcodeScannerSpy barcodeScanner;
  late LoadProductsSpy loadProducts;
  late GetProductCompositionSpy getProductComposition;
  late LoadSuggestionSaleSpy loadSuggestionSale;

  late String productEan;
  late ProductEntity productEntity;
  late ProductsViewModel productsViewModel;
  late List<ProductEntity> products;
  late List<ProductEntity> productsEntityThatIsPromoCombox;
  late List<ProductCompositionEntity> productsCompositionsEntitys;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUseCases() {
    loadExpansibleGroups = LoadExpansibleGroupsSpy();
    ticketIsPermitted = CommandInformationsSpy();
    localEnterpriseData = LocalEnterpriseDataSpy();
    navigateTo = NavigateToSpy();
    searchProductByCode = SearchProductByCodeSpy();
    barcodeScanner = BarcodeScannerSpy();
    loadProducts = LoadProductsSpy();
    getProductComposition = GetProductCompositionSpy();
    loadSuggestionSale = LoadSuggestionSaleSpy();
  }

  void initPresenters() {
    homePresenter = HomePresenterSpy();
    cartPresenter = CartPresenterSpy();
    expansibleGroupFromProductPresenter =
        ExpansibleGroupFromProductPresenterSpy();

    sut = GetxMenuPresenter(
      navigateTo: navigateTo,
      loadExpansibleGroups: loadExpansibleGroups,
      commandInformations: ticketIsPermitted,
      searchProductByCode: searchProductByCode,
      barcodeScanner: barcodeScanner,
      loadProducts: loadProducts,
      getProductComposition: getProductComposition,
      loadSuggestionSale: loadSuggestionSale,
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
              subgroups: null,
            ))
        .toList();
    productEan = faker.randomGenerator.integer(13).toString();
    productEntity = EntityFactory.makeProductsEntitys(isPromoCombox: false)[0];
    productsEntityThatIsPromoCombox =
        EntityFactory.makeProductsEntitys(isPromoCombox: true);
    productsViewModel = ProductsViewModel.fromEntity(productEntity);

    cartPresenter.saleRequestTempMock =
        EntityFactory.makeSaleRequestTempViewModel(
            EntityFactory.makeProductModel());

    products = EntityFactory.makeProductsEntitys(isPromoCombox: false);

    menuListWithoutPromoCombox = expansibleGroupsViewModel
        .map((expansibleGroup) => {
              expansibleGroup: products.map((product) {
                return ProductsViewModel.fromEntity(product);
              }).toList(),
            })
        .toList()
      ..add({
        ExpansibleGroupsViewModel(
          Name: R.string.avaliate,
          ExpansibleGroupId: "0",
          ExpansibleGroupType: "0",
          OrderClassification: "0",
          subgroups: null,
        ): []
      });

    productsCompositionsEntitys = EntityFactory.makeProductsCompositionsEntity(
      isOptionalItem: true,
    );

    suggestions = EntityFactory.makeSuggestionsSaleEntitys();
    suggestionsProductsViewModel = [
      ...products.map((e) => ProductsViewModel.fromEntity(e)),
    ];
  }

  void mockSuccess() {
    loadExpansibleGroups.mockLoadExpansibleGroups(expansibleGroups);
    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    searchProductByCode.mockSearchProductByCode(productEntity);
    loadProducts.mockLoadProducts(products);
    getProductComposition.mockGetFathers(productsCompositionsEntitys);
    getProductComposition.mockGetChildsOfFather(productsCompositionsEntitys);
    loadSuggestionSale.mockLoad(suggestions);
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
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(EntityFactory.makeUpdateSaleRequestTempEntity());
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    registerFallbackValue(EntityFactory.makeEnterpriseData());
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
  });

  group("Get groups and products", () {
    test('Should emit correct values on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.showPreLoadImagesStream, emitsInOrder([true, false]));

      expectLater(
          sut.menuStream, emitsInOrder([[], menuListWithoutPromoCombox]));

      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );
    });
    test(
        'Should throw CommandNotAvailable on getGroupsAndProducts throws commandNotAvailable',
        () async {
      loadExpansibleGroups
          .mockLoadExpansibleGroupsError(DomainError.commandNotAvailable);

      final future = sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );

      expect(future, throwsA(DomainError.commandNotAvailable));
    });
    test(
        'Should throw CommandNotAvailable on getGroupsAndProducts throws commandNotAvailable unexpected',
        () async {
      loadExpansibleGroups
          .mockLoadExpansibleGroupsError(DomainError.unexpected);

      final future = sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );

      expect(future, throwsA(DomainError.unexpected));
    });
    test('Should call LoadExpansibleGroups and loadProducts', () async {
      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );

      verify(() => loadExpansibleGroups.load()).called(1);
      verify(() => loadProducts.load(expansibleGroups[0].ExpansibleGroupId))
          .called(1);
      verify(() => loadProducts.load(expansibleGroups[1].ExpansibleGroupId))
          .called(1);
    });
    test('Should add fixed group of avaliation in last index', () async {
      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );

      expect(sut.loadedMenu.last.entries.first.key.Name, R.string.avaliate);
    });

    test('Should return correct value on success to load', () async {
      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );

      expect(sut.loadedMenu, menuListWithoutPromoCombox);
    });

    test('Should clear expansibleGroups', () async {
      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );
      expect(sut.loadedMenu, menuListWithoutPromoCombox);

      sut.clear();
      expect(sut.loadedMenu, []);
    });

    test('Should update index of selectedGroup when search groups again',
        () async {
      expectLater(sut.indexOfSelectedGroupStream, emits(0));

      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );
    });

    test('Should put "destaques" in first group list', () async {
      final avaliationGroup = ExpansibleGroupsViewModel(
        Name: R.string.avaliate,
        ExpansibleGroupId: "0",
        ExpansibleGroupType: "0",
        OrderClassification: "0",
        subgroups: null,
      );
      final detachGroup = ExpansibleGroupsViewModel(
        Name: R.string.detach.toLowerCase(),
        ExpansibleGroupId: faker.randomGenerator.integer(10).toString(),
        ExpansibleGroupType: faker.randomGenerator.integer(10).toString(),
        OrderClassification: faker.randomGenerator.integer(10).toString(),
        subgroups: null,
      );
      final groups = [
        detachGroup,
      ];

      loadExpansibleGroups.mockLoadExpansibleGroups(
        groups.map((element) => element.toEntity()).toList(),
      );
      loadProducts.mockLoadProducts([]);

      expectLater(
          sut.menuStream,
          emitsInOrder([
            [],
            [
              {detachGroup: []},
              {avaliationGroup: []},
            ]
          ]));

      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );
    });

    test("Should call expansibleGroupFromProductPresenter.loadComments",
        () async {
      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );

      verify(() => expansibleGroupFromProductPresenter
          .loadCommentsAndObligatoryOptions(sut.loadedMenu
              .expand((map) => map
                  .values) // Expande todas as listas de produtos em um Iterable
              .expand((lista) =>
                  lista) // Expande cada lista individual de produtos em um Iterable
              .toList())).called(1);
    });

    test("Should call load suggestion sale", () async {
      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );

      verify(() => loadSuggestionSale.load()).called(1);
    });

    test("Should update suggestions correctly", () async {
      final mockedSuggestion = SuggestionSaleEntity(
        ProductPackingCode: products[0].InternalCodeOnERP!,
        ProductPackingCodeSuggestionForSale: faker.randomGenerator.integer(100),
      );
      loadSuggestionSale.mockLoad([mockedSuggestion]);

      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );

      expect(
        sut.loadedMenu[0].entries.first.value.first.suggestions,
        [mockedSuggestion],
      );
    });

    test("Should update ExpansibleGroup correctly when has | separator",
        () async {
      loadExpansibleGroups.mockLoadExpansibleGroups(
        [
          ExpansibleGroupEntity(
            Name: "teste|primeiro",
            ExpansibleGroupId: faker.randomGenerator.integer(100),
            ExpansibleGroupType: faker.randomGenerator.integer(100),
            OrderClassification: faker.randomGenerator.integer(100),
          ),
          ExpansibleGroupEntity(
            Name: "teste|segundo",
            ExpansibleGroupId: faker.randomGenerator.integer(100),
            ExpansibleGroupType: faker.randomGenerator.integer(100),
            OrderClassification: faker.randomGenerator.integer(100),
          ),
        ],
      );

      await sut.getGroupsAndProducts(
        commandNumber: faker.randomGenerator.integer(999).toString(),
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.loadedMenu[0].keys.first.subgroups, ["primeiro", "segundo"]);
    });
  });

  group("Get expansible groups on get groups and products", () {
    test(
        "Should call getProductComposition.getFathers when productIsPromoCombox",
        () async {
      loadProducts.mockLoadProducts(productsEntityThatIsPromoCombox);
      loadExpansibleGroups.mockLoadExpansibleGroups([expansibleGroups[0]]);

      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );

      verify(() => getProductComposition.getFathers(
          internalCodeOnErp: productsEntityThatIsPromoCombox[0]
              .InternalCodeOnERP!
              .toInt())).called(1);
      verify(() => getProductComposition.getFathers(
          internalCodeOnErp: productsEntityThatIsPromoCombox[1]
              .InternalCodeOnERP!
              .toInt())).called(1);
    });
    test(
        "Should call getProductComposition.getChildsOfFather when productIsPromoCombox",
        () async {
      loadProducts.mockLoadProducts(productsEntityThatIsPromoCombox);
      loadExpansibleGroups.mockLoadExpansibleGroups([expansibleGroups[0]]);

      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );

      verify(() => getProductComposition.getChildsOfFather(
          fathers: productsCompositionsEntitys,
          internalCodeOnErp: productsEntityThatIsPromoCombox[0]
              .InternalCodeOnERP!
              .toInt())).called(1);
      verify(() => getProductComposition.getChildsOfFather(
          fathers: productsCompositionsEntitys,
          internalCodeOnErp: productsEntityThatIsPromoCombox[1]
              .InternalCodeOnERP!
              .toInt())).called(1);
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

      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandNumberMock!,
      );
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

    test("Should emit correct events if barcodeScanner return empty value",
        () async {
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

  group("Navigation", () {
    test('Should go to InsertProductsPage', () async {
      await sut.searchProduct(productEan);

      sut.goToInsertProductPage(ProductsViewModel.fromEntity(productEntity));

      verify(
        () => navigateTo.navigate(
          pageRoute: PageRoutes.insertProducts,
          arguments: ProductsViewModel.fromEntity(productEntity),
        ),
      ).called(1);
    });
    test('Should update index of atual suggestion when navigate', () async {
      final mockedSuggestions = [
        SuggestionSaleEntity(
          ProductPackingCode: products[0].InternalCodeOnERP!,
          ProductPackingCodeSuggestionForSale:
              suggestionsProductsViewModel[0].InternalCodeOnERP!.toInt(),
        ),
        SuggestionSaleEntity(
          ProductPackingCode: products[1].InternalCodeOnERP!,
          ProductPackingCodeSuggestionForSale:
              suggestionsProductsViewModel[1].InternalCodeOnERP!.toInt(),
        ),
      ];

      await sut.getGroupsAndProducts(
        commandNumber: "001",
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      final loadedProducts = sut.loadedMenu.first.entries.first.value;
      loadedProducts[0].suggestions = mockedSuggestions;

      sut.updateSuggestionsProducts(loadedProducts[0]);

      sut.goToInsertProductPage(ProductsViewModel.fromEntity(productEntity));

      verify(
        () => navigateTo.navigate(
          pageRoute: PageRoutes.insertProducts,
          arguments: ProductsViewModel.fromEntity(productEntity),
        ),
      ).called(1);

      expect(sut.indexOfAtualSuggestion, -1);
    });
  });

  group("Selected group", () {
    test('Should update indexOfSelectedProduct correctly', () async {
      expectLater(sut.indexOfSelectedGroupStream, emitsInOrder([1, 2, 0, 5]));

      sut.updateIndexOfSelectedGroup(1);
      sut.updateIndexOfSelectedGroup(2);
      sut.updateIndexOfSelectedGroup(0);
      sut.updateIndexOfSelectedGroup(5);
    });
    test('Should emit correct value to scroll groups when click in any group',
        () async {
      expectLater(sut.doScrollGroupsStream, emits(true));

      sut.updateIndexOfSelectedGroup(1);
    });
  });

  group("Update suggestion products", () {
    test("Should emit correct value", () async {
      final mockedSuggestions = [
        SuggestionSaleEntity(
          ProductPackingCode: products[0].InternalCodeOnERP!,
          ProductPackingCodeSuggestionForSale:
              suggestionsProductsViewModel[0].InternalCodeOnERP!.toInt(),
        ),
        SuggestionSaleEntity(
          ProductPackingCode: products[1].InternalCodeOnERP!,
          ProductPackingCodeSuggestionForSale:
              suggestionsProductsViewModel[1].InternalCodeOnERP!.toInt(),
        ),
      ];

      await sut.getGroupsAndProducts(
        commandNumber: "001",
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      final loadedProducts = sut.loadedMenu.first.entries.first.value;
      loadedProducts[0].suggestions = mockedSuggestions;

      sut.updateSuggestionsProducts(loadedProducts[0]);

      expect(sut.suggestionsProductsViewModel, suggestionsProductsViewModel);
      expect(sut.indexOfAtualSuggestion, -1);
    });
  });

  group("Advance index of atual suggestion", () {
    test("Should advance index correctly", () async {
      final mockedSuggestions = [
        SuggestionSaleEntity(
          ProductPackingCode: products[0].InternalCodeOnERP!,
          ProductPackingCodeSuggestionForSale:
              suggestionsProductsViewModel[0].InternalCodeOnERP!.toInt(),
        ),
        SuggestionSaleEntity(
          ProductPackingCode: products[1].InternalCodeOnERP!,
          ProductPackingCodeSuggestionForSale:
              suggestionsProductsViewModel[1].InternalCodeOnERP!.toInt(),
        ),
      ];

      await sut.getGroupsAndProducts(
        commandNumber: "001",
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      final loadedProducts = sut.loadedMenu.first.entries.first.value;
      loadedProducts[0].suggestions = mockedSuggestions;
      sut.updateSuggestionsProducts(loadedProducts[0]);
      expect(sut.suggestionsProductsViewModel, suggestionsProductsViewModel);

      expect(sut.indexOfAtualSuggestion, -1);
      sut.advanceIndexOfAtualSuggestion();
      expect(sut.indexOfAtualSuggestion, 0);

      sut.advanceIndexOfAtualSuggestion();
      expect(sut.indexOfAtualSuggestion, 1);

      sut.advanceIndexOfAtualSuggestion();
      expect(sut.indexOfAtualSuggestion, 1);
    });
    test("Should update atual suggestion product correctly", () async {
      final mockedSuggestions = [
        SuggestionSaleEntity(
          ProductPackingCode: products[0].InternalCodeOnERP!,
          ProductPackingCodeSuggestionForSale:
              suggestionsProductsViewModel[0].InternalCodeOnERP!.toInt(),
        ),
        SuggestionSaleEntity(
          ProductPackingCode: products[1].InternalCodeOnERP!,
          ProductPackingCodeSuggestionForSale:
              suggestionsProductsViewModel[1].InternalCodeOnERP!.toInt(),
        ),
      ];

      await sut.getGroupsAndProducts(
        commandNumber: "001",
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      final loadedProducts = sut.loadedMenu.first.entries.first.value;
      loadedProducts[0].suggestions = mockedSuggestions;
      sut.updateSuggestionsProducts(loadedProducts[0]);

      expectLater(
        sut.atualSuggestionProductStream,
        emitsInOrder([loadedProducts[0], loadedProducts[1]]),
      );

      sut.advanceIndexOfAtualSuggestion();
      sut.advanceIndexOfAtualSuggestion();
    });
  });

  group("Get expansible group name without pipes", () {
    test("Should return the correct name", () {
      final name1 = sut.getExpansibleGroupNameWithoutPipes("name|any1|any2");
      expect(name1, "name");

      final name2 = sut.getExpansibleGroupNameWithoutPipes("namee|any1|any2");
      expect(name2, "namee");
    });
  });

  group("Already contains expansible group in menu", () {
    test("Should return true if already contains", () async {
      loadExpansibleGroups.mockLoadExpansibleGroups(
        [
          ExpansibleGroupEntity(
            Name: "Name",
            ExpansibleGroupId: faker.randomGenerator.integer(999),
            ExpansibleGroupType: faker.randomGenerator.integer(999),
            OrderClassification: faker.randomGenerator.integer(999),
          ),
        ],
      );

      await sut.getGroupsAndProducts(
        commandNumber: homePresenter.commandNumberMock!,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      final value = sut.alreadyContainsExpansibleGroupName("Name");
      expect(value, true);
    });
    test("Should return true if already contains separating by pipes",
        () async {
      loadExpansibleGroups.mockLoadExpansibleGroups(
        [
          ExpansibleGroupEntity(
            Name: "Name|any",
            ExpansibleGroupId: faker.randomGenerator.integer(999),
            ExpansibleGroupType: faker.randomGenerator.integer(999),
            OrderClassification: faker.randomGenerator.integer(999),
          ),
        ],
      );

      await sut.getGroupsAndProducts(
        commandNumber: homePresenter.commandNumberMock!,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      final value = sut.alreadyContainsExpansibleGroupName("Name");
      expect(value, true);
    });
    test("Should return false if dont have", () async {
      loadExpansibleGroups.mockLoadExpansibleGroups(
        [
          ExpansibleGroupEntity(
            Name: "Name",
            ExpansibleGroupId: faker.randomGenerator.integer(999),
            ExpansibleGroupType: faker.randomGenerator.integer(999),
            OrderClassification: faker.randomGenerator.integer(999),
          ),
        ],
      );

      await sut.getGroupsAndProducts(
        commandNumber: homePresenter.commandNumberMock!,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      final value = sut.alreadyContainsExpansibleGroupName("any");
      expect(value, false);
    });
  });
}
