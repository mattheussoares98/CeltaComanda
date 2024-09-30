import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';

import '../../domain/mocks/mocks.dart';
import '../../ui/mocks/mocks.dart';

import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

void main() {
  late GetxHomePresenter sut;
  late PrintedProductsPresenterSpy printedProductsPresenter;
  late CartPresenterSpy cartPresenter;
  late MenuPresenterSpy menuPresenter;
  late ExpansibleGroupFromProductPresenterSpy
      expansibleGroupFromProductPresenter;

  late NavigateToSpy navigateTo;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late LocalCommandDataSpy localCommandData;
  late UserValidationsSpy userValidations;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late LoadSellersSpy loadSellers;
  late CommandInformationsSpy commandInformations;
  late PersistentSpy persistent;
  late AlreadyPaidSpy alreadyPaid;

  late CommandEntity fixedCommandEntity;
  late CommandEntity notFixedCommandEntity;
  late int newFixedCommandNumber;
  late int userPersonalizedCode;
  late SaleRequestTempEntity saleRequestTempEntity;
  late UpdateSaleRequestTempEntity updateSaleRequestTempEntity;
  late int? peoples;
  late String? sellerCode;
  late List<SellerEntity> sellerEntitys;
  late SellersViewModel selectedSeller;
  late int userCode;
  late String password;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initPresenters() {
    printedProductsPresenter = PrintedProductsPresenterSpy();
    cartPresenter = CartPresenterSpy();
    menuPresenter = MenuPresenterSpy();
    expansibleGroupFromProductPresenter =
        ExpansibleGroupFromProductPresenterSpy();
    sut = GetxHomePresenter(
      navigateTo: navigateTo,
      localEnterpriseData: localEnterpriseData,
      commandInformations: commandInformations,
      localCommandData: localCommandData,
      userValidations: userValidations,
      loadSaleRequestTemp: loadSaleRequestTemp,
      updateSaleRequestTemp: updateSaleRequestTemp,
      loadSellers: loadSellers,
      persistent: persistent,
      alreadyPaid: alreadyPaid,
    );
  }

  void initUsecases() {
    localEnterpriseData = LocalEnterpriseDataSpy();
    navigateTo = NavigateToSpy();
    localCommandData = LocalCommandDataSpy();
    userValidations = UserValidationsSpy();
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    updateSaleRequestTemp = UpdateSaleRequestTempSpy();
    loadSellers = LoadSellersSpy();
    commandInformations = CommandInformationsSpy();
    persistent = PersistentSpy();
    alreadyPaid = AlreadyPaidSpy();
  }

  void initMocks() {
    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    localCommandData.mockLoad(fixedCommandEntity);
    localCommandData.mockUpdate();
    loadSaleRequestTemp.mockLoadSaleRequestTemp(saleRequestTempEntity);
    updateSaleRequestTemp.mockUpdateSaleRequestTemp();
    loadSellers.mockLoadSellers(sellerEntitys);
  }

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    fixedCommandEntity = EntityFactory.makeCommandEntity(true);
    notFixedCommandEntity = EntityFactory.makeCommandEntity(false);
    newFixedCommandNumber = faker.randomGenerator.integer(999);
    userPersonalizedCode = faker.randomGenerator.integer(999);
    password = faker.guid.guid();
    saleRequestTempEntity = EntityFactory.makeSaleRequestTempEntity(
      newFixedCommandNumber,
    );

    peoples = faker.randomGenerator.integer(100);
    sellerCode = faker.randomGenerator.integer(100).toString();
    updateSaleRequestTempEntity = UpdateSaleRequestTempEntity(
      Peoples: peoples,
      SellerCode: sellerCode,
      Comments: saleRequestTempEntity.Comments,
      DeliveryControl: saleRequestTempEntity.DeliveryControl,
      EnterpriseId: saleRequestTempEntity.EnterpriseId,
      PersonalizedCode: saleRequestTempEntity.PersonalizedCode,
      SaleRequestTempId: saleRequestTempEntity.SaleRequestTempId,
      TotalLiquid: saleRequestTempEntity.TotalLiquid,
      Products: saleRequestTempEntity.Products.map(
          (e) => UpdateSaleRequestTempProductEntity(
                ProductInternalCodeOnErp: e.ProductInternalCodeOnErp,
                ProductPriceLookUpCode: e.ProductPriceLookUpCode,
                Quantity: e.Quantity,
                SaleRequestTempId: e.SaleRequestTempId,
                TotalLiquid: e.TotalLiquid,
                Value: e.Value,
                Comments: e.Comments,
              )).toList(),
    );

    sellerEntitys = [
      EntityFactory.makeSellerEntity(),
      EntityFactory.makeSellerEntity(),
    ];
    selectedSeller = EntityFactory.makeSellersViewModel();

    userCode = faker.randomGenerator.integer(100);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMocks();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseData());
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    registerFallbackValue(EntityFactory.makeCommandEntity(true));
    registerFallbackValue(EntityFactory.makeUpdateSaleRequestTempEntity());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(HomePresenterSpy());
  });

  group("Navigation", () {
    test('Should go to PrintedProductsPage', () async {
      sut.goToPrintedProductsPage();

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.printedProducts,
          )).called(1);
    });
    test('Should go to SplashPage', () async {
      await sut.goToSplashPage(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
      );

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.splash,
            clear: true,
          )).called(1);
    });

    test('Should make not persist app when go to splash page', () async {
      await sut.goToSplashPage(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
      );

      verify(() => persistent.makeNotPersistent()).called(1);
    });
    test('Should go to CartPage', () async {
      sut.goToCartPage();

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.cart,
            clear: false,
          )).called(1);
    });

    test('Should go to PaymentPage', () async {
      sut.goToPaymentPage();

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.payment,
          )).called(1);
    });
  });

  group("ClearEnterpriseData", () {
    test("Should call localEnterpriseData cleaning data", () async {
      await sut.clearEnterpriseData();

      verify(() => localEnterpriseData.add(
            EnterpriseEntity(
              enterpriseName:
                  EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
              enterpriseId: null,
              url: null,
              concentradorUrl: null,
              persistApp: null,
              urlCCS: null,
            ),
          )).called(1);
    });
    test('Should clear EnterpriseDataBuilder when go to SplashPage', () async {
      await sut.goToSplashPage(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
      );

      expect(EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName,
          isNotEmpty);
      expect(EnterpriseDataBuilder.enterpriseDataEntity?.url, null);
      expect(EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseId, null);
    });
  });

  group("On page change", () {
    test("Should updateCanCancelProducts to false when change page", () {
      printedProductsPresenter.updateCanCancelProducts(true);

      sut.onChangePage(
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      expect(printedProductsPresenter.canCancelProducts, false);
    });
  });

  group("updateIsFixedCommandNumber", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateIsFixedCommandNumber();
    });
    test("Should emit correct values on error", () async {
      localCommandData.mockUpdateError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateIsFixedCommandNumber();
    });
    test("Should call localCommandData.udpate", () async {
      final commandNumber = faker.randomGenerator.integer(100).toString();
      sut.updateCommandNumber(commandNumber);

      await sut.updateIsFixedCommandNumber();

      verify(() => localCommandData.update(CommandEntity(
            commandNumber: commandNumber,
            isFixedCommandNumber: sut.isFixedCommandNumber,
          ))).called(1);
    });
  });

  group("load command data", () {
    test("Should load useFixedCommandNumber on call loadUseFixedCommandNumber",
        () async {
      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => localCommandData.load()).called(1);
    });

    test("Should emit correct values on loadUseFixedCommandNumber", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test("Should update sut.isFixedCommandNumber correctly", () async {
      const fixed = CommandEntity(
        commandNumber: "commandNumber",
        isFixedCommandNumber: true,
      );
      const notFixed = CommandEntity(
        commandNumber: "commandNumber",
        isFixedCommandNumber: false,
      );

      localCommandData.mockLoad(fixed);
      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(sut.isFixedCommandNumber, true);

      localCommandData.mockLoad(notFixed);
      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(sut.isFixedCommandNumber, false);
    });
    test("Should update sut.commandNumber correctly", () async {
      final entity1 = CommandEntity(
        commandNumber: faker.randomGenerator.integer(999).toString(),
        isFixedCommandNumber: faker.randomGenerator.boolean(),
      );

      final entity2 = CommandEntity(
        commandNumber: faker.randomGenerator.integer(999).toString(),
        isFixedCommandNumber: faker.randomGenerator.boolean(),
      );

      localCommandData.mockLoad(entity1);
      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(sut.commandNumber, entity1.commandNumber.toString());

      localCommandData.mockLoad(entity2);
      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(sut.commandNumber, entity2.commandNumber.toString());
    });

    test("Should call menuPresenter.getGroupsAndProducts on loadCommandData",
        () async {
      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => menuPresenter.getGroupsAndProducts(
          commandNumber: sut.commandNumber ?? "001",
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter)).called(1);
    });
    test(
        "Should not call cartPresenter.loadSaleRequest and loadSaleRequestTemp when is not fixed command number",
        () async {
      localCommandData.mockLoad(notFixedCommandEntity);

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verifyNever(() => cartPresenter.loadSaleRequest(
            fixedCommandEntity.commandNumber.toString(),
          ));
      verifyNever(
        () => loadSaleRequestTemp.load(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: notFixedCommandEntity.commandNumber!,
        ),
      );
    });
    test(
        "Should  call cartPresenter.loadSaleRequest and printedProductsPresenter.loadPrinted when is fixed command number",
        () async {
      await sut.updateIsFixedCommandNumber();

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => cartPresenter.loadSaleRequest(
            fixedCommandEntity.commandNumber.toString(),
          )).called(1);
      verify(() => printedProductsPresenter.loadPrinted(sut)).called(1);
    });
    test(
        "Should emit correct values on cartPresenter.loadSaleRequest throw DomainError.unexpected",
        () async {
      await sut.updateIsFixedCommandNumber();
      cartPresenter.mockLoadSaleRequestTempError(DomainError.unexpected);

      expectLater(sut.mainErrorStream, emits(UIError.unexpected));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test(
        "Should emit correct values on cartPresenter.loadSaleRequest throw DomainError.commandNotAvailable",
        () async {
      await sut.updateIsFixedCommandNumber();
      cartPresenter
          .mockLoadSaleRequestTempError(DomainError.commandNotAvailable);

      expectLater(sut.mainErrorStream, emits(UIError.commandNotAvailable));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test(
        "Should emit correct values on printedProductsPresenter.loadPrinted throw DomainError.unexpected",
        () async {
      await sut.updateIsFixedCommandNumber();
      printedProductsPresenter.mockLoadPrintedError(DomainError.unexpected);

      expectLater(sut.mainErrorStream, emits(UIError.unexpected));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test(
        "Should emit correct values on printedProductsPresenter.loadPrinted throw DomainError.commandNotAvailable",
        () async {
      await sut.updateIsFixedCommandNumber();
      printedProductsPresenter
          .mockLoadPrintedError(DomainError.commandNotAvailable);

      expectLater(sut.mainErrorStream, emits(UIError.commandNotAvailable));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });

    test(
        "Should emit correct values on menuPresenter.loadGroupsAndProducts trhows CommandNotAvailable",
        () async {
      menuPresenter.mockLoadDataError(DomainError.commandNotAvailable);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test(
        "Should emit correct values on menuPresenter.loadGroupsAndProducts trhows unexpected",
        () async {
      menuPresenter.mockLoadDataError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test("Should call loadSaleRequestTemp", () async {
      await sut.updateIsFixedCommandNumber();

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(
        () => loadSaleRequestTemp.load(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: fixedCommandEntity.commandNumber.toString(),
        ),
      ).called(1);
    });
    test("Should update peoples number", () async {
      await sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.selectedPeoples, saleRequestTempEntity.Peoples);
    });

    test("Should call loadSellers", () async {
      await sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => loadSellers.load()).called(1);
    });

    test("Should update sellers correctly", () async {
      expect(sut.isFixedCommandNumber, false);
      await sut.updateIsFixedCommandNumber();

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.sellers,
          sellerEntitys.map((e) => SellersViewModel.fromEntity(e)).toList());
    });
    test("Should update selected seller correctly", () async {
      await sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(
        sut.selectedSeller,
        sellerEntitys.firstWhereOrNull(
            (e) => e.SellersId.toString() == saleRequestTempEntity.SellerCode),
      );
    });

    test("Should emit correct values on throws", () async {
      loadSellers.mockLoadSellersError();
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test("Should call isValidDateTime when is fixed command number", () async {
      await sut.updateIsFixedCommandNumber();

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(
        () => commandInformations.isValidDatetime(
          commandNumber: fixedCommandEntity.commandNumber.toString(),
        ),
      ).called(1);
    });
    test("Should call throw blockedCommand when is invalid datetime", () async {
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.blockedCommand]),
      );

      commandInformations.mockIsValidDateTime(false);
      sut.updateCommandNumber(newFixedCommandNumber.toString());
      sut.updateIsFixedCommandNumber();

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });

    test(
        "Should make persist when Enterprise.persist is true and is not generating version to rede",
        () async {
      EnterpriseDataBuilder.enterpriseDataEntity = EnterpriseEntity(
        enterpriseName:
            EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId,
        concentradorUrl:
            EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl,
        urlCCS: EnterpriseDataBuilder.enterpriseDataEntity!.urlCCS,
        persistApp: true,
      );

      sut.changeIsGeneratingVersionToRede(false);

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => persistent.makePersistent()).called(1);
    });

    test(
        "Should make NOT persist when is generating version to rede and Enterprise.persist is true",
        () async {
      EnterpriseDataBuilder.enterpriseDataEntity = EnterpriseEntity(
        enterpriseName:
            EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId,
        concentradorUrl:
            EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl,
        urlCCS: EnterpriseDataBuilder.enterpriseDataEntity!.urlCCS,
        persistApp: true,
      );

      sut.changeIsGeneratingVersionToRede(true);

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => persistent.makeNotPersistent()).called(1);
    });
    test("Should make NOT persist Enterprise.persist is false", () async {
      EnterpriseDataBuilder.enterpriseDataEntity = EnterpriseEntity(
        enterpriseName:
            EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId,
        concentradorUrl:
            EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl,
        urlCCS: EnterpriseDataBuilder.enterpriseDataEntity!.urlCCS,
        persistApp: false,
      );

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => persistent.makeNotPersistent()).called(1);
    });
  });

  group("Update command data", () {
    test("Should call printedProductsPresenter.load", () async {
      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      verify(() => printedProductsPresenter.loadPrinted(sut)).called(1);
    });
    test("Should emit correct values when update command number", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );
    });
    test("Should call is valid datetime with correct values", () async {
      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      verify(
        () => commandInformations.isValidDatetime(
          commandNumber: newFixedCommandNumber.toString().padLeft(3, "0"),
        ),
      ).called(1);
    });
    test("Should validate user and password to change command number",
        () async {
      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      verify(
        () => userValidations.isValidPassword(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          personalizedCode: userPersonalizedCode,
          password: password,
        ),
      ).called(1);
    });
    test("Should update local command data", () async {
      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      verify(
        () => localCommandData.update(
          CommandEntity(
            commandNumber: newFixedCommandNumber.toString().padLeft(3, '0'),
            isFixedCommandNumber: true,
          ),
        ),
      ).called(1);
    });
    test("Should emit correct values on validate time throws", () async {
      commandInformations.mockErrorIsValidDateTime();

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.blockedCommand]),
      );
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );
    });
    test("Should never call userValidations if is invalid datetime", () async {
      commandInformations.mockIsValidDateTime(false);

      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      verifyNever(
        () => userValidations.isValidPassword(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          personalizedCode: userPersonalizedCode,
          password: password,
        ),
      );
    });
    test(
        "Should emit correct values on user validations throws invalidCredentialsOrAccessDenied",
        () async {
      userValidations.mockIsValidPasswordError(
        DomainError.invalidCredentialsOrAccessDenied,
      );

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentialsOrAccessDenied]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );
    });
    test(
        "Should emit invalidCredentialsOrAccessDenied when userValidations return false",
        () async {
      userValidations.mockIsValidPassword(false);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentialsOrAccessDenied]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );
    });
    test("Should emit correct values on user validations throws unexpected",
        () async {
      userValidations.mockIsValidPasswordError(
        DomainError.unexpected,
      );

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );
    });
    test("Should update command number", () async {
      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      expect(
          sut.commandNumber, newFixedCommandNumber.toString().padLeft(3, '0'));
    });
    test("Should return false if update fixed command number throws", () async {
      commandInformations.mockErrorIsValidDateTime();

      final value = await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      expect(value, false);
    });
    test("Should return true if update fixed command number success", () async {
      final value = await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      expect(value, true);
    });
    test("Should call loadSaleRequestTemp", () async {
      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      verify(
        () => loadSaleRequestTemp.load(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: newFixedCommandNumber.toString(),
        ),
      ).called(1);
    });
    test("Should call updateSaleRequestTemp", () async {
      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      verify(
        () => updateSaleRequestTemp.update(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          entity: updateSaleRequestTempEntity,
        ),
      ).called(1);
    });
    test("Should update peoples number", () async {
      expect(sut.selectedPeoples, null);

      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      expect(sut.selectedPeoples, peoples);
    });
  });

  group("Is valid user and password", () {
    test("Should emit correct values on validate", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.isValidUserAndPassword(
        personalizedCode: userPersonalizedCode,
        password: password,
      );
    });
    test("Should emit correct values if password is invalid", () async {
      userValidations.mockIsValidPassword(false);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentials]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.isValidUserAndPassword(
        personalizedCode: userPersonalizedCode,
        password: password,
      );
    });
    test("Should emit correct values on validation throws", () async {
      userValidations.mockIsValidPasswordError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.isValidUserAndPassword(
        personalizedCode: userPersonalizedCode,
        password: password,
      );
    });
    test("Should return false if password is invalid", () async {
      userValidations.mockIsValidPassword(false);

      final isValid = await sut.isValidUserAndPassword(
        personalizedCode: userPersonalizedCode,
        password: password,
      );

      expect(isValid, false);
    });
    test("Should return true if password is valid", () async {
      userValidations.mockIsValidPassword(true);

      final isValid = await sut.isValidUserAndPassword(
        personalizedCode: userPersonalizedCode,
        password: password,
      );

      expect(isValid, true);
    });
  });

  group("Open or blockade command number", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.openOrBlockadeCommand(
        password: password,
        userCode: userCode,
        commandNumber: newFixedCommandNumber,
        isOpen: true,
      );
    });
    test("Should emit correct values on error", () async {
      commandInformations.mockErrorOpenOrBlockade(DomainError.unexpected);

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.openOrBlockadeCommand(
        password: password,
        userCode: userCode,
        commandNumber: newFixedCommandNumber,
        isOpen: true,
      );
    });
    test("Should call with correct values", () async {
      bool isOpen = faker.randomGenerator.boolean();

      await sut.openOrBlockadeCommand(
        password: password,
        userCode: userCode,
        commandNumber: newFixedCommandNumber,
        isOpen: isOpen,
      );

      verify(() => commandInformations.openOrBlockade(
            commandNumber: newFixedCommandNumber.toString().padLeft(3, "0"),
            isOpen: isOpen,
          )).called(1);
    });
    test("Should return true on success", () async {
      bool isOpen = faker.randomGenerator.boolean();

      final value = await sut.openOrBlockadeCommand(
        password: password,
        userCode: userCode,
        commandNumber: newFixedCommandNumber,
        isOpen: isOpen,
      );

      expect(value, true);
    });
    test("Should return false on error", () async {
      commandInformations.mockErrorOpenOrBlockade(DomainError.unexpected);
      bool isOpen = faker.randomGenerator.boolean();

      final value = await sut.openOrBlockadeCommand(
        password: password,
        userCode: userCode,
        commandNumber: newFixedCommandNumber,
        isOpen: isOpen,
      );

      expect(value, false);
    });
    test("Should call userValidations", () async {
      await sut.openOrBlockadeCommand(
        password: password,
        userCode: userCode,
        commandNumber: newFixedCommandNumber,
        isOpen: false,
      );

      verify(() => userValidations.isValidPassword(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            personalizedCode: userCode,
            password: password,
          )).called(1);
    });
    test("Should emit correct error on invalid credentials", () async {
      userValidations.mockIsValidPasswordError(
          DomainError.invalidCredentialsOrAccessDenied);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.invalidCredentialsOrAccessDenied]),
      );

      final value = await sut.openOrBlockadeCommand(
        password: password,
        userCode: userCode,
        commandNumber: newFixedCommandNumber,
        isOpen: false,
      );

      expect(value, false);
    });

    test("Should emit correct error on throws", () async {
      userValidations.mockIsValidPasswordError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      final value = await sut.openOrBlockadeCommand(
        password: password,
        userCode: userCode,
        commandNumber: newFixedCommandNumber,
        isOpen: false,
      );

      expect(value, false);
    });
    test("Should update already paid to false", () async {
      await sut.openOrBlockadeCommand(
        password: password,
        userCode: userCode,
        commandNumber: newFixedCommandNumber,
        isOpen: false,
      );

      verify(() => alreadyPaid.update(false)).called(1);
    });
  });

  group("Update selected peoples", () {
    test("Should update to null correctly", () {
      sut.updateSelectedPeoples(null);

      expect(sut.selectedPeoples, null);
    });
    test("Should update to correctly", () {
      final newValue = faker.randomGenerator.integer(100);
      sut.updateSelectedPeoples(newValue);

      expect(sut.selectedPeoples, newValue);
    });
  });
  group("Update selected seller", () {
    test("Should update to null correctly", () {
      sut.updateSelectedSeller(null);

      expect(sut.selectedSeller, null);
    });
    test("Should update to correctly", () {
      sut.updateSelectedSeller(selectedSeller);

      expect(sut.selectedSeller, selectedSeller);
    });
  });
  group("Update selected command", () {
    test("Should update to correctly", () {
      final newValue = faker.randomGenerator.integer(100);
      sut.updateSelectedCommand(newValue);

      expect(sut.selectedCommand, newValue);
    });
  });

  group("Close APP", () {
    test("Should call persistent.closeApp", () async {
      await sut.closeApp();

      verify(() => persistent.closeApp()).called(1);
    });
  });
}
