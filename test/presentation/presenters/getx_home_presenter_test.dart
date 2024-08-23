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
  late LoadCommandDataSpy localCommandData;
  late UserValidationsSpy userValidations;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late LoadSellersSpy loadSellers;
  late CommandInformationsSpy commandInformations;

  late CommandEntity commandEntity;
  late int newFixedCommandNumber;
  late int userPersonalizedCode;
  late String password;
  late SaleRequestTempEntity saleRequestTempEntity;
  late UpdateSaleRequestTempEntity updateSaleRequestTempEntity;
  late int? peoples;
  late String? sellerCode;
  late List<SellerEntity> sallerEntitys;

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
    );
  }

  void initUsecases() {
    localEnterpriseData = LocalEnterpriseDataSpy();
    navigateTo = NavigateToSpy();
    localCommandData = LoadCommandDataSpy();
    userValidations = UserValidationsSpy();
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    updateSaleRequestTemp = UpdateSaleRequestTempSpy();
    loadSellers = LoadSellersSpy();
    commandInformations = CommandInformationsSpy();
  }

  void initMocks() {
    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    localCommandData.mockLoad(commandEntity);
    localCommandData.mockUpdate();
    loadSaleRequestTemp.mockLoadSaleRequestTemp(saleRequestTempEntity);
    updateSaleRequestTemp.mockUpdateSaleRequestTemp();
    loadSellers.mockLoadSellers(sallerEntitys);
  }

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    commandEntity = EntityFactory.makeCommandEntity();
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

    sallerEntitys = [
      EntityFactory.makeSellerEntity(),
      EntityFactory.makeSellerEntity(),
    ];
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
    registerFallbackValue(EntityFactory.makeCommandEntity());
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
    test('Should go to SplashPage', () async {
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

  group("getLocalCommandData", () {
    test("Should load useFixedCommandNumber on call loadUseFixedCommandNumber",
        () async {
      await sut.getLocalCommandData();

      verify(() => localCommandData.load()).called(1);
    });

    test("Should emit correct values on loadUseFixedCommandNumber", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.getLocalCommandData();
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
      await sut.getLocalCommandData();
      expect(sut.isFixedCommandNumber, true);

      localCommandData.mockLoad(notFixed);
      await sut.getLocalCommandData();
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
      await sut.getLocalCommandData();
      expect(sut.commandNumber, entity1.commandNumber.toString());

      localCommandData.mockLoad(entity2);
      await sut.getLocalCommandData();
      expect(sut.commandNumber, entity2.commandNumber.toString());
    });
  });

  group("load command data", () {
    test("Should call menuPresenter.getGroupsAndProducts on loadCommandData",
        () async {
      await sut.loadCommandData(
        homePresenter: sut,
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
        "Should not call cartPresenter.loadSaleRequest and printedProductsPresenter.loadPrinted when is not fixed command number",
        () async {
      expect(sut.isFixedCommandNumber, false);
      sut.updateCommandNumber("001");

      await sut.loadCommandData(
        homePresenter: sut,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verifyNever(
          () => cartPresenter.loadSaleRequest(sut.commandNumber ?? "001"));
      verifyNever(() => printedProductsPresenter.loadPrinted(sut));
    });
    test(
        "Should  call cartPresenter.loadSaleRequest and printedProductsPresenter.loadPrinted when is fixed command number",
        () async {
      sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber("001");

      await sut.loadCommandData(
        homePresenter: sut,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => cartPresenter.loadSaleRequest(sut.commandNumber!)).called(1);
      verify(() => printedProductsPresenter.loadPrinted(sut)).called(1);
    });
    test(
        "Should emit correct values on cartPresenter.loadSaleRequest throw DomainError.unexpected",
        () async {
      await sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber("001");
      cartPresenter.mockLoadSaleRequestTempError(DomainError.unexpected);

      expectLater(sut.mainErrorStream, emits(UIError.unexpected));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        homePresenter: sut,
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
      sut.updateCommandNumber("001");
      cartPresenter
          .mockLoadSaleRequestTempError(DomainError.commandNotAvailable);

      expectLater(sut.mainErrorStream, emits(UIError.commandNotAvailable));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        homePresenter: sut,
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
      sut.updateCommandNumber("001");
      printedProductsPresenter.mockLoadPrintedError(DomainError.unexpected);

      expectLater(sut.mainErrorStream, emits(UIError.unexpected));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        homePresenter: sut,
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
      sut.updateCommandNumber("001");
      printedProductsPresenter
          .mockLoadPrintedError(DomainError.commandNotAvailable);

      expectLater(sut.mainErrorStream, emits(UIError.commandNotAvailable));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        homePresenter: sut,
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
        homePresenter: sut,
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
        homePresenter: sut,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test("Should call loadSaleRequestTemp", () async {
      await sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        homePresenter: sut,
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
          commandNumber: newFixedCommandNumber.toString(),
        ),
      ).called(1);
    });
    test("Should update peoples number", () async {
      await sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        homePresenter: sut,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.peoples, saleRequestTempEntity.Peoples);
    });

    test("Should call loadSellers", () async {
      await sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        homePresenter: sut,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(() => loadSellers.load()).called(1);
    });

    test("Should update sellers correctly", () async {
      await sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        homePresenter: sut,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.sellers,
          sallerEntitys.map((e) => SellersViewModel.fromEntity(e)).toList());
    });

    test("Should emit correct values on throws", () async {
      loadSellers.mockLoadSellersError();
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        homePresenter: sut,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test("Should call isValidDateTime when is fixed command number", () async {
      await sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber(newFixedCommandNumber.toString());

      await sut.loadCommandData(
        homePresenter: sut,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(
        () => commandInformations.isValidDatetime(
          commandNumber: newFixedCommandNumber.toString(),
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
        homePresenter: sut,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
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
      expect(sut.peoples, null);

      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      expect(sut.peoples, peoples);
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
    test("Should emit correct values", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.openOrBlockadeCommand(
        commandNumber: newFixedCommandNumber,
        isOpen: true,
      );
    });
    test("Should call with correct values", () async {
      bool isOpen = faker.randomGenerator.boolean();

      await sut.openOrBlockadeCommand(
        commandNumber: newFixedCommandNumber,
        isOpen: isOpen,
      );

      verify(() => commandInformations.openOrBlockade(
            commandNumber: newFixedCommandNumber.toString().padLeft(3, "0"),
            isOpen: isOpen,
          )).called(1);
    });
  });
}
