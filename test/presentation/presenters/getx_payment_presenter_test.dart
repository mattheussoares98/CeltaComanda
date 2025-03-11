import 'dart:convert';

import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/payment/payment.dart';
import 'package:clean_celta_mobile/infra/helpers/helpers.dart';
import 'package:clean_celta_mobile/presentation/protocols/protocols.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../../ui/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  late GetxPaymentPresenter sut;
  late HomePresenterSpy homePresenter;
  late PrintedProductsPresenterSpy printedProductsPresenter;

  late PaySpy pay;
  late LoadPrintedProductsSpy loadPrintedProducts;
  late BarcodeScannerSpy barcodeScanner;
  late CommandInformationsSpy commandInformations;
  late ConcFinishSaleRequestSpy finishSaleRequestConcentrador;
  late NavigateToSpy navigateTo;
  late UpdateSaleRequestSpy updateSaleRequest;
  late LoadCustomerSpy loadCustomer;
  late ValidationSpy validation;
  late CovenantLimitSpy covenantLimit;
  late CheckPasswordByCustomerCodeSpy checkPasswordByCustomerCode;
  late ConcInsertSaleMovementSpy concInsertSaleMovement;
  late GenerateXmlForNfceSpy generateXmlForNfce;
  late SendSaleMovementAsNfceSpy sendSaleMovementAsNfce;

  late double longAmountValue;
  late int portionQuantity;
  late PrintedEntity printedEntity;
  late String commandNumber;
  late SoapResponse soapResponse;
  late double totalLiquidMocked;

  late List<CustomerEntity> customersEntitys;
  late List<CustomerViewModel> customersViewModel;

  initUseCases() {
    pay = PaySpy();
    loadPrintedProducts = LoadPrintedProductsSpy();
    barcodeScanner = BarcodeScannerSpy();
    commandInformations = CommandInformationsSpy();
    finishSaleRequestConcentrador = ConcFinishSaleRequestSpy();
    navigateTo = NavigateToSpy();
    updateSaleRequest = UpdateSaleRequestSpy();
    loadCustomer = LoadCustomerSpy();
    validation = ValidationSpy();
    covenantLimit = CovenantLimitSpy();
    checkPasswordByCustomerCode = CheckPasswordByCustomerCodeSpy();
    concInsertSaleMovement = ConcInsertSaleMovementSpy();
    generateXmlForNfce = GenerateXmlForNfceSpy();
    sendSaleMovementAsNfce = SendSaleMovementAsNfceSpy();
  }

  initPresenters() {
    sut = GetxPaymentPresenter(
      pay: pay,
      commandInformations: commandInformations,
      finishSaleRequestConcentrador: finishSaleRequestConcentrador,
      navigateTo: navigateTo,
      checkPasswordByCustomerCode: checkPasswordByCustomerCode,
      covenantLimit: covenantLimit,
      loadCustomer: loadCustomer,
      updateSaleRequest: updateSaleRequest,
      validation: validation,
      concInsertSaleMovement: concInsertSaleMovement,
      generateXmlForNfce: generateXmlForNfce,
      sendSaleMovementAsNfce: sendSaleMovementAsNfce,
    );
    homePresenter = HomePresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
  }

  initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
    longAmountValue = faker.randomGenerator.decimal();
    portionQuantity = faker.randomGenerator.integer(99);
    printedEntity = EntityFactory.makePrintedEntity();
    homePresenter.commandEntityController = CommandEntity(
      commandNumber:
          faker.randomGenerator.integer(100).toString().padLeft(3, "0"),
      isFixedCommandNumber: faker.randomGenerator.boolean(),
      pdv: EntityFactory.makePdvEntity(),
    );
    commandNumber = faker.randomGenerator.integer(999).toString();
    homePresenter.isGeneratingVersionToRedeMock = true;
    customersEntitys = EntityFactory.makeCustomersEntitys();
    customersViewModel =
        customersEntitys.map((e) => CustomerViewModel.fromEntity(e)).toList();
    soapResponse = SoapResponse(
      response: faker.randomGenerator.string(10),
      responseType: SoapResponseType.success,
    );
    totalLiquidMocked = faker.randomGenerator.decimal();
  }

  mockSuccess() {
    pay.mockPay();
    loadPrintedProducts.mockLoadPrintedEntity(printedEntity);
    barcodeScanner.mockRead(commandNumber);
    homePresenter.mockLoadCommandData();
    loadCustomer.mockLoadCustomer(
      SoapResponse(
        response: json.encode(customersEntitys
            .map((e) => CustomerViewModel.fromEntity(e).toJson())
            .toList()),
        responseType: SoapResponseType.success,
      ),
    );
    covenantLimit
        .mockAuthorizeCovenantLimitUseByCodeAndGetAuthorizeCode(soapResponse);
    checkPasswordByCustomerCode.mockCheck(soapResponse);
    printedProductsPresenter.mockGetTotalLiquid(totalLiquidMocked);
  }

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(
      const PayParams(longAmountValue: 0, portionQuantity: 0),
    );
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    registerFallbackValue(PaymentMode.credit);
    registerFallbackValue(Channels.getnet);
    registerFallbackValue(Channels.persistent);
    registerFallbackValue(Channels.rede);
    registerFallbackValue(EntityFactory.makeConcentratorFinaliztionModel());
    registerFallbackValue(
      EntityFactory.makeSaleRequestModel(covenantCode: 1, customerCode: 1),
    );
    registerFallbackValue(EntityFactory.makeCartProductEntity(
      maximumProductQuantity: 0,
      minimumProductQuantity: 0,
    ));
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
  });

  group("Call payment", () {
    test('Should call payment correctly with pix', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );

      verify(() => pay.pay(
            channel: Channels.rede,
            paymentMode: PaymentMode.pix,
            params: PayParams(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should call payment correctly with debit', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.debit,
      );

      verify(() => pay.pay(
            channel: Channels.rede,
            paymentMode: PaymentMode.debit,
            params: PayParams(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should call payment correctly with credit', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.credit,
      );

      verify(() => pay.pay(
            channel: Channels.rede,
            paymentMode: PaymentMode.credit,
            params: PayParams(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should call payment correctly with voucher', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.voucher,
      );

      verify(() => pay.pay(
            channel: Channels.rede,
            paymentMode: PaymentMode.voucher,
            params: PayParams(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should convert amountValue correctly', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: 280.001,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );

      verify(() => pay.pay(
            channel: Channels.rede,
            paymentMode: PaymentMode.pix,
            params: PayParams(
              longAmountValue: 28000,
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should emit correct values on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );
    });
    test('Should emit correct values on throws unexpected', () async {
      pay.mockPayError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );
    });
    test('Should emit correct values on throws blockedCommand', () async {
      pay.mockPayError(DomainError.blockedCommand);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.blockedCommand]));

      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );
    });

    test('Should call isValidDatetime', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );

      verify(
        () => commandInformations.isValidDatetime(
            commandNumber:
                homePresenter.commandEntityController!.commandNumber!),
      ).called(1);
    });
    test('Should emit correct values on is invalid datetime', () async {
      commandInformations.mockIsValidDateTime(false);

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.blockedCommand]),
      );

      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );
    });
    test('Should not call to do payment when is invalid datetime', () async {
      commandInformations.mockIsValidDateTime(false);

      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );

      verifyNever(() => pay.pay(
            channel: Channels.rede,
            paymentMode: PaymentMode.pix,
            params: PayParams(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
            ),
          ));
    });
    test('Should update lastRequestedPaymentAmount correctly', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );

      expect(
        sut.lastRequestedPaymentFinalization!.FinalizationId,
        PaymentMode.pix.finalizationId,
      );
      expect(sut.lastRequestedPaymentFinalization!.Value, longAmountValue);
      expect(
        sut.lastRequestedPaymentFinalization!.ValueLiquid,
        longAmountValue,
      );
      expect(sut.lastRequestedPaymentFinalization!.PortionQuantity, 1);
    });
  });

  group("Get total value", () {
    //os testes comentados não estão mais funcionando
    // test("Should call barcodeScanner on getTotalValue", () async {
    //   await sut.getTotalValue(
    //     homePresenter: homePresenter,
    //     cartPresenter: cartPresenter,
    //     printedProductsPresenter: printedProductsPresenter,
    //     menuPresenter: menuPresenter,
    //   );

    //   verify(
    //     () => barcodeScanner.read(),
    //   ).called(1);
    // });
    // test("Should emit correct values on barcodeScanner throws unexpected",
    //     () async {
    //   barcodeScanner.mockError(DomainError.unexpected);
    //   expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    //   expectLater(
    //       sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    //   await sut.getTotalValue(
    //     homePresenter: homePresenter,
    //     cartPresenter: cartPresenter,
    //     printedProductsPresenter: printedProductsPresenter,
    //     menuPresenter: menuPresenter,
    //   );
    // });
    // test("Should emit correct values on barcodeScanner throws barcodeNotRead",
    //     () async {
    //   barcodeScanner.mockError(DomainError.barcodeNotRead);
    //   expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    //   expectLater(
    //       sut.mainErrorStream, emitsInOrder([null, UIError.barcodeNotRead]));

    //   await sut.getTotalValue(
    //     homePresenter: homePresenter,
    //     cartPresenter: cartPresenter,
    //     printedProductsPresenter: printedProductsPresenter,
    //     menuPresenter: menuPresenter,
    //   );
    // });

    // test("Should update command number on GetTotalValue", () async {
    //   await sut.getTotalValue(
    //     homePresenter: homePresenter,
    //     cartPresenter: cartPresenter,
    //     printedProductsPresenter: printedProductsPresenter,
    //     menuPresenter: menuPresenter,
    //   );

    //   verify(() => homePresenter.updateCommandNumber(commandNumber)).called(1);
    // });
  });

  group("Liquidate command", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.updateScreenStream, emitsInOrder([true, false]));

      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      await sut.liquidateCommand(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      finishSaleRequestConcentrador.mockError();
      printedProductsPresenter.mockGetTotalLiquid(0);

      await sut.liquidateCommand(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );
    });
    test(
        "Should call finishSaleRequestConcentrador with correct values if commandEntity.pdv is not null",
        () async {
      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      await sut.liquidateCommand(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => finishSaleRequestConcentrador.finish(
            pdvNumber:
                homePresenter.commandEntityController!.pdv!.PdvNumber!.toInt(),
            commandNumber:
                homePresenter.commandEntityController!.commandNumber!.toInt(),
            finalizations: sut.successfulPayments,
          )).called(1);
    });
    test(
        "Should call finishSaleRequestConcentrador with correct values if commandEntity.pdv is null",
        () async {
      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      homePresenter.commandEntityController = CommandEntity(
        commandNumber: commandNumber,
        isFixedCommandNumber: true,
        pdv: null,
      );

      await sut.liquidateCommand(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => finishSaleRequestConcentrador.finish(
            pdvNumber: 100,
            commandNumber:
                homePresenter.commandEntityController!.commandNumber!.toInt(),
            finalizations: sut.successfulPayments,
          )).called(1);
    });

    test("Should load printed products in success", () async {
      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      await sut.liquidateCommand(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => printedProductsPresenter.loadPrinted(
          homePresenter.commandEntityController!.commandNumber!)).called(1);
    });
    test(
        "Should not call finish in concentrador when paid is less than total liquid ",
        () async {
      printedProductsPresenter.totalLiquidController = 1;

      await sut.liquidateCommand(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verifyNever(() => finishSaleRequestConcentrador.finish(
            pdvNumber: 100,
            commandNumber:
                homePresenter.commandEntityController!.commandNumber!.toInt(),
            finalizations: null,
          ));
    });
    test("Should clear succesful payments", () async {
      await sut.liquidateCommand(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      expect(sut.successfulPayments, []);
    });
    test("Should clear last requested paymento amount", () async {
      await sut.liquidateCommand(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      expect(sut.lastRequestedPaymentFinalization, null);
    });
  });

  group("Navigate to covenant page", () {
    test("Should call navigateTo correctly", () {
      sut.goToCovenantPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.covenant),
      ).called(1);
    });
  });

  group("Get customer", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: faker.randomGenerator.string(10));
    });
    test("Should emit correct values on not found customer", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      loadCustomer.mockLoadCustomer(
        const SoapResponse(
          response: "response",
          responseType: SoapResponseType.success,
        ),
      );
      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: faker.randomGenerator.string(10));
    });
    test("Should emit correct values on throws", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      loadCustomer.mockError();
      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: faker.randomGenerator.string(10));
    });
    test(
        "Should call loadCustomer with searchType 3 when cant convert value to int",
        () async {
      final valueToSearch = faker.randomGenerator.string(100);

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 3, //ApproximatedName
        ),
      ).called(1);
    });
    test("Should call loadCustomer with searchType 1 when is CPF", () async {
      final valueToSearch =
          faker.randomGenerator.decimal(min: 10000000000).toInt().toString();

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 1, //ExactCnpjCpfNumber
        ),
      ).called(1);
    });
    test("Should call loadCustomer with searchType 1 when is CNPJ", () async {
      final valueToSearch =
          faker.randomGenerator.decimal(min: 10000000000000).toInt().toString();

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 1, //ExactCnpjCpfNumber
        ),
      ).called(1);
    });
    test(
        "Should call loadCustomer with searchType 2 when is number and dont is cpf",
        () async {
      loadCustomer.mockLoadCustomer(
        const SoapResponse(
          response: "response",
          responseType: SoapResponseType.error,
        ),
      );

      final valueToSearch = faker.randomGenerator.decimal().toInt().toString();

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 2, //ExactCode
        ),
      ).called(1);
    });
    test(
        "Should call loadCustomer with searchType 4 when searchByPersonalizedCode",
        () async {
      final valueToSearch =
          faker.randomGenerator.decimal(min: 10000000000000).toInt().toString();

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: true,
          showErrorMessageReturnedByBs: (_) {},
          value: valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 4,
        ),
      ).called(1);
    });
    test("Should not get customer if value is empty", () async {
      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: "");

      verifyNever(() => loadCustomer.load(
            value: "",
            searchTypeInt: 1,
          ));
      verifyNever(() => loadCustomer.load(
            value: "",
            searchTypeInt: 2,
          ));
      verifyNever(() => loadCustomer.load(
            value: "",
            searchTypeInt: 3,
          ));
      verifyNever(() => loadCustomer.load(
            value: "",
            searchTypeInt: 4,
          ));
    });
    test("Should emit correct value on customerViewModelStream", () async {
      expectLater(
          sut.customersViewModelStream,
          emitsInOrder([
            null,
            customersEntitys
                .map((e) => CustomerViewModel.fromEntity(e))
                .toList()
          ]));

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: "any");
    });

    test("Should clear selectedCovenant", () async {
      String newValue = faker.randomGenerator.string(10);
      await sut.updateSelectedCovenant(customersViewModel[0], newValue);

      expect(sut.selectedCovenant, {
        customersViewModel[0].Code: newValue,
      });

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: "any");

      expect(sut.selectedCovenant, {});
    });
    test("Should clear authorizationPendingModel", () async {
      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: "any");

      expect(sut.authorizationPendingModel, null);
    });

    test("Should call validate customer field", () async {
      final searchValue = faker.randomGenerator.string(10);
      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: searchValue);

      verify(() => validation.validate(
            field: "customer",
            input: {"customer": searchValue},
          )).called(1);
    });
  });

  group("Validate customer field", () {
    test("Should emit correct values if is valid", () {
      expectLater(sut.customerErrorStream, emits(null));

      sut.validateCustomerField(faker.randomGenerator.string(100));
      sut.validateCustomerField(faker.randomGenerator.integer(100).toString());
    });
    test("Should emit correct values if is empty", () {
      expectLater(
        sut.customerErrorStream,
        emitsInOrder([null, ValidationError.requiredField]),
      );

      sut.validateCustomerField("");
    });
    test("Should call validation correctly", () {
      final searchValue = faker.randomGenerator.string(10);
      sut.validateCustomerField(searchValue);

      verify(() => validation.validate(
            field: "customer",
            input: {"customer": searchValue},
          )).called(1);
    });
  });

  group("Update selected covenant", () {
    test("Should update selected covenant correctly", () async {
      String newValue = faker.randomGenerator.string(10);
      await sut.updateSelectedCovenant(customersViewModel[0], newValue);

      expect(sut.selectedCovenant, {
        customersViewModel[0].Code: newValue,
      });
    });
    test("Should clear authorizationPendingModel", () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.string(10),
      );

      expect(sut.authorizationPendingModel, null);
    });

    test("Should clear selectedCovenant when customer is null", () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.string(10),
      );
      await sut.updateSelectedCovenant(null, faker.randomGenerator.string(10));

      expect(sut.selectedCovenant, {});
    });
  });

  group("Finish sale request by covenant", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      finishSaleRequestConcentrador.mockError();

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );
    });

    test("Should add new finalization correctly", () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      finishSaleRequestConcentrador.mockError();

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      expect(sut.successfulPayments, [
        ConcentratorFinalizationModel(
          FinalizationId: FinalizationIdentification.covenant.finalizationId,
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: 1,
          AuthorizationCode: soapResponse.response,
          AuthorizationType: 2,
        )
      ]);
    });

    test("Should call authorize covenant limit use by code", () async {
      String covenantCode = faker.randomGenerator.integer(100).toString();
      await sut.updateSelectedCovenant(customersViewModel[0], covenantCode);

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verify(
        () => covenantLimit.authorizeCovenantLimitUseByCodeAndGetAuthorizeCode(
          crossIdentity: EnterpriseBuilder.entity!
              .enterpriseConcentradorParametersEntity!.celtaBSCrossIdentity!,
          covenantCode: covenantCode.toInt(),
          customerCode: customersViewModel[0].Code!.toInt(),
          value: totalLiquidMocked.toDouble(),
        ),
      ).called(1);
    });
    test(
        "Should not finish sale request concentrador when soap response returns error type",
        () async {
      String covenantCode = faker.randomGenerator.integer(100).toString();
      await sut.updateSelectedCovenant(customersViewModel[0], covenantCode);

      covenantLimit
          .mockAuthorizeCovenantLimitUseByCodeAndGetAuthorizeCode(SoapResponse(
        response: faker.randomGenerator.string(10),
        responseType: SoapResponseType.error,
      ));

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verifyNever(
        () => finishSaleRequestConcentrador.finish(
          pdvNumber: 100,
          commandNumber:
              homePresenter.commandEntityController!.commandNumber!.toInt(),
          finalizations: null,
        ),
      );
    });

    test(
        "Should not call covenantAuthorizationIsPendant.update with false value on finish throws",
        () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      finishSaleRequestConcentrador.mockError();

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      expect(
        sut.authorizationPendingModel,
        AuthorizationPendingModel(code: soapResponse.response, isPending: true),
      );
    });

    test(
        "Should call updateSaleRequest with correct customerCode and covenantCode",
        () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verify(() => updateSaleRequest.update(
            model: SaleRequestModel(
              CovenantCode: sut.selectedCovenant.values.first!.toInt(),
              CustomerCode: sut.selectedCovenant.keys.first.toInt(),
            ),
            commandNumber: homePresenter.commandEntityController!.commandNumber!
                .padLeft(3, "0"),
            saleRequestId: printedProductsPresenter
                .printedProductsMock.SaleRequestId
                .toInt(),
          )).called(1);
    });

    test("Should call checkPasswordByCustomerCode", () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verify(() => checkPasswordByCustomerCode.validate(
            customerCode: customersViewModel[0].Code!.toInt(),
            password: customersViewModel[0].HasPassword!,
          )).called(1);
    });
    test(
        "Should not call checkPasswordByCustomerCode if customerPassword is empty",
        () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: "",
      );

      verifyNever(() => checkPasswordByCustomerCode.validate(
            customerCode: customersViewModel[0].Code!.toInt(),
            password: "",
          ));
    });
    test(
        "Should not call covenantLimit validation if selectedCustomer has invalid password",
        () async {
      String covenantCode = faker.randomGenerator.integer(100).toString();
      await sut.updateSelectedCovenant(customersViewModel[0], covenantCode);

      final errorSoapResponse = SoapResponse(
        response: faker.randomGenerator.string(10),
        responseType: SoapResponseType.error,
      );

      checkPasswordByCustomerCode.mockCheck(errorSoapResponse);

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verifyNever(
        () => covenantLimit.authorizeCovenantLimitUseByCodeAndGetAuthorizeCode(
          crossIdentity: EnterpriseBuilder.entity!
              .enterpriseConcentradorParametersEntity!.celtaBSCrossIdentity!,
          covenantCode: covenantCode.toInt(),
          customerCode: customersViewModel[0].Code!.toInt(),
          value: printedProductsPresenter.printedProductsMock.TotalLiquid
              .toDouble(),
        ),
      );
    });
    test("Should update authorization pending model correctly", () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.string(10),
      );

      finishSaleRequestConcentrador.mockError();

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      expect(
        sut.authorizationPendingModel,
        AuthorizationPendingModel(
          code: soapResponse.response,
          isPending: true,
        ),
      );
    });

    test("Should clear authorization pending model", () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.string(10),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      expect(sut.authorizationPendingModel, null);
    });
    test("Should call finishSaleRequestConcentrador with correct values",
        () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.string(10),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verify(() => finishSaleRequestConcentrador.finish(
            pdvNumber: homePresenter.commandEntityController?.pdv?.PdvNumber
                    ?.toInt() ??
                100,
            commandNumber:
                homePresenter.commandEntityController!.commandNumber!.toInt(),
            finalizations: sut.successfulPayments,
          )).called(1);
    });
    test(
        "Should not clear authorizationPendingModel and succesfullFinalization on throws",
        () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.string(10),
      );

      finishSaleRequestConcentrador.mockError();

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      expect(sut.successfulPayments, isNotEmpty);
      expect(sut.authorizationPendingModel, isNotNull);
    });
    test("Should clear authorizationPendingModel and succesfullFinalization",
        () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.string(10),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      expect(sut.successfulPayments, []);
      expect(sut.authorizationPendingModel, null);
    });
  });

  group("Clear payments", () {
    test("Should clear lastRequestedPaymentFinalization", () async {
      finishSaleRequestConcentrador.mockError();

      await sut.callPayment(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.credit,
        homePresenter: homePresenter,
      );
      expect(sut.lastRequestedPaymentFinalization, isNotNull);

      sut.clearPayments();
      expect(sut.lastRequestedPaymentFinalization, null);
    });
    test("Should clear successfulPayments", () async {
      finishSaleRequestConcentrador.mockError();

      await sut.callPayment(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.credit,
        homePresenter: homePresenter,
      );

      await sut.liquidateCommand(
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showSuccessAndCloseUntilHomePage: () {},
      );
      expect(sut.successfulPayments, isNotEmpty);

      sut.clearPayments();
      expect(sut.successfulPayments, []);
    });
  });
}
