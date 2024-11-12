import 'package:clean_celta_mobile/data/models/enterprise_model.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';

import '../../data/mocks/mocks.dart';
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
  late EnterprisePresenterSpy enterprisePresenter;

  late NavigateToSpy navigateTo;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late LocalCommandDataSpy localCommandData;
  late UserValidationsSpy userValidations;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late LoadSellersSpy loadSellers;
  late CommandInformationsSpy commandInformations;
  late PersistentSpy persistent;
  late AddDeviceInfoSpy addDeviceInfo;

  late CommandEntity fixedCommandEntity;
  late CommandEntity notFixedCommandEntity;
  late int newFixedCommandNumber;
  late int userPersonalizedCode;
  late SaleRequestTempEntity saleRequestTempEntity;
  late List<SellerEntity> sellerEntitys;
  late SellersViewModel selectedSeller;
  late int userCode;
  late String password;
  late Map<String, dynamic> enterpriseJson;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initPresenters() {
    printedProductsPresenter = PrintedProductsPresenterSpy();
    cartPresenter = CartPresenterSpy();
    menuPresenter = MenuPresenterSpy();
    expansibleGroupFromProductPresenter =
        ExpansibleGroupFromProductPresenterSpy();
    enterprisePresenter = EnterprisePresenterSpy();
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
      addDeviceInfo: addDeviceInfo,
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
    addDeviceInfo = AddDeviceInfoSpy();
  }

  void initMocks() {
    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    localCommandData.mockLoad(fixedCommandEntity);
    localCommandData.mockUpdate();
    loadSaleRequestTemp.mockLoadSaleRequestTemp(saleRequestTempEntity);
    updateSaleRequestTemp.mockUpdateSaleRequestTemp();
    loadSellers.mockLoadSellers(sellerEntitys);
    addDeviceInfo.mockDeviceInfo(sut.commandNumber?.toInt());
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

    sellerEntitys = [
      EntityFactory.makeSellerEntity(),
      EntityFactory.makeSellerEntity(),
    ];
    selectedSeller = EntityFactory.makeSellersViewModel();

    userCode = faker.randomGenerator.integer(100);

    enterpriseJson = EnterpriseValidationModel.fromEntity(
            EnterpriseDataBuilder.enterpriseDataEntity!)
        .toJson();
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
    group("Do logout", () {
      test('Should go to SplashPage', () async {
        await sut.doLogout(
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verify(() => navigateTo.navigate(
              pageRoute: PageRoutes.splash,
              clear: true,
            )).called(1);
      });

      test('Should make not persist app when go to splash page', () async {
        await sut.doLogout(
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verify(() => persistent.makeNotPersistent()).called(1);
      });

      test('Should update updateMenu', () async {
        await sut.doLogout(
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        expect(sut.updateMenu, -1);
      });
      test('Should call enterprisePresenter.clearEnterpriseData', () async {
        await sut.doLogout(
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verify(() => enterprisePresenter.clearEnterpriseData()).called(1);
      });
    });
    test('Should go to PrintedProductsPage', () async {
      sut.goToPrintedProductsPage();

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.printedProducts,
          )).called(1);
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

  group("Clear data", () {
    test('Should clear command number', () async {
      sut.updateCommandNumber("001");

      sut.clear();

      expect(sut.commandNumber, isNull);
    });
    test('Should clear updateMenu count', () async {
      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        updateMenu: faker.randomGenerator.integer(100),
      );

      sut.clear();

      expect(sut.updateMenu, -1);
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
      final commandNumber =
          faker.randomGenerator.integer(100).toString().padLeft(3, "0");
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

      verifyNever(() => cartPresenter.getSaleRequestTemp(
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

      verify(() => cartPresenter.getSaleRequestTemp(
            fixedCommandEntity.commandNumber.toString(),
          )).called(1);
      verify(() => printedProductsPresenter.loadPrinted(sut.commandNumber!))
          .called(1);
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
        useCovenant: EnterpriseDataBuilder.enterpriseDataEntity!.useCovenant,
        persistApp: true,
        enterpriseConcentradorParametersEntity: EnterpriseDataBuilder
            .enterpriseDataEntity!.enterpriseConcentradorParametersEntity,
        updateMenu: EnterpriseDataBuilder.enterpriseDataEntity!.updateMenu,
        updateConcentratorEnterpriseData: EnterpriseDataBuilder
            .enterpriseDataEntity!.updateConcentratorEnterpriseData,
        serviceChargePercentageOrValue: EnterpriseDataBuilder
            .enterpriseDataEntity!.serviceChargePercentageOrValue,
        serviceChargeType:
            EnterpriseDataBuilder.enterpriseDataEntity!.serviceChargeType,
        updateEnterprise:
            EnterpriseDataBuilder.enterpriseDataEntity!.updateEnterprise,
        updateDevicesInformations: EnterpriseDataBuilder
            .enterpriseDataEntity!.updateDevicesInformations,
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
        useCovenant: EnterpriseDataBuilder.enterpriseDataEntity!.useCovenant,
        persistApp: true,
        enterpriseConcentradorParametersEntity: EnterpriseDataBuilder
            .enterpriseDataEntity!.enterpriseConcentradorParametersEntity,
        updateMenu: EnterpriseDataBuilder.enterpriseDataEntity!.updateMenu,
        updateConcentratorEnterpriseData: EnterpriseDataBuilder
            .enterpriseDataEntity!.updateConcentratorEnterpriseData,
        serviceChargePercentageOrValue: EnterpriseDataBuilder
            .enterpriseDataEntity!.serviceChargePercentageOrValue,
        serviceChargeType:
            EnterpriseDataBuilder.enterpriseDataEntity!.serviceChargeType,
        updateEnterprise:
            EnterpriseDataBuilder.enterpriseDataEntity!.updateEnterprise,
        updateDevicesInformations: EnterpriseDataBuilder
            .enterpriseDataEntity!.updateDevicesInformations,
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
        useCovenant: EnterpriseDataBuilder.enterpriseDataEntity!.useCovenant,
        persistApp: false,
        enterpriseConcentradorParametersEntity: EnterpriseDataBuilder
            .enterpriseDataEntity!.enterpriseConcentradorParametersEntity,
        updateMenu: EnterpriseDataBuilder.enterpriseDataEntity!.updateMenu,
        updateConcentratorEnterpriseData: EnterpriseDataBuilder
            .enterpriseDataEntity!.updateConcentratorEnterpriseData,
        serviceChargePercentageOrValue: EnterpriseDataBuilder
            .enterpriseDataEntity!.serviceChargePercentageOrValue,
        serviceChargeType:
            EnterpriseDataBuilder.enterpriseDataEntity!.serviceChargeType,
        updateEnterprise:
            EnterpriseDataBuilder.enterpriseDataEntity!.updateEnterprise,
        updateDevicesInformations: EnterpriseDataBuilder
            .enterpriseDataEntity!.updateDevicesInformations,
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
    test("Should update updateMenu when pass a value", () async {
      final value = faker.randomGenerator.integer(100);

      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        updateMenu: value,
      );

      expect(sut.updateMenu, value);
    });
    test("Should not update updateMenu when dont pass a value", () async {
      await sut.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        updateMenu: null,
      );

      expect(sut.updateMenu, null);
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

  group("Update command number", () {
    test("Should update command number correctly", () {
      sut.updateCommandNumber("99");
      expect(sut.commandNumber, "099");

      sut.updateCommandNumber(null);
      expect(sut.commandNumber, null);

      sut.updateCommandNumber("1");
      expect(sut.commandNumber, "001");
    });
  });

  group("Do on remote enterprise changes", () {
    group("Update menu", () {
      test("Should call loadCommandData if enterprise.menucount is different",
          () async {
        enterpriseJson["updateMenu"] =
            faker.randomGenerator.integer(1000, min: 500);

        await sut.doOnRemoteEnterpriseChanges(
          data: enterpriseJson,
          menuPresenter: menuPresenter,
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verify(() => localCommandData.load()).called(1);
      });
      test("Should not call loadCommandData if enterprise.menucount is equal",
          () async {
        enterpriseJson["updateMenu"] =
            faker.randomGenerator.integer(1000, min: 500);

        await sut.doOnRemoteEnterpriseChanges(
          data: enterpriseJson,
          menuPresenter: menuPresenter,
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          enterprisePresenter: enterprisePresenter,
        );
        await sut.doOnRemoteEnterpriseChanges(
          data: enterpriseJson,
          menuPresenter: menuPresenter,
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verify(() => localCommandData.load()).called(1);
      });
    });

    group("Never change data", () {
      test("Should not call functions if enterpriseId is null", () async {
        EnterpriseDataBuilder.enterpriseDataEntity = EnterpriseEntity(
          enterpriseName: faker.randomGenerator.string(10),
          url: faker.randomGenerator.string(10),
          enterpriseId: null,
          concentradorUrl: faker.randomGenerator.string(10),
          persistApp: faker.randomGenerator.boolean(),
          urlCCS: faker.randomGenerator.string(10),
          useCovenant: faker.randomGenerator.boolean(),
          enterpriseConcentradorParametersEntity: null,
          updateMenu: faker.randomGenerator.integer(100),
          updateDevicesInformations: faker.randomGenerator.integer(100),
          updateEnterprise: faker.randomGenerator.integer(100),
          updateConcentratorEnterpriseData: faker.randomGenerator.integer(100),
          serviceChargePercentageOrValue: faker.randomGenerator.decimal(),
          serviceChargeType: faker.randomGenerator.integer(2),
        );

        await sut.doOnRemoteEnterpriseChanges(
          data: enterpriseJson,
          menuPresenter: menuPresenter,
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verifyNever(() => localCommandData
            .load()); //first abstract called function when dont return because id or url is null
      });
      test("Should not call functions if enterpriseUrl is null", () async {
        EnterpriseDataBuilder.enterpriseDataEntity = EnterpriseEntity(
          enterpriseName: faker.randomGenerator.string(10),
          url: null,
          enterpriseId: faker.randomGenerator.integer(100),
          concentradorUrl: faker.randomGenerator.string(10),
          persistApp: faker.randomGenerator.boolean(),
          urlCCS: faker.randomGenerator.string(10),
          useCovenant: faker.randomGenerator.boolean(),
          enterpriseConcentradorParametersEntity: null,
          updateMenu: faker.randomGenerator.integer(100),
          updateDevicesInformations: faker.randomGenerator.integer(100),
          updateEnterprise: faker.randomGenerator.integer(100),
          updateConcentratorEnterpriseData: faker.randomGenerator.integer(100),
          serviceChargePercentageOrValue: faker.randomGenerator.decimal(),
          serviceChargeType: faker.randomGenerator.integer(2),
        );

        await sut.doOnRemoteEnterpriseChanges(
          data: enterpriseJson,
          menuPresenter: menuPresenter,
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verifyNever(() => localCommandData
            .load()); //first abstract called function when dont return because id or url is null
      });
    });

    group("Update concentrator enterprise parameters", () {
      test(
          "Should call updateConcentratorEnterpriseParameters when value is different",
          () async {
        enterpriseJson["updateConcentratorEnterpriseData"] =
            faker.randomGenerator.integer(1000, min: 500);

        await sut.doOnRemoteEnterpriseChanges(
          data: enterpriseJson,
          menuPresenter: menuPresenter,
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verify(() =>
                enterprisePresenter.updateConcentratorEnterpriseParameters())
            .called(1);
      });
    });

    group("Update devices informations", () {
      test("Should call add device info on updateDevicesInformations changes",
          () async {
        enterpriseJson["updateDevicesInformations"] =
            faker.randomGenerator.integer(1000, min: 500);

        await sut.doOnRemoteEnterpriseChanges(
          data: enterpriseJson,
          menuPresenter: menuPresenter,
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verify(() => addDeviceInfo.add(sut.commandNumber?.toInt())).called(1);
      });
      test("Should update enterprise on updateDeviceInformations changes",
          () async {
        enterpriseJson["updateDevicesInformations"] =
            faker.randomGenerator.integer(1000, min: 500);

        await sut.doOnRemoteEnterpriseChanges(
          data: enterpriseJson,
          menuPresenter: menuPresenter,
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        expect(
          EnterpriseDataBuilder.enterpriseDataEntity,
          EnterpriseValidationModel.fromJson(enterpriseJson).toEntity(),
        );
      });
      test("Should update locally when updateDeviceInformations changes",
          () async {
        enterpriseJson["updateDevicesInformations"] =
            faker.randomGenerator.integer(1000, min: 500);

        await sut.doOnRemoteEnterpriseChanges(
          data: enterpriseJson,
          menuPresenter: menuPresenter,
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verify(() => localEnterpriseData.add(
                EnterpriseValidationModel.fromJson(enterpriseJson).toEntity()))
            .called(1);
      });
    });

    group("Update enterprise", () {
      test("Should update enterprise data when updateEnterprise is different",
          () async {
        enterpriseJson["updateEnterprise"] =
            faker.randomGenerator.integer(1000, min: 500);

        await sut.doOnRemoteEnterpriseChanges(
          data: enterpriseJson,
          menuPresenter: menuPresenter,
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        expect(
          EnterpriseDataBuilder.enterpriseDataEntity,
          EnterpriseValidationModel.fromJson(enterpriseJson).toEntity(),
        );
      });
      test(
          "Should update locally enterprise data when updateEnterprise is different",
          () async {
        enterpriseJson["updateEnterprise"] =
            faker.randomGenerator.integer(1000, min: 500);

        await sut.doOnRemoteEnterpriseChanges(
          data: enterpriseJson,
          menuPresenter: menuPresenter,
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        final newEnterprise =
            EnterpriseValidationModel.fromJson(enterpriseJson).toEntity();

        verify(() => localEnterpriseData.add(newEnterprise)).called(1);
      });
    });
  });

  group("Navigate to configurations page", () {
    test("Should emit correct values", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.goToConfigurationsPage(
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );
    });
    test("Should emit correct values on validate password throws", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentials]));

      userValidations.mockIsValidPasswordError(
        DomainError.invalidCredentials,
      );

      await sut.goToConfigurationsPage(
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );
    });
    test("Should emit correct values on password is invalid", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentials]));

      userValidations.mockIsValidPassword(false);

      await sut.goToConfigurationsPage(
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );
    });

    test("Should call user validations with correct values", () async {
      await sut.goToConfigurationsPage(
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      verify(() => userValidations.isValidPassword(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            personalizedCode: userPersonalizedCode,
            password: password,
          ));
    });
    test("Should emit correct error if cant cancel", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.accessDenied]));

      userValidations.mockCanCancel(false);

      await sut.goToConfigurationsPage(
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );
    });

    test("Should call navigateTo with correct values", () async {
      await sut.goToConfigurationsPage(
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      verify(() => navigateTo.navigate(pageRoute: PageRoutes.configurations));
    });
  });
}
