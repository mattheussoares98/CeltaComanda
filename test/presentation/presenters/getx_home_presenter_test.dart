import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/infra/helpers/helpers.dart';
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
  late ConfigurationsPresenterSpy configurationsPresenter;

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
  late AddPendingDeviceToUpdateSpy addPendingDeviceToUpdate;
  late LoadDeviceDataSpy loadDeviceData;
  late PdvRegistrationSpy pdvRegistration;
  late DeleteDataSpy deleteData;
  late LastImportSpy lastImport;
  late LoadExportChargingSpy loadExportCharging;
  late ConcentratorLoginSpy concentratorLogin;

  late CommandEntity fixedCommandEntity;
  late CommandEntity notFixedCommandEntity;
  late int newFixedCommandNumber;
  late int userPersonalizedCode;
  late SaleRequestTempEntity saleRequestTempEntity;
  late List<SellerEntity> sellerEntitys;
  late SellersViewModel selectedSeller;
  late int userCode;
  late String username;
  late String password;
  late Map<String, dynamic> enterpriseJson;
  late String imeiOrWindowsId;
  late double applicationVersion;
  late CommandEntity commandEntity;
  late UserConcentratorEntity userConcentratorEntity;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initPresenters() {
    printedProductsPresenter = PrintedProductsPresenterSpy();
    cartPresenter = CartPresenterSpy();
    menuPresenter = MenuPresenterSpy();
    expansibleGroupFromProductPresenter =
        ExpansibleGroupFromProductPresenterSpy();
    enterprisePresenter = EnterprisePresenterSpy();
    configurationsPresenter = ConfigurationsPresenterSpy();

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
      addPendingDeviceToUpdate: addPendingDeviceToUpdate,
      loadDeviceData: loadDeviceData,
      pdvRegistration: pdvRegistration,
      deleteData: deleteData,
      lastImport: lastImport,
      loadExportCharging: loadExportCharging,
      concentratorLogin: concentratorLogin,
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
    addPendingDeviceToUpdate = AddPendingDeviceToUpdateSpy();
    loadDeviceData = LoadDeviceDataSpy();
    pdvRegistration = PdvRegistrationSpy();
    deleteData = DeleteDataSpy();
    lastImport = LastImportSpy();
    loadExportCharging = LoadExportChargingSpy();
    concentratorLogin = ConcentratorLoginSpy();
  }

  void initMocks() {
    localEnterpriseData.mockAdd(EnterpriseBuilder.entity!);
    localCommandData.mockLoad(fixedCommandEntity);
    localCommandData.mockUpdate();
    loadSaleRequestTemp.mockLoadSaleRequestTemp(saleRequestTempEntity);
    updateSaleRequestTemp.mockUpdateSaleRequestTemp();
    loadSellers.mockLoadSellers(sellerEntitys);
    addDeviceInfo.mockDeviceInfo(fixedCommandEntity.commandNumber?.toInt());
    addPendingDeviceToUpdate.mockAdd(imeiOrWindowsId);
    loadDeviceData.mockGetImeiOrWindowsId(imeiOrWindowsId);
    loadDeviceData.mockGetApplicationVersion(applicationVersion.toString());
    loadExportCharging.mockLoad([]);
    concentratorLogin.mockLogin(userConcentratorEntity);
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
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

    enterpriseJson =
        EnterpriseModel.fromEntity(EnterpriseBuilder.entity!).toJson();
    imeiOrWindowsId = faker.randomGenerator.string(10);
    applicationVersion = faker.randomGenerator.decimal();
    commandEntity = EntityFactory.makeCommandEntity();
    username = faker.person.name();
    userConcentratorEntity = EntityFactory.makeUserConcentratorEntity(
        groupId: faker.randomGenerator.integer(100));
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
    registerFallbackValue(EntityFactory.makePdvEntity());
    registerFallbackValue(EntityFactory.makeCartProductEntity(
      maximumProductQuantity: 0,
      minimumProductQuantity: 0,
    ));

    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
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

      test('Should call enterprisePresenter.clearEnterpriseData', () async {
        await sut.doLogout(
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verify(() => enterprisePresenter.clearEnterpriseData()).called(1);
      });
      test('Should call localCommandData.update correctly', () async {
        await sut.doLogout(
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verify(
          () => localCommandData.update(CommandEntity(
            commandNumber: null,
            isFixedCommandNumber: false,
            pdv: null,
          )),
        ).called(1);
      });

      test('Should load local command entity', () async {
        await sut.doLogout(
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verify(() => localCommandData.load()).called(1);
      });

      test('Should unregister pdv when local commandEntity.pdv is not null',
          () async {
        final localEntity = EntityFactory.makeCommandEntity();
        localCommandData.mockLoad(localEntity);

        await sut.doLogout(
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verify(() => pdvRegistration.setPdvRegister(
              pdvId: localEntity.pdv!.PdvId!,
              imeiOrWindowsId: "",
              versionNumber: "",
              ip: "",
              isUsing: false,
            )).called(1);
      });
      test('Should not unregister pdv when local commandEntity.pdv is null',
          () async {
        final localEntity = EntityFactory.makeCommandEntity();
        localCommandData.mockLoad(null);

        await sut.doLogout(
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verifyNever(() => pdvRegistration.setPdvRegister(
              pdvId: localEntity.pdv!.PdvId!,
              imeiOrWindowsId: "",
              versionNumber: "",
              ip: "",
              isUsing: false,
            ));
      });

      test('Should not unregister pdv when local commandEntity.pdv is null',
          () async {
        await sut.doLogout(
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          enterprisePresenter: enterprisePresenter,
        );

        verify(() => deleteData.delete([
              CacheKeys.alreadyPaid,
              CacheKeys.cartProducts,
              CacheKeys.commandData,
              CacheKeys.comments,
              CacheKeys.images,
              CacheKeys.lastImport,
              CacheKeys.parameters,
              CacheKeys.paidInformations,
              CacheKeys.printRequest,
              CacheKeys.updatedAllImages,
              CacheKeys.updatedSaleRequestTemp,
            ])).called(1);
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
    test('Should clear commandEntity', () async {
      await sut.updateCommandEntity(
        commandNumber: commandEntity.commandNumber,
        isFixedCommandNumber: commandEntity.isFixedCommandNumber,
        pdv: commandEntity.pdv,
      );

      await sut.clear();

      expect(sut.commandEntity, isNull);
    });

    test('Should call local command data update correctly', () async {
      await sut.clear();

      verify(() => localCommandData.update(
            CommandEntity(
              commandNumber: null,
              isFixedCommandNumber: false,
              pdv: null,
            ),
          )).called(1);
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

  group("load command data", () {
    test("Should load useFixedCommandNumber on call loadUseFixedCommandNumber",
        () async {
      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => localCommandData.load()).called(1);
    });
    test(
        "Should update command entity locally correctly when dont return a null value and is fixed command",
        () async {
      final entity = CommandEntity(
        commandNumber: commandEntity.commandNumber,
        isFixedCommandNumber: true,
        pdv: commandEntity.pdv,
      );
      localCommandData.mockLoad(entity);

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => localCommandData.update(entity)).called(1);
    });
    test(
        "Should update command entity locally correctly when dont return a null value and dont is fixed command",
        () async {
      final entity = CommandEntity(
        commandNumber: commandEntity.commandNumber,
        isFixedCommandNumber: false,
        pdv: commandEntity.pdv,
      );
      localCommandData.mockLoad(entity);

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => localCommandData.update(CommandEntity(
            commandNumber: null,
            isFixedCommandNumber: false,
            pdv: commandEntity.pdv,
          ))).called(1);
    });
    test("Should not update local command data when return a null value",
        () async {
      localCommandData.mockLoad(null);

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verifyNever(() => localCommandData.update(commandEntity));
    });

    test("Should emit correct values on loadUseFixedCommandNumber", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test("Should update sut.commandEntity?.isFixedCommandNumber correctly",
        () async {
      const fixed = CommandEntity(
        commandNumber: "commandNumber",
        isFixedCommandNumber: true,
        pdv: null,
      );
      const notFixed = CommandEntity(
        commandNumber: "commandNumber",
        isFixedCommandNumber: false,
        pdv: null,
      );

      localCommandData.mockLoad(fixed);
      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(sut.commandEntity?.isFixedCommandNumber, true);

      localCommandData.mockLoad(notFixed);
      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(sut.commandEntity?.isFixedCommandNumber, false);
    });
    test(
        "Should update sut.commandEntity!.commandNumber correctly if is fixed command number",
        () async {
      final entity1 = CommandEntity(
        commandNumber:
            faker.randomGenerator.integer(999).toString().padLeft(3, "0"),
        isFixedCommandNumber: true,
        pdv: null,
      );

      final entity2 = CommandEntity(
        commandNumber:
            faker.randomGenerator.integer(999).toString().padLeft(3, "0"),
        isFixedCommandNumber: true,
        pdv: null,
      );

      localCommandData.mockLoad(entity1);
      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(
          sut.commandEntity!.commandNumber, entity1.commandNumber.toString());

      localCommandData.mockLoad(entity2);
      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(
          sut.commandEntity!.commandNumber, entity2.commandNumber.toString());
    });

    test(
        "Should not call cartPresenter.loadSaleRequest and loadSaleRequestTemp when is not fixed command number",
        () async {
      localCommandData.mockLoad(notFixedCommandEntity);

      await sut.loadCommandData(
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
          commandNumber: notFixedCommandEntity.commandNumber!,
        ),
      );
    });
    test(
        "Should  call cartPresenter.loadSaleRequest and printedProductsPresenter.loadPrinted when is fixed command number",
        () async {
      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => cartPresenter.getSaleRequestTemp(
            fixedCommandEntity.commandNumber.toString().padLeft(3, "0"),
          )).called(1);
      verify(() => printedProductsPresenter
          .loadPrinted(sut.commandEntity!.commandNumber!)).called(1);
    });
    test(
        "Should emit correct values on cartPresenter.loadSaleRequest throw DomainError.unexpected",
        () async {
      cartPresenter.mockLoadSaleRequestTempError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test(
        "Should emit correct values on cartPresenter.loadSaleRequest throw DomainError.commandNotAvailable",
        () async {
      cartPresenter
          .mockLoadSaleRequestTempError(DomainError.commandNotAvailable);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test(
        "Should emit correct values on printedProductsPresenter.loadPrinted throw DomainError.unexpected",
        () async {
      printedProductsPresenter.mockLoadPrintedError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test(
        "Should emit correct values on printedProductsPresenter.loadPrinted throw DomainError.commandNotAvailable",
        () async {
      printedProductsPresenter
          .mockLoadPrintedError(DomainError.commandNotAvailable);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });

    test("Should call loadSaleRequestTemp", () async {
      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(
        () => loadSaleRequestTemp.load(
          commandNumber:
              fixedCommandEntity.commandNumber.toString().padLeft(3, "0"),
        ),
      ).called(1);
    });
    test("Should update peoples number", () async {
      // sut.updateCommandEntity(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.selectedPeoples, saleRequestTempEntity.Peoples);
    });

    test("Should call loadSellers", () async {
      // sut.updateCommandEntity(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => loadSellers.load()).called(1);
    });

    test("Should update sellers correctly", () async {
      await sut.updateCommandEntity(
        commandNumber: sut.commandEntity?.commandNumber,
        isFixedCommandNumber: false,
        pdv: sut.commandEntity?.pdv,
      );
      expect(sut.commandEntity?.isFixedCommandNumber, false);

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.sellers,
          sellerEntitys.map((e) => SellersViewModel.fromEntity(e)).toList());
    });
    test("Should update selected seller correctly", () async {
      // sut.updateCommandEntity(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(
        sut.selectedSeller?.toEntity(),
        sellerEntitys.firstWhereOrNull(
            (e) => e.SellersId.toString() == saleRequestTempEntity.SellerCode),
      );
    });

    test("Should emit correct values on throws", () async {
      loadSellers.mockLoadSellersError();
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      // sut.updateCommandEntity(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test("Should call isValidDateTime when is fixed command number", () async {
      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(
        () => commandInformations.isValidDatetime(
          commandNumber:
              fixedCommandEntity.commandNumber.toString().padLeft(3, "0"),
        ),
      ).called(1);
    });
    test("Should call throw blockedCommand when is invalid datetime", () async {
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.blockedCommand]),
      );

      commandInformations.mockIsValidDateTime(false);
      // sut.updateCommandEntity(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });

    test(
        "Should make persist when Enterprise.persist is true and is generating version to tablet",
        () async {
      EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData(
        persistApp: true,
      );

      sut.changeIsGeneratingVersionToTablet(true);

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => persistent.makePersistent()).called(1);
    });

    test(
        "Should make NOT persist when is not generating version to tablet and Enterprise.persist is true",
        () async {
      EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData(
        persistApp: true,
      );

      sut.changeIsGeneratingVersionToTablet(false);

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => persistent.makeNotPersistent()).called(1);
    });
    test("Should make NOT persist Enterprise.persist is false", () async {
      EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData(
        persistApp: false,
      );

      await sut.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => persistent.makeNotPersistent()).called(1);
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
            url: EnterpriseBuilder.entity!.url!,
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

  group("Update command entity", () {
    test("Should update correctly when pass all parameters", () async {
      await sut.updateCommandEntity(
        commandNumber: commandEntity.commandNumber,
        isFixedCommandNumber: commandEntity.isFixedCommandNumber,
        pdv: commandEntity.pdv,
      );

      expect(
          sut.commandEntity,
          CommandEntity(
            commandNumber:
                commandEntity.commandNumber?.toString().padLeft(3, "0"),
            isFixedCommandNumber: commandEntity.isFixedCommandNumber,
            pdv: commandEntity.pdv,
          ));
    });
    test("Should update correctly when pass null values", () async {
      await sut.updateCommandEntity(
        commandNumber: null,
        isFixedCommandNumber: commandEntity.isFixedCommandNumber,
        pdv: null,
      );

      expect(
          sut.commandEntity,
          CommandEntity(
            commandNumber: null,
            isFixedCommandNumber: commandEntity.isFixedCommandNumber,
            pdv: null,
          ));
    });
    test("Should update call local command data update", () async {
      await sut.updateCommandEntity(
        commandNumber: commandEntity.commandNumber,
        isFixedCommandNumber: commandEntity.isFixedCommandNumber,
        pdv: commandEntity.pdv,
      );

      verify(() => localCommandData.update(sut.commandEntity!)).called(1);
    });
  });

  group("Do on remote enterprise changes", () {
    group("Never change data", () {
      test("Should not call functions if enterpriseId is null", () async {
        EnterpriseBuilder.entity = EntityFactory.makeEnterpriseWithNullValue(
          atualEntity: EnterpriseBuilder.entity!,
          enterpriseId: true,
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
        EnterpriseBuilder.entity = EntityFactory.makeEnterpriseWithNullValue(
          atualEntity: EnterpriseBuilder.entity!,
          url: true,
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
          EnterpriseBuilder.entity,
          EnterpriseModel.fromJson(enterpriseJson).toEntity(),
        );
      });
      test(
          "Should update concentrador parameters data when updateEnterprise is different",
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

        verify(() =>
                enterprisePresenter.updateConcentratorEnterpriseParameters())
            .called(1);
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
            EnterpriseModel.fromJson(enterpriseJson).toEntity();

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
            url: EnterpriseBuilder.entity!.url!,
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

  group("Application is in latest version", () {
    test("Should return true if remote data is null", () async {
      EnterpriseBuilder.entity = EntityFactory.makeEnterpriseWithNullValue(
        atualEntity: EnterpriseBuilder.entity!,
        latestCompatibleVersion: true,
      );

      final result = await sut.applicationIsInLatestVersion();

      expect(result, true);
    });

    test("Should return true if throws", () async {
      loadDeviceData.mockGetApplicationVersionError();

      final result = await sut.applicationIsInLatestVersion();

      expect(result, true);
    });
    test("Should return true if local version is greater than remote version",
        () async {
      loadDeviceData.mockGetApplicationVersion(
        faker.randomGenerator.integer(1000, min: 101).toString(),
      );

      EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData(
        latestCompatibleVersion: faker.randomGenerator.integer(100).toString(),
      );

      final result = await sut.applicationIsInLatestVersion();

      expect(result, true);
    });
    test("Should return false if remote version is greater than local version",
        () async {
      sut.changeIsGeneratingVersionToTablet(true);
      loadDeviceData.mockGetApplicationVersion(
        faker.randomGenerator.integer(100).toString(),
      );
      EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData(
        latestCompatibleVersion:
            faker.randomGenerator.integer(1000, min: 101).toString(),
      );

      final result = await sut.applicationIsInLatestVersion();

      expect(result, false);
    });

    test("Should return true versions are equals", () async {
      loadDeviceData.mockGetApplicationVersion(
        EnterpriseBuilder.entity!.latestCompatibleVersion!,
      );

      final result = await sut.applicationIsInLatestVersion();

      expect(result, true);
    });
    test("Should return true is not generating version to tablet", () async {
      sut.changeIsGeneratingVersionToTablet(false);

      bool result = await sut.applicationIsInLatestVersion();

      expect(result, true);
    });
  });

  group("Update what need", () {
    group("Pattern requests", () {
      test("Should call load last import", () async {
        await sut.updateWhatNeed(
          enterprisePresenter: enterprisePresenter,
          configurationsPresenter: configurationsPresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );

        verify(() => lastImport.load()).called(1);
      });
      test("Should load last exports with correct pdv number", () async {
        await sut.updateCommandEntity(
          commandNumber: faker.randomGenerator.integer(100).toString(),
          isFixedCommandNumber: faker.randomGenerator.boolean(),
          pdv: EntityFactory.makePdvEntity(),
        );
        await sut.updateWhatNeed(
          enterprisePresenter: enterprisePresenter,
          configurationsPresenter: configurationsPresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );

        verify(() => loadExportCharging.load(
              pdvNumber: sut.commandEntity!.pdv!.PdvNumber!,
            )).called(1);
      });
      test("Should load last exports with pdv 100 if doesnt have register",
          () async {
        sut.updateCommandEntity(
          commandNumber: sut.commandEntity?.commandNumber,
          isFixedCommandNumber: sut.commandEntity?.isFixedCommandNumber == true,
          pdv: null,
        );
        await sut.updateWhatNeed(
          enterprisePresenter: enterprisePresenter,
          configurationsPresenter: configurationsPresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );

        verify(() => loadExportCharging.load(
              pdvNumber: "100",
            )).called(1);
      });
    });
    group("Get groups and products", () {
      test(
          "Should emit correct values on menuPresenter.loadGroupsAndProducts trhows CommandNotAvailable",
          () async {
        lastImport.mockLoad(
          LastImportEntity(
            products: DateTime(2024),
            images: null,
            users: null,
            enterprise: null,
          ),
        );
        loadExportCharging.mockLoad(
          [
            EntityFactory.makeExportChargingEntity(LoadTypeEnum.products,
                date: DateTime(2025))
          ],
        );
        menuPresenter
            .mockGetGroupsAndProductsError(DomainError.commandNotAvailable);

        expectLater(sut.mainErrorStream,
            emitsInOrder([null, UIError.commandNotAvailable]));
        expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

        await sut.updateWhatNeed(
          enterprisePresenter: enterprisePresenter,
          configurationsPresenter: configurationsPresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );
      });
      test(
          "Should emit correct values on menuPresenter.loadGroupsAndProducts trhows unexpected",
          () async {
        lastImport.mockLoad(
          LastImportEntity(
            products: DateTime(2024),
            images: null,
            users: null,
            enterprise: null,
          ),
        );
        loadExportCharging.mockLoad(
          [
            EntityFactory.makeExportChargingEntity(LoadTypeEnum.products,
                date: DateTime(2025))
          ],
        );
        menuPresenter.mockGetGroupsAndProductsError(DomainError.unexpected);

        expectLater(
            sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
        expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

        await sut.updateWhatNeed(
          enterprisePresenter: enterprisePresenter,
          configurationsPresenter: configurationsPresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );
      });

      test(
        "Should call menuPresenter.getGroupsAndProducts if last import is older than last export",
        () async {
          final lastImported = LastImportEntity(
            products: DateTime(2024),
            images: null,
            users: null,
            enterprise: null,
          );
          final lastExport = EntityFactory.makeExportChargingEntity(
            LoadTypeEnum.products,
            date: DateTime(2025),
          );

          lastImport.mockLoad(lastImported);
          loadExportCharging.mockLoad([lastExport]);

          await sut.updateWhatNeed(
            enterprisePresenter: enterprisePresenter,
            configurationsPresenter: configurationsPresenter,
            menuPresenter: menuPresenter,
            expansibleGroupFromProductPresenter:
                expansibleGroupFromProductPresenter,
          );

          verify(() => menuPresenter.getGroupsAndProducts(
                commandEntity: sut.commandEntity,
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
                loadLocally: false,
              )).called(1);
        },
      );
      test(
        "Should NOT call menuPresenter.getGroupsAndProducts if last import is newer than last export",
        () async {
          final lastImported = LastImportEntity(
            products: DateTime(2025),
            images: null,
            users: null,
            enterprise: null,
          );
          final lastExport = EntityFactory.makeExportChargingEntity(
            LoadTypeEnum.products,
            date: DateTime(2024),
          );

          lastImport.mockLoad(lastImported);
          loadExportCharging.mockLoad([lastExport]);

          await sut.updateWhatNeed(
            enterprisePresenter: enterprisePresenter,
            configurationsPresenter: configurationsPresenter,
            menuPresenter: menuPresenter,
            expansibleGroupFromProductPresenter:
                expansibleGroupFromProductPresenter,
          );

          verifyNever(() => menuPresenter.getGroupsAndProducts(
                commandEntity: sut.commandEntity,
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
                loadLocally: false,
              ));
        },
      );

      test(
          "Should update products locally when menuPresenter.loadedMenu is empty",
          () async {
        menuPresenter.loadedMenuController = [];

        loadExportCharging.mockLoad([]);
        lastImport.mockLoad(
          LastImportEntity(
            products: faker.date.dateTime(),
            images: null,
            users: null,
            enterprise: null,
          ),
        );

        await sut.updateWhatNeed(
          enterprisePresenter: enterprisePresenter,
          configurationsPresenter: configurationsPresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );

        verify(() => menuPresenter.getGroupsAndProducts(
              commandEntity: sut.commandEntity,
              expansibleGroupFromProductPresenter:
                  expansibleGroupFromProductPresenter,
              loadLocally: true,
            )).called(1);
      });
    });
    group("Load all images", () {
      test(
        "Should call menuPresenter.loadAllImages if last import is older than last export",
        () async {
          final lastImported = LastImportEntity(
            products: null,
            images: DateTime(2024),
            users: null,
            enterprise: null,
          );
          final lastExport = EntityFactory.makeExportChargingEntity(
            LoadTypeEnum.images,
            date: DateTime(2025),
          );

          lastImport.mockLoad(lastImported);
          loadExportCharging.mockLoad([lastExport]);

          await sut.updateWhatNeed(
            enterprisePresenter: enterprisePresenter,
            configurationsPresenter: configurationsPresenter,
            menuPresenter: menuPresenter,
            expansibleGroupFromProductPresenter:
                expansibleGroupFromProductPresenter,
          );

          verify(() => menuPresenter.loadAllImages(
                loadLocally: false,
                updatedImages: [lastExport.FileName!],
              )).called(1);
        },
      );
      test(
        "Should NOT call menuPresenter.loadAllImages if last import is newer than last export",
        () async {
          final lastImported = LastImportEntity(
            products: null,
            images: DateTime(2025),
            users: null,
            enterprise: null,
          );
          final lastExport = EntityFactory.makeExportChargingEntity(
            LoadTypeEnum.images,
            date: DateTime(2024),
          );

          lastImport.mockLoad(lastImported);
          loadExportCharging.mockLoad([lastExport]);

          await sut.updateWhatNeed(
            enterprisePresenter: enterprisePresenter,
            configurationsPresenter: configurationsPresenter,
            menuPresenter: menuPresenter,
            expansibleGroupFromProductPresenter:
                expansibleGroupFromProductPresenter,
          );

          verifyNever(() => menuPresenter.loadAllImages(
                loadLocally: false,
                updatedImages: [],
              ));
        },
      );

      test(
          "Should update images locally when menuPresenter.downloadedImages is empty",
          () async {
        menuPresenter.downloadedImagesController = [];

        loadExportCharging.mockLoad([]);
        lastImport.mockLoad(
          LastImportEntity(
            products: null,
            images: faker.date.dateTime(),
            users: null,
            enterprise: null,
          ),
        );

        await sut.updateWhatNeed(
          enterprisePresenter: enterprisePresenter,
          configurationsPresenter: configurationsPresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );

        verify(() => menuPresenter.loadAllImages(
              loadLocally: true,
              updatedImages: [],
            )).called(1);
      });
    });

    group("Load group permissions", () {
      test("Should load remote if export is newer than last import", () async {
        lastImport.mockLoad(LastImportEntity(
          products: null,
          images: null,
          users: DateTime(2024),
          enterprise: null,
        ));

        loadExportCharging.mockLoad([
          EntityFactory.makeExportChargingEntity(LoadTypeEnum.users,
              date: DateTime(2025))
        ]);

        await sut.updateWhatNeed(
          enterprisePresenter: enterprisePresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          configurationsPresenter: configurationsPresenter,
        );

        verify(() => configurationsPresenter.updateUsersData(
              loadLocally: false,
            )).called(1);
      });
      test("Should load local if export is older than last import", () async {
        lastImport.mockLoad(LastImportEntity(
          products: null,
          images: null,
          users: DateTime(2025),
          enterprise: null,
        ));

        loadExportCharging.mockLoad([
          EntityFactory.makeExportChargingEntity(LoadTypeEnum.users,
              date: DateTime(2024))
        ]);

        await sut.updateWhatNeed(
          enterprisePresenter: enterprisePresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          configurationsPresenter: configurationsPresenter,
        );

        verify(() => configurationsPresenter.updateUsersData(
              loadLocally: true,
            )).called(1);
      });
    });

    group("Update enterprise parameters", () {
      test("Should load remote if export is newer than last import", () async {
        lastImport.mockLoad(LastImportEntity(
          products: null,
          images: null,
          users: null,
          enterprise: DateTime(2024),
        ));

        loadExportCharging.mockLoad([
          EntityFactory.makeExportChargingEntity(LoadTypeEnum.enterprise,
              date: DateTime(2025))
        ]);

        await sut.updateWhatNeed(
          enterprisePresenter: enterprisePresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          configurationsPresenter: configurationsPresenter,
        );

        verify(() =>
                enterprisePresenter.updateConcentratorEnterpriseParameters())
            .called(1);
      });
      test("Should load remote if last import is null", () async {
        lastImport.mockLoad(LastImportEntity(
          products: null,
          images: null,
          users: null,
          enterprise: null,
        ));

        loadExportCharging.mockLoad([
          EntityFactory.makeExportChargingEntity(LoadTypeEnum.enterprise,
              date: DateTime(2025))
        ]);

        await sut.updateWhatNeed(
          enterprisePresenter: enterprisePresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          configurationsPresenter: configurationsPresenter,
        );

        verify(() =>
                enterprisePresenter.updateConcentratorEnterpriseParameters())
            .called(1);
      });
      test("Should not update enterprise if last import is newer than export",
          () async {
        lastImport.mockLoad(LastImportEntity(
          products: null,
          images: null,
          users: null,
          enterprise: DateTime(2025),
        ));

        loadExportCharging.mockLoad([
          EntityFactory.makeExportChargingEntity(LoadTypeEnum.enterprise,
              date: DateTime(2024))
        ]);

        await sut.updateWhatNeed(
          enterprisePresenter: enterprisePresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          configurationsPresenter: configurationsPresenter,
        );

        verifyNever(
            () => enterprisePresenter.updateConcentratorEnterpriseParameters());
      });
    });
  });

  group("Login", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.newGoToConfigurationsPage(
        configurationsPresenter: configurationsPresenter,
        username: username,
        password: password,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentials]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      concentratorLogin.mockLoginError();

      await sut.newGoToConfigurationsPage(
        configurationsPresenter: configurationsPresenter,
        username: username,
        password: password,
      );
    });
    test("Should emit correct values on login return null value", () async {
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentials]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      concentratorLogin.mockLogin(null);

      await sut.newGoToConfigurationsPage(
        configurationsPresenter: configurationsPresenter,
        username: username,
        password: password,
      );
    });
    test("Should call concentrator login with correct values", () async {
      await sut.newGoToConfigurationsPage(
        configurationsPresenter: configurationsPresenter,
        username: username,
        password: password,
      );

      verify(() =>
              concentratorLogin.login(username: username, password: password))
          .called(1);
    });
    test("Should call go to configurations page", () async {
      await sut.newGoToConfigurationsPage(
        configurationsPresenter: configurationsPresenter,
        username: username,
        password: password,
      );

      verify(() => navigateTo.navigate(pageRoute: PageRoutes.configurations))
          .called(1);
    });
    test("Should update loggedUser in configurations presenter", () async {
      await sut.newGoToConfigurationsPage(
        configurationsPresenter: configurationsPresenter,
        username: username,
        password: password,
      );

      verify(() =>
              configurationsPresenter.updateLoggedUser(userConcentratorEntity))
          .called(1);
    });
  });

  group("Update device informations", () {
    test("Should load application version", () async {
      await sut.updateDeviceInformations();

      verify(() => loadDeviceData.getApplicationVersion()).called(1);
    });

    test("Should load imeiOrWindowsId", () async {
      await sut.updateDeviceInformations();

      verify(() => loadDeviceData.getImeiOrWindowsId(
            isRedeVersion: sut.isGeneratingVersionToRede,
          )).called(1);
    });

    test("Should call add device informations correctly", () async {
      await sut.updateDeviceInformations();

      verify(() => addDeviceInfo.add(
            commandNumber: sut.commandEntity?.commandNumber?.toInt(),
            imeiOrWindowsId: imeiOrWindowsId,
            applicationVersion: applicationVersion.toString(),
            pdvNumber: sut.commandEntity?.pdv?.PdvNumber,
          )).called(1);
    });
  });
}
