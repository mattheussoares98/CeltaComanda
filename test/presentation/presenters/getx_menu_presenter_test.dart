import 'package:clean_celta_mobile/data/models/models.dart';
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
  late int internalCodeOnErp;
  late int expansibleGroupId;
  late ProductScheduleViewModel productScheduleViewModel;
  late ExpansibleGroupScheduleViewModel expansibleGroupScheduleViewModel;
  late String productEan;
  late ProductEntity productEntity;
  late ProductsViewModel productsViewModel;
  late List<ProductEntity> products;
  late List<ProductEntity> productsEntityThatIsPromoCombox;
  late List<ProductCompositionEntity> productsCompositionsEntitys;
  late List<ParameterModel> parameters;

  late LoadExpansibleGroupsSpy loadExpansibleGroups;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late NavigateToSpy navigateTo;
  late CommandInformationsSpy ticketIsPermitted;
  late SearchProductByCodeSpy searchProductByCode;
  late BarcodeScannerSpy barcodeScanner;
  late LoadProductsSpy loadProducts;
  late GetProductCompositionSpy getProductComposition;
  late LoadSuggestionSaleSpy loadSuggestionSale;
  late ManageProductScheduleSpy manageProductSchedule;
  late ManageExpansibleGroupScheduleSpy manageExpansibleGroupSchedule;
  late UpdatedAllImagesSpy updatedAllImages;
  late ParametersDataSpy parametersData;

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
    manageProductSchedule = ManageProductScheduleSpy();
    manageExpansibleGroupSchedule = ManageExpansibleGroupScheduleSpy();
    updatedAllImages = UpdatedAllImagesSpy();
    parametersData = ParametersDataSpy();
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
      manageProductSchedule: manageProductSchedule,
      manageExpansibleGroupSchedule: manageExpansibleGroupSchedule,
      updatedAllImages: updatedAllImages,
      parametersData: parametersData,
    );
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
    expansibleGroups = EntityFactory.makeExpansibleGroupsEntity();
    homePresenter.commandEntityController = CommandEntity(
      commandNumber:
          faker.randomGenerator.integer(100).toString().padLeft(3, "0"),
      isFixedCommandNumber: true,
      pdv: EntityFactory.makePdvEntity(),
    );
    expansibleGroupsViewModel = expansibleGroups
        .map((e) => ExpansibleGroupsViewModel(
              Name: e.Name,
              ExpansibleGroupId: e.ExpansibleGroupId.toString(),
              ExpansibleGroupType: e.ExpansibleGroupType.toString(),
              OrderClassification: e.OrderClassification.toString(),
              Schedule: ExpansibleGroupScheduleModel.fromEntity(
                  EntityFactory.makeExpansibleGroupScheduleEntity(
                      e.ExpansibleGroupId)),
              subgroups: const [],
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
        .toList();

    productsCompositionsEntitys = EntityFactory.makeProductsCompositionsEntity(
      isOptionalItem: true,
    );

    suggestions = EntityFactory.makeSuggestionsSaleEntitys();
    suggestionsProductsViewModel = [
      ...products.map((e) => ProductsViewModel.fromEntity(e)),
    ];
    internalCodeOnErp = faker.randomGenerator.integer(100);
    productScheduleViewModel =
        EntityFactory.makeProductScheduleViewModel(internalCodeOnErp);
    expansibleGroupId = faker.randomGenerator.integer(100);
    expansibleGroupScheduleViewModel =
        ExpansibleGroupScheduleViewModel.fromEntity(
            EntityFactory.makeExpansibleGroupScheduleEntity(expansibleGroupId));

    parameters = [
      EntityFactory.makeParametersModel(),
      EntityFactory.makeParametersModel(),
    ];
  }

  void mockSuccess() {
    loadExpansibleGroups.mockLoadExpansibleGroups(expansibleGroups);
    localEnterpriseData.mockAdd(EnterpriseBuilder.entity!);
    searchProductByCode.mockSearchProductByCode(productEntity);
    loadProducts.mockLoadProducts(products);
    getProductComposition.mockGetFathers(productsCompositionsEntitys);
    getProductComposition.mockGetChildsOfFather(productsCompositionsEntitys);
    loadSuggestionSale.mockLoad(suggestions);
    updatedAllImages.mockGetLastDate(null);
    parametersData.mockLoad(parameters);
  }

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EnterpriseBuilder.entity);
    registerFallbackValue(EntityFactory.makeSaleRequestTempProductsViewModel());
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(EntityFactory.makeUpdateSaleRequestTempEntity());
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    registerFallbackValue(EntityFactory.makeEnterpriseData());
    registerFallbackValue(EntityFactory.makeProductScheduleEntity());
    registerFallbackValue(EntityFactory.makeExpansibleGroupScheduleEntity(0));
    registerFallbackValue(EntityFactory.makeCartProductEntity(
      maximumProductQuantity: 100,
      minimumProductQuantity: 0,
    ));
    registerFallbackValue(EntityFactory.makeSaleRequestModel(
      covenantCode: 0,
      customerCode: 0,
    ));
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
  });

  group("Get groups and products", () {
    test('Should emit correct values on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.showPreLoadImagesStream, emits(true));

      expectLater(
          sut.menuStream, emitsInOrder([[], menuListWithoutPromoCombox]));

      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
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
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
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
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
      );

      expect(future, throwsA(DomainError.unexpected));
    });
    test('Should call LoadExpansibleGroups and loadProducts', () async {
      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
      );

      verify(() => loadExpansibleGroups.load()).called(1);
      verify(() => loadProducts.load(expansibleGroups[0].ExpansibleGroupId))
          .called(1);
      verify(() => loadProducts.load(expansibleGroups[1].ExpansibleGroupId))
          .called(1);
    });
    // test('Should add fixed group of avaliation in last index', () async {
    //   await sut.getGroupsAndProducts(
    //     expansibleGroupFromProductPresenter:
    //         expansibleGroupFromProductPresenter,
    //     commandNumber: homePresenter.commandEntityController!.commandNumber!,
    //   );

    //   expect(sut.loadedMenu.last.entries.first.key.Name, R.string.avaliate);
    // });

    test('Should return correct value on success to load', () async {
      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
      );

      expect(sut.loadedMenu, menuListWithoutPromoCombox);
    });

    test('Should clear expansibleGroups', () async {
      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
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
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
      );
    });

    test('Should put "destaques" in first group list', () async {
      final avaliationGroup = ExpansibleGroupsViewModel(
        Name: R.string.avaliate,
        ExpansibleGroupId: "0",
        ExpansibleGroupType: "0",
        OrderClassification: "0",
        Schedule: ExpansibleGroupScheduleModel.fromEntity(
            EntityFactory.makeExpansibleGroupScheduleEntity(0)),
        subgroups: const [],
      );

      final id = faker.randomGenerator.integer(10);
      final detachGroup = ExpansibleGroupsViewModel(
        Name: R.string.detach.toLowerCase(),
        ExpansibleGroupId: id.toString(),
        ExpansibleGroupType: faker.randomGenerator.integer(10).toString(),
        OrderClassification: faker.randomGenerator.integer(10).toString(),
        Schedule: ExpansibleGroupScheduleModel.fromEntity(
            EntityFactory.makeExpansibleGroupScheduleEntity(id)),
        subgroups: const [],
      );
      final groups = [
        avaliationGroup,
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
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
      );
    });
    test('Should put "promotion" in second group list', () async {
      final avaliationGroup = ExpansibleGroupsViewModel(
        Name: R.string.avaliate,
        ExpansibleGroupId: "0",
        ExpansibleGroupType: "0",
        OrderClassification: "0",
        Schedule: ExpansibleGroupScheduleModel.fromEntity(
            EntityFactory.makeExpansibleGroupScheduleEntity(0)),
        subgroups: const [],
      );
      final promotionGroup = ExpansibleGroupsViewModel(
        Name: R.string.promotionWithoutPoints,
        ExpansibleGroupId: "0",
        ExpansibleGroupType: "0",
        OrderClassification: "0",
        Schedule: ExpansibleGroupScheduleModel.fromEntity(
            EntityFactory.makeExpansibleGroupScheduleEntity(0)),
        subgroups: const [],
      );

      final id = faker.randomGenerator.integer(10);
      final detachGroup = ExpansibleGroupsViewModel(
        Name: R.string.detach.toLowerCase(),
        ExpansibleGroupId: id.toString(),
        ExpansibleGroupType: faker.randomGenerator.integer(10).toString(),
        OrderClassification: faker.randomGenerator.integer(10).toString(),
        Schedule: ExpansibleGroupScheduleModel.fromEntity(
            EntityFactory.makeExpansibleGroupScheduleEntity(id)),
        subgroups: const [],
      );
      final groups = [
        promotionGroup,
        avaliationGroup,
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
              {promotionGroup: []},
              {avaliationGroup: []},
            ]
          ]));

      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
      );
    });

    test("Should call expansibleGroupFromProductPresenter.loadComments",
        () async {
      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
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
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
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
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
      );

      expect(
        sut.loadedMenu[0].entries.first.value.first.suggestions,
        [mockedSuggestion],
      );
    });

    test("Should update ExpansibleGroup correctly when has | separator",
        () async {
      final firstId = faker.randomGenerator.integer(100);
      final secondId = faker.randomGenerator.integer(100);
      loadExpansibleGroups.mockLoadExpansibleGroups(
        [
          ExpansibleGroupEntity(
            Name: "teste|primeiro",
            ExpansibleGroupId: firstId,
            ExpansibleGroupType: faker.randomGenerator.integer(100),
            OrderClassification: faker.randomGenerator.integer(100),
            Schedule: EntityFactory.makeExpansibleGroupScheduleEntity(firstId),
          ),
          ExpansibleGroupEntity(
            Name: "teste|segundo",
            ExpansibleGroupId: secondId,
            ExpansibleGroupType: faker.randomGenerator.integer(100),
            OrderClassification: faker.randomGenerator.integer(100),
            Schedule: EntityFactory.makeExpansibleGroupScheduleEntity(secondId),
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

    test("Should return correct _loadedMenu.length when groups has subgroups",
        () async {
      final firstId = faker.randomGenerator.integer(100);
      final secondId = faker.randomGenerator.integer(100);

      loadExpansibleGroups.mockLoadExpansibleGroups(
        [
          ExpansibleGroupEntity(
            Name: "teste|primeiro",
            ExpansibleGroupId: firstId,
            ExpansibleGroupType: faker.randomGenerator.integer(100),
            OrderClassification: faker.randomGenerator.integer(100),
            Schedule: EntityFactory.makeExpansibleGroupScheduleEntity(firstId),
          ),
          ExpansibleGroupEntity(
            Name: "teste|segundo",
            ExpansibleGroupId: secondId,
            ExpansibleGroupType: faker.randomGenerator.integer(100),
            OrderClassification: faker.randomGenerator.integer(100),
            Schedule: EntityFactory.makeExpansibleGroupScheduleEntity(secondId),
          ),
        ],
      );

      await sut.getGroupsAndProducts(
        commandNumber: faker.randomGenerator.integer(999).toString(),
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.loadedMenu.length, 1);
    });

    test("Should update product.subgroupName correctly", () async {
      final id = faker.randomGenerator.integer(100);
      loadExpansibleGroups.mockLoadExpansibleGroups(
        [
          ExpansibleGroupEntity(
            Name: "teste|primeiro",
            ExpansibleGroupId: id,
            ExpansibleGroupType: faker.randomGenerator.integer(100),
            OrderClassification: faker.randomGenerator.integer(100),
            Schedule: EntityFactory.makeExpansibleGroupScheduleEntity(id),
          ),
        ],
      );

      await sut.getGroupsAndProducts(
        commandNumber: faker.randomGenerator.integer(999).toString(),
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.loadedMenu.first.values.first.first.subgroupName, "primeiro");
    });

    test(
        "Should show pre load images if dont return last updated all images data",
        () async {
      expectLater(sut.showPreLoadImagesStream, emits(true));

      updatedAllImages.mockGetLastDate(null);

      await sut.getGroupsAndProducts(
        commandNumber: faker.randomGenerator.integer(999).toString(),
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test("Should not show pre load images if last date is equal today",
        () async {
      expectLater(sut.showPreLoadImagesStream, emits(false));

      updatedAllImages.mockGetLastDate(DateTime.now());

      await sut.getGroupsAndProducts(
        commandNumber: faker.randomGenerator.integer(999).toString(),
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
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
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
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
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
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
            url: EnterpriseBuilder.entity!.url!,
            enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
            value: "12345-6",
          )).called(1);

      await sut.searchProduct("12345");

      verify(() => searchProductByCode.search(
            url: EnterpriseBuilder.entity!.url!,
            enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
            value: "01234-5",
          )).called(1);

      await sut.searchProduct("1");

      verify(() => searchProductByCode.search(
            url: EnterpriseBuilder.entity!.url!,
            enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
            value: "00000-1",
          )).called(1);

      await sut.searchProduct("1234567890123");

      verify(() => searchProductByCode.search(
            url: EnterpriseBuilder.entity!.url!,
            enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
            value: "1234567890123",
          )).called(1);

      await sut.searchProduct("1234567");

      verify(() => searchProductByCode.search(
            url: EnterpriseBuilder.entity!.url!,
            enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
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
      expectLater(
          sut.searchedProductStream,
          emitsInOrder(
            [null, productsViewModel],
          ));

      await sut.searchProduct(productEan);
    });

    test("Should return null if product not found", () async {
      searchProductByCode.mockSearchProductByCode(null);

      expectLater(sut.searchedProductStream, emits(null));

      await sut.searchProduct(productEan);
    });

    test("Should clear searchedProduct when search command data", () async {
      expectLater(
          sut.searchedProductStream,
          emitsInOrder(
            [null, productsViewModel, null],
          ));

      await sut.searchProduct(productEan);

      await sut.getGroupsAndProducts(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
      );
    });

    test("Should clear searchedProduct not found product", () async {
      expectLater(
          sut.searchedProductStream,
          emitsInOrder(
            [null, productsViewModel, null],
          ));

      await sut.searchProduct(productEan);
      searchProductByCode.mockSearchProductByCode(null);
      await sut.searchProduct(productEan);
    });
  });

  group("BarcodeScanner", () {
    test("Should search product if barcode is not empty", () async {
      barcodeScanner.mockRead("1234567890123");
      await sut.readBarcodeAndSearchProduct();

      verify(() => barcodeScanner.read()).called(1);
      verify(() => searchProductByCode.search(
            value: "1234567890123",
            url: EnterpriseBuilder.entity!.url!,
            enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
          )).called(1);
    });

    test("Should not search product if barcode is empty", () async {
      barcodeScanner.mockRead("");
      await sut.readBarcodeAndSearchProduct();

      verify(() => barcodeScanner.read()).called(1);
      verifyNever(() => searchProductByCode.search(
            value: "",
            url: EnterpriseBuilder.entity!.url!,
            enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
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
      barcodeScanner.mockRead("1234567890123");

      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.readBarcodeAndSearchProduct();
    });

    test("Should return correct value", () async {
      barcodeScanner.mockRead("1234567890123");

      final value = await sut.readBarcodeAndSearchProduct();

      expect(value, "1234567890123");
    });

    test("Should return correct value on error", () async {
      barcodeScanner.mockError(DomainError.unexpected);

      final value = await sut.readBarcodeAndSearchProduct();

      expect(value, "");
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

      final loadedProducts = sut.loadedMenu.first.values.first;
      loadedProducts[0].suggestions = mockedSuggestions;
      suggestionsProductsViewModel[0].suggestions = mockedSuggestions;

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
      suggestionsProductsViewModel[0].suggestions = mockedSuggestions;

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
      final id = faker.randomGenerator.integer(999);
      loadExpansibleGroups.mockLoadExpansibleGroups(
        [
          ExpansibleGroupEntity(
            Name: "Name",
            ExpansibleGroupId: id,
            ExpansibleGroupType: faker.randomGenerator.integer(999),
            OrderClassification: faker.randomGenerator.integer(999),
            Schedule: EntityFactory.makeExpansibleGroupScheduleEntity(id),
          ),
        ],
      );

      await sut.getGroupsAndProducts(
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      final value = sut.getAlreadyContainsExpansibleGroupName("Name");
      expect(value, true);
    });
    test("Should return true if already contains separating by pipes",
        () async {
      final id = faker.randomGenerator.integer(999);
      loadExpansibleGroups.mockLoadExpansibleGroups(
        [
          ExpansibleGroupEntity(
            Name: "Name|any",
            ExpansibleGroupId: faker.randomGenerator.integer(999),
            ExpansibleGroupType: faker.randomGenerator.integer(999),
            OrderClassification: faker.randomGenerator.integer(999),
            Schedule: EntityFactory.makeExpansibleGroupScheduleEntity(id),
          ),
        ],
      );

      await sut.getGroupsAndProducts(
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      final value = sut.getAlreadyContainsExpansibleGroupName("Name");
      expect(value, true);
    });
    test("Should return false if dont have", () async {
      final id = faker.randomGenerator.integer(999);
      loadExpansibleGroups.mockLoadExpansibleGroups(
        [
          ExpansibleGroupEntity(
            Name: "Name",
            ExpansibleGroupId: faker.randomGenerator.integer(999),
            ExpansibleGroupType: faker.randomGenerator.integer(999),
            OrderClassification: faker.randomGenerator.integer(999),
            Schedule: EntityFactory.makeExpansibleGroupScheduleEntity(id),
          ),
        ],
      );

      await sut.getGroupsAndProducts(
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      final value = sut.getAlreadyContainsExpansibleGroupName("any");
      expect(value, false);
    });
  });

  group("Get subgroup", () {
    test("Should return subgroup if expansible group entity has a pipe",
        () async {
      final id = faker.randomGenerator.integer(999);
      final entity = ExpansibleGroupEntity(
        Name: "Name|subgroup",
        ExpansibleGroupId: faker.randomGenerator.integer(100),
        ExpansibleGroupType: faker.randomGenerator.integer(100),
        OrderClassification: faker.randomGenerator.integer(100),
        Schedule: EntityFactory.makeExpansibleGroupScheduleEntity(id),
      );

      expect(sut.getSubgroup(entity), "subgroup");
    });
    test("Should return null if expansible group name dont have pipe",
        () async {
      final id = faker.randomGenerator.integer(999);
      final entity = ExpansibleGroupEntity(
        Name: "Name subgroup",
        ExpansibleGroupId: faker.randomGenerator.integer(100),
        ExpansibleGroupType: faker.randomGenerator.integer(100),
        OrderClassification: faker.randomGenerator.integer(100),
        Schedule: EntityFactory.makeExpansibleGroupScheduleEntity(id),
      );

      expect(sut.getSubgroup(entity), null);
    });
  });

  group("Insert update product schedule", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.insertUpdateProductSchedule(
        internalCodeOnErp: internalCodeOnErp,
        expansibleGroupId: expansibleGroupId,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      manageProductSchedule.mockInsertError();

      await sut.insertUpdateProductSchedule(
        internalCodeOnErp: internalCodeOnErp,
        expansibleGroupId: expansibleGroupId,
      );
    });
    test("Should call manageProductSchedule.insertUpdate with correct values",
        () async {
      sut.updateProductScheduleStream(
        internalCodeOnErp: internalCodeOnErp,
        friday: productScheduleViewModel.AllowFriday,
        monday: productScheduleViewModel.AllowMonday,
        saturday: productScheduleViewModel.AllowSaturday,
        sunday: productScheduleViewModel.AllowSunday,
        thursday: productScheduleViewModel.AllowThursday,
        tuesday: productScheduleViewModel.AllowTuesday,
        wednesday: productScheduleViewModel.AllowWednesday,
      );

      await sut.insertUpdateProductSchedule(
        internalCodeOnErp: internalCodeOnErp,
        expansibleGroupId: expansibleGroupId,
      );

      verify(() => manageProductSchedule
          .insertUpdate(productScheduleViewModel.toEntity())).called(1);
    });
    test("Should call manageProductSchedule.delete if all days are true",
        () async {
      sut.updateProductScheduleStream(
        internalCodeOnErp: internalCodeOnErp,
        friday: true,
        monday: true,
        saturday: true,
        sunday: true,
        thursday: true,
        tuesday: true,
        wednesday: true,
      );

      await sut.insertUpdateProductSchedule(
        internalCodeOnErp: internalCodeOnErp,
        expansibleGroupId: expansibleGroupId,
      );

      verifyNever(() => manageProductSchedule
          .insertUpdate(productScheduleViewModel.toEntity()));

      verify(() => manageProductSchedule.delete(internalCodeOnErp)).called(1);
    });

    test("Should return true on success", () async {
      await sut.getGroupsAndProducts(
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      sut.updateProductScheduleStream(internalCodeOnErp: internalCodeOnErp);

      final updated = await sut.insertUpdateProductSchedule(
          internalCodeOnErp: products.first.InternalCodeOnERP!,
          expansibleGroupId: expansibleGroups.first.ExpansibleGroupId);

      expect(updated, true);
    });
    test("Should return false on error", () async {
      manageProductSchedule.mockInsertError();

      final updated = await sut.insertUpdateProductSchedule(
        internalCodeOnErp: internalCodeOnErp,
        expansibleGroupId: expansibleGroupId,
      );

      expect(updated, false);
    });
  });

  group("Update selected product schedule", () {
    test("Should emit correct values", () {
      expectLater(sut.productScheduleStream,
          emitsInOrder([null, productScheduleViewModel]));

      sut.updateProductScheduleStream(
        internalCodeOnErp: internalCodeOnErp,
        friday: productScheduleViewModel.AllowFriday,
        monday: productScheduleViewModel.AllowMonday,
        saturday: productScheduleViewModel.AllowSaturday,
        sunday: productScheduleViewModel.AllowSunday,
        thursday: productScheduleViewModel.AllowThursday,
        tuesday: productScheduleViewModel.AllowTuesday,
        wednesday: productScheduleViewModel.AllowWednesday,
      );
    });
  });

  group("Insert update expandible group schedule", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.insertUpdateExpansibleGroupSchedule(expansibleGroupId);
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      manageExpansibleGroupSchedule.mockInsertError();

      await sut.insertUpdateExpansibleGroupSchedule(expansibleGroupId);
    });
    test(
        "Should call manageExpansibleGroupSchedule.insertUpdate with correct values",
        () async {
      sut.updateExpansibleGroupScheduleStream(
        expansibleGroupId: expansibleGroupId,
        friday: expansibleGroupScheduleViewModel.AllowFriday,
        monday: expansibleGroupScheduleViewModel.AllowMonday,
        saturday: expansibleGroupScheduleViewModel.AllowSaturday,
        sunday: expansibleGroupScheduleViewModel.AllowSunday,
        thursday: expansibleGroupScheduleViewModel.AllowThursday,
        tuesday: expansibleGroupScheduleViewModel.AllowTuesday,
        wednesday: expansibleGroupScheduleViewModel.AllowWednesday,
      );

      await sut.insertUpdateExpansibleGroupSchedule(expansibleGroupId);

      verify(() => manageExpansibleGroupSchedule
          .insertUpdate(expansibleGroupScheduleViewModel.toEntity())).called(1);
    });
    test(
        "Should call manageExpansibleGroupSchedule.delete if all days are true",
        () async {
      sut.updateExpansibleGroupScheduleStream(
        expansibleGroupId: expansibleGroupId,
        friday: true,
        monday: true,
        saturday: true,
        sunday: true,
        thursday: true,
        tuesday: true,
        wednesday: true,
      );

      await sut.insertUpdateExpansibleGroupSchedule(expansibleGroupId);

      verifyNever(() => manageExpansibleGroupSchedule
          .insertUpdate(expansibleGroupScheduleViewModel.toEntity()));

      verify(() => manageExpansibleGroupSchedule.delete(expansibleGroupId))
          .called(1);
    });

    test("Should return true on success", () async {
      await sut.getGroupsAndProducts(
        commandNumber: homePresenter.commandEntityController!.commandNumber!,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      sut.updateExpansibleGroupScheduleStream(expansibleGroupId: expansibleGroupId);

      final updated = await sut.insertUpdateExpansibleGroupSchedule(
          expansibleGroups.first.ExpansibleGroupId);

      expect(updated, true);
    });
    test("Should return false on error", () async {
      manageExpansibleGroupSchedule.mockInsertError();

      final updated =
          await sut.insertUpdateExpansibleGroupSchedule(expansibleGroupId);

      expect(updated, false);
    });
  });

  group("Update selected expansible group schedule", () {
    test("Should emit correct values", () {
      expectLater(sut.expansibleGroupScheduleStream,
          emitsInOrder([null, expansibleGroupScheduleViewModel]));

      sut.updateExpansibleGroupScheduleStream(
        expansibleGroupId: expansibleGroupId,
        friday: expansibleGroupScheduleViewModel.AllowFriday,
        monday: expansibleGroupScheduleViewModel.AllowMonday,
        saturday: expansibleGroupScheduleViewModel.AllowSaturday,
        sunday: expansibleGroupScheduleViewModel.AllowSunday,
        thursday: expansibleGroupScheduleViewModel.AllowThursday,
        tuesday: expansibleGroupScheduleViewModel.AllowTuesday,
        wednesday: expansibleGroupScheduleViewModel.AllowWednesday,
      );
    });
  });

  group("Cancel pre load image", () {
    test("Should emit correct value", () {
      expectLater(sut.showPreLoadImagesStream, emits(false));

      sut.cancelPreloadImage();
    });
  });

  group("Add or remove search products", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.addOrRemoveSearchProducts();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      parametersData.mockLoadError();

      await sut.addOrRemoveSearchProducts();
    });
    test("Should call load correctly", () async {
      await sut.addOrRemoveSearchProducts();

      verify(() => parametersData.load()).called(1);
    });
    test("Should add group in correct index if contains detach group",
        () async {
      loadExpansibleGroups.mockLoadExpansibleGroups([
        ExpansibleGroupEntity(
          Name: R.string.detach.toUpperCase(),
          ExpansibleGroupId: faker.randomGenerator.integer(100),
          ExpansibleGroupType: faker.randomGenerator.integer(100),
          OrderClassification: faker.randomGenerator.integer(100),
          Schedule: null,
        ),
      ]);

      await sut.getGroupsAndProducts(
        commandNumber: homePresenter.commandEntity!.commandNumber!,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      parametersData.mockLoad([
        EntityFactory.makeParametersModel(
            enabled: true, key: ParameterKey.enableSearchProducts),
      ]);
      await sut.addOrRemoveSearchProducts();

      expect(sut.loadedMenu[0].keys.first.Name, R.string.detach.toUpperCase());
      expect(sut.loadedMenu[1].keys.first.Name,
          R.string.searchProduct.toUpperCase());
    });
    test("Should add group in correct index if dont contains detach group",
        () async {
      await sut.getGroupsAndProducts(
        commandNumber: homePresenter.commandEntity!.commandNumber!,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      parametersData.mockLoad([
        EntityFactory.makeParametersModel(
            enabled: true, key: ParameterKey.enableSearchProducts),
      ]);
      await sut.addOrRemoveSearchProducts();

      expect(sut.loadedMenu[0].keys.first.Name,
          R.string.searchProduct.toUpperCase());
    });
    test("Should remove search product expansible group if already exists",
        () async {
      final mockedExpansibleGroup = ExpansibleGroupEntity(
        Name: faker.randomGenerator.string(10),
        ExpansibleGroupId: faker.randomGenerator.integer(100),
        ExpansibleGroupType: faker.randomGenerator.integer(100),
        OrderClassification: faker.randomGenerator.integer(100),
        Schedule: null,
      );
      loadExpansibleGroups.mockLoadExpansibleGroups([mockedExpansibleGroup]);

      await sut.getGroupsAndProducts(
        commandNumber: homePresenter.commandEntity!.commandNumber!,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      parametersData
          .mockLoad([EntityFactory.makeParametersModel(enabled: true)]);
      await sut.addOrRemoveSearchProducts();
      expect(sut.loadedMenu[0].keys.first.Name,
          R.string.searchProduct.toUpperCase());

      parametersData
          .mockLoad([EntityFactory.makeParametersModel(enabled: false)]);
      await sut.addOrRemoveSearchProducts();
      expect(sut.loadedMenu[0].keys.first.Name,
          sut.getExpansibleGroupNameWithoutPipes(mockedExpansibleGroup.Name));
    });
  });
}
