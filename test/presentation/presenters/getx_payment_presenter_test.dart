import 'dart:convert';

import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/helpers/app_platform.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/presentation/protocols/protocols.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

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

  late RedePaySpy redePay;
  late GetnetPaySpy getnetPay;
  late CieloPaySpy cieloPay;
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
  late CouponFiscalNumberSpy couponFiscalNumber;
  late LoadUseUrlSatSharingSpy loadUseUrlSatSharing;
  late DeleteSaleRequestSpy deleteSaleRequest;
  late ValidateCpfCnpjSpy validateCpfCnpj;

  late double longAmountValue;
  late int portionQuantity;
  late PrintedEntity printedEntity;
  late String commandNumber;
  late dynamic authorizationSoapResponse;
  late dynamic xmlSoapResponseGeneratedByBs;
  late double totalLiquidMocked;
  late int lastCouponNumber;
  late String xmlGeneratedLocally;

  late List<CustomerEntity> customersEntitys;
  late List<CustomerViewModel> customersViewModel;

  initUseCases() {
    redePay = RedePaySpy();
    getnetPay = GetnetPaySpy();
    cieloPay = CieloPaySpy();
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
    couponFiscalNumber = CouponFiscalNumberSpy();
    loadUseUrlSatSharing = LoadUseUrlSatSharingSpy();
    deleteSaleRequest = DeleteSaleRequestSpy();
    validateCpfCnpj = ValidateCpfCnpjSpy();
  }

  initPresenters() {
    sut = GetxPaymentPresenter(
      redePay: redePay,
      getnetPay: getnetPay,
      cieloPay: cieloPay,
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
      couponFiscalNumber: couponFiscalNumber,
      loadUseUrlSatSharing: loadUseUrlSatSharing,
      deleteSaleRequest: deleteSaleRequest,
      validateCpfCnpj: validateCpfCnpj,
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
    customersEntitys = EntityFactory.makeCustomersEntitys();
    customersViewModel =
        customersEntitys.map((e) => CustomerViewModel.fromEntity(e)).toList();
    authorizationSoapResponse = faker.randomGenerator.string(10);
    totalLiquidMocked = faker.randomGenerator.decimal();
    xmlSoapResponseGeneratedByBs = faker.randomGenerator.string(10);
    lastCouponNumber = faker.randomGenerator.integer(100);
    xmlGeneratedLocally = faker.randomGenerator.string(10);
  }

  mockSuccess() {
    redePay.mockPay();
    loadPrintedProducts.mockLoadPrintedEntity(printedEntity);
    barcodeScanner.mockRead(commandNumber);
    homePresenter.mockLoadCommandData();
    loadCustomer.mockLoadCustomer(
      json.encode(customersEntitys
          .map((e) => CustomerViewModel.fromEntity(e).toJson())
          .toList()),
    );
    covenantLimit.mockAuthorizeCovenantLimitUseByCodeAndGetAuthorizeCode(
        authorizationSoapResponse);
    checkPasswordByCustomerCode.mockCheck(authorizationSoapResponse);
    printedProductsPresenter.mockGetTotalLiquid(totalLiquidMocked);
    generateXmlForNfce.mockGenerate(xmlGeneratedLocally);
    sendSaleMovementAsNfce.mockSend(xmlSoapResponseGeneratedByBs);
    concInsertSaleMovement.mockInsert(1);
    couponFiscalNumber.mockLoad(lastCouponNumber);
    validateCpfCnpj.mockIsValid(true);
  }

  setUp(() {
    activePlatform = AppPlatform.rede;
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(
      const PayParamsModel(
        longAmountValue: 0,
        portionQuantity: 0,
        paymentMode: PaymentMode.credit,
      ),
    );
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    for (var mode in PaymentMode.values) {
      registerFallbackValue(mode);
    }
    for (var channel in Channels.values) {
      registerFallbackValue(channel);
    }

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
    registerFallbackValue(EntityFactory.makePrintedEntity());
  });

  group("Rede payment", () {
    test('Should call payment correctly with pix', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
      );

      verify(() => redePay.pay(
            PayParamsModel(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
              paymentMode: PaymentMode.pix,
            ),
          )).called(1);
    });
    test('Should call payment correctly with debit', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.debit,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
      );

      verify(() => redePay.pay(
            PayParamsModel(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
              paymentMode: PaymentMode.debit,
            ),
          )).called(1);
    });
    test('Should call payment correctly with credit', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.credit,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
      );

      verify(() => redePay.pay(
            PayParamsModel(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
              paymentMode: PaymentMode.credit,
            ),
          )).called(1);
    });
    test('Should call payment correctly with voucher', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.voucher,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
      );

      verify(() => redePay.pay(
            PayParamsModel(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
              paymentMode: PaymentMode.voucher,
            ),
          )).called(1);
    });
    test('Should convert amountValue correctly', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: 280.001,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
      );

      verify(() => redePay.pay(
            PayParamsModel(
              longAmountValue: 28000,
              portionQuantity: portionQuantity,
              paymentMode: PaymentMode.pix,
            ),
          )).called(1);
    });
    test('Should not call is is not generating version to rede', () async {
      activePlatform = AppPlatform.tablet;

      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
      );

      verifyNever(() => redePay.pay(
            PayParamsModel(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
              paymentMode: PaymentMode.pix,
            ),
          ));
    });
    test('Should emit correct values on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
      );
    });
    test('Should emit correct values on throws unexpected', () async {
      redePay.mockPayError(DomainError.unexpected);
      activePlatform = AppPlatform.rede;

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
      );
    });
    test('Should emit correct values on throws blockedCommand', () async {
      redePay.mockPayError(DomainError.blockedCommand);
      activePlatform = AppPlatform.rede;

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.blockedCommand]));

      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
      );
    });

    test('Should call isValidDatetime', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
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
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
      );
    });
    test('Should not call to do payment when is invalid datetime', () async {
      commandInformations.mockIsValidDateTime(false);

      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
      );

      verifyNever(() => redePay.pay(
            PayParamsModel(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
              paymentMode: PaymentMode.pix,
            ),
          ));
    });
    test('Should update lastRequestedPaymentAmount correctly', () async {
      await sut.callPayment(
        homePresenter: homePresenter,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
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
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      concInsertSaleMovement.mockInsertError();
      printedProductsPresenter.mockGetTotalLiquid(0);

      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );
    });
    test(
        "Should call concInsertSaleMovement with correct values if commandEntity.pdv is not null",
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
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => concInsertSaleMovement.insert(
            commandNumber:
                homePresenter.commandEntityController!.commandNumber!.toInt(),
            pdvId: homePresenter.commandEntityController!.pdv!.PdvId!,
            pdvNumber: homePresenter.commandEntityController!.pdv!.PdvNumber!,
            covenantCode: null,
            customerCode: null,
            cpfCnpj: sut.cpfCnpj?.toString(),
            incrementType: 1,
            incrementValue: totalLiquidMocked,
            totalLiquid: totalLiquidMocked,
            couponFiscalNumber: sut.couponNumber ?? 1,
            finalizations:
                sut.successfulPayments.map((e) => e.toEntity()).toList(),
            products: printedProductsPresenter.printed!.Products,
            xmlToGenerateFiscal: xmlSoapResponseGeneratedByBs,
          ));
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
        showErrorMessageReturnedByBs: (error) {},
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
        showErrorMessageReturnedByBs: (error) {},
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
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      expect(sut.successfulPayments, []);
    });
    test("Should clear last requested paymento amount", () async {
      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      expect(sut.lastRequestedPaymentFinalization, null);
    });

    test("Should load use url sat sharing", () async {
      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => loadUseUrlSatSharing.getUse(sut.cpfCnpj)).called(1);
    });
    test("Should generate xml for nfce if is not using sharing sat", () async {
      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      final incrementValue = printedProductsPresenter
          .getServiceChargeValue(printedProductsPresenter.printed);
      final printed =
          PrintedModel.fromViewModel(printedProductsPresenter.printed!)
              .toEntity();

      verify(() => generateXmlForNfce.generate(
            printed: printed,
            finalizations: sut.successfulPayments,
            customer: sut.selectedCustomer?.customer.toEntity(),
            cpfCnpj: sut.cpfCnpj,
            pdvNumber:
                homePresenter.commandEntityController?.pdv?.PdvNumber?.toInt(),
            incrementValue: incrementValue,
            couponFiscalNumber: sut.couponNumber ?? 1,
          )).called(1);
    });
    test("Should not generate xml for nfce if is using sharing sat", () async {
      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      loadUseUrlSatSharing.mockUse(true);

      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      final incrementValue = printedProductsPresenter
          .getServiceChargeValue(printedProductsPresenter.printed);
      final printed =
          PrintedModel.fromViewModel(printedProductsPresenter.printed!)
              .toEntity();

      verifyNever(() => generateXmlForNfce.generate(
            printed: printed,
            finalizations: sut.successfulPayments,
            customer: null,
            cpfCnpj: null,
            pdvNumber:
                homePresenter.commandEntityController?.pdv?.PdvNumber?.toInt(),
            incrementValue: incrementValue,
            couponFiscalNumber: sut.couponNumber ?? 1,
          ));
    });
    test("Should load last command number if is null", () async {
      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => couponFiscalNumber.loadLastNumber()).called(1);
    });
    test("Should update last command number if is null", () async {
      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      expect(sut.couponNumber, lastCouponNumber + 1);
    });
    test(
        "Should call update next liquidate with correct sequence of coupon number",
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
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      expect(sut.couponNumber, lastCouponNumber + 1);
    });
    test("Should call send sale movement as nfce", () async {
      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => sendSaleMovementAsNfce.send(xmlGeneratedLocally)).called(1);
    });
    test("Should not continue if send sale movement as nfce return error",
        () async {
      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      sendSaleMovementAsNfce.mockSend(faker.randomGenerator.string(10));

      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verifyNever(
        () => printedProductsPresenter
            .getServiceChargeValue(EntityFactory.makePrintedViewModel()),
      );
    });
    test("Should insert sale movement in concentrator", () async {
      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => concInsertSaleMovement.insert(
            commandNumber:
                homePresenter.commandEntityController!.commandNumber!.toInt(),
            pdvId: homePresenter.commandEntityController!.pdv!.PdvId!,
            pdvNumber: homePresenter.commandEntityController!.pdv!.PdvNumber!,
            covenantCode: null,
            customerCode: null,
            cpfCnpj: null,
            incrementType: 1,
            incrementValue: totalLiquidMocked,
            totalLiquid: totalLiquidMocked,
            couponFiscalNumber: sut.couponNumber ?? 1,
            finalizations:
                sut.successfulPayments.map((e) => e.toEntity()).toList(),
            products: printedProductsPresenter.printed!.Products,
            xmlToGenerateFiscal: xmlSoapResponseGeneratedByBs,
          ));
    });
    test("Should save last coupon number locally", () async {
      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => couponFiscalNumber.save(sut.couponNumber ?? 1)).called(1);
    });
    test("Should delete sale request", () async {
      sut.successfulPayments.add(
        ConcentratorFinalizationModel(
          FinalizationId: faker.randomGenerator.integer(100),
          Value: totalLiquidMocked,
          ValueLiquid: totalLiquidMocked,
          PortionQuantity: faker.randomGenerator.integer(100),
        ),
      );

      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => deleteSaleRequest
          .delete(printedProductsPresenter.printed!.SaleRequestId!.toInt()));
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

      loadCustomer.mockLoadCustomer("response");
      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: faker.randomGenerator.string(10));
    });
    test("Should emit correct values on throws", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.custom("error")]),
      );

      loadCustomer.mockError("error");
      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: faker.randomGenerator.string(10));
    });
    test("Should call loadCustomer with correct values", () async {
      final valueToSearch = faker.randomGenerator.string(100);
      final searchByPersonalizedCode = faker.randomGenerator.boolean();

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: searchByPersonalizedCode,
          showErrorMessageReturnedByBs: (_) {},
          value: valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchByPersonalizedCode: searchByPersonalizedCode,
        ),
      ).called(1);
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
      int newValue = faker.randomGenerator.integer(100);
      await sut.updateSelectedCustomer(customersViewModel[0], newValue);

      expect(
        sut.selectedCustomer,
        SelectedCustomerModel(
          customer: CustomerModel.fromViewModel(customersViewModel[0]),
          covenantCode: newValue,
        ),
      );

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: "any");

      expect(sut.selectedCustomer, null);
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
      int newValue = faker.randomGenerator.integer(100);
      await sut.updateSelectedCustomer(customersViewModel[0], newValue);

      expect(
          sut.selectedCustomer,
          SelectedCustomerModel(
              customer: CustomerModel.fromViewModel(customersViewModel[0]),
              covenantCode:
                  newValue) /* 
      {
        customersViewModel[0].Code: newValue,
      } */
          );
    });
    test("Should clear authorizationPendingModel", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      expect(sut.authorizationPendingModel, null);
    });

    test("Should clear selectedCovenant when customer is null", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(10),
      );
      await sut.updateSelectedCustomer(null, faker.randomGenerator.integer(10));

      expect(sut.selectedCustomer, null);
    });
  });

  group("Finish sale request by covenant", () {
    test("Should emit correct values on success", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

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
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

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
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      concInsertSaleMovement.mockInsertError();

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      final payment = sut.successfulPayments[0];
      expect(payment.FinalizationId, FinalizationType.covenant.id);
      expect(payment.Value, totalLiquidMocked);
      expect(payment.ValueLiquid, totalLiquidMocked);
      expect(payment.PortionQuantity, 1);
      expect(payment.AuthorizationCode, authorizationSoapResponse);
      expect(payment.AuthorizationType, 2);
      expect(sut.successfulPayments.length, 1);
    });

    test("Should call authorize covenant limit use by code", () async {
      int covenantCode = faker.randomGenerator.integer(100);
      await sut.updateSelectedCustomer(customersViewModel[0], covenantCode);

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
      int covenantCode = faker.randomGenerator.integer(100);
      await sut.updateSelectedCustomer(customersViewModel[0], covenantCode);

      covenantLimit.mockError();

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
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      concInsertSaleMovement.mockInsertError();

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
            code: authorizationSoapResponse, isPending: true),
      );
    });

    test("Should call checkPasswordByCustomerCode", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
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
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
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
      int covenantCode = faker.randomGenerator.integer(100);
      await sut.updateSelectedCustomer(customersViewModel[0], covenantCode);

      checkPasswordByCustomerCode.mockError();

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
          value: printedProductsPresenter.printedProductsMock.TotalLiquid!
              .toDouble(),
        ),
      );
    });
    test("Should update authorization pending model correctly", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(10),
      );

      concInsertSaleMovement.mockInsertError();

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
          code: authorizationSoapResponse,
          isPending: true,
        ),
      );
    });

    test("Should clear authorization pending model", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(10),
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
      final covenantCode = faker.randomGenerator.integer(100);
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        covenantCode,
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      final incrementValue = printedProductsPresenter
          .getServiceChargeValue(printedProductsPresenter.printed);
      final totalLiquid = printedProductsPresenter
          .getTotalLiquid(printedProductsPresenter.printed);

      verify(() => concInsertSaleMovement.insert(
            commandNumber:
                homePresenter.commandEntityController!.commandNumber!.toInt(),
            pdvId: homePresenter.commandEntityController!.pdv!.PdvId!,
            pdvNumber: homePresenter.commandEntityController!.pdv!.PdvNumber!,
            covenantCode: covenantCode.toInt(),
            customerCode: customersViewModel[0].Code!.toInt(),
            cpfCnpj: sut.cpfCnpj?.toString(),
            incrementType: 1,
            incrementValue: incrementValue,
            totalLiquid: totalLiquid,
            couponFiscalNumber: sut.couponNumber ?? 1,
            finalizations:
                sut.successfulPayments.map((e) => e.toEntity()).toList(),
            products: printedProductsPresenter.printed!.Products,
            xmlToGenerateFiscal: xmlSoapResponseGeneratedByBs,
          ));
    });
    test(
        "Should not clear authorizationPendingModel and succesfullFinalization on throws",
        () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(10),
      );

      concInsertSaleMovement.mockInsertError();

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
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(10),
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

    test("Shoul load coupon fiscal number if coupon number is null", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verify(() => couponFiscalNumber.loadLastNumber()).called(1);
    });
    test("Shoul update coupon number correctly", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      expect(sut.couponNumber, lastCouponNumber + 1);
    });
    test("Shoul save last coupon number on success", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verify(() => couponFiscalNumber.save(lastCouponNumber + 1)).called(1);
    });

    test("Shoul call sale movement with correct sequence of coupon number",
        () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      expect(sut.couponNumber, lastCouponNumber + 1);
    });

    test("Should call load use sat sharing", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verify(() => loadUseUrlSatSharing.getUse(sut.cpfCnpj)).called(1);
    });

    test("Should generate xml if isnt using sat sharing", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      final incrementValue = printedProductsPresenter
          .getServiceChargeValue(printedProductsPresenter.printed);
      final printed =
          PrintedModel.fromViewModel(printedProductsPresenter.printed!)
              .toEntity();

      verify(() => generateXmlForNfce.generate(
            printed: printed,
            finalizations: sut.successfulPayments,
            customer: sut.selectedCustomer?.customer.toEntity(),
            cpfCnpj: sut.cpfCnpj,
            pdvNumber:
                homePresenter.commandEntityController?.pdv?.PdvNumber?.toInt(),
            incrementValue: incrementValue,
            couponFiscalNumber: sut.couponNumber ?? 1,
          )).called(1);
    });
    test("Should not generate xml if is using sat sharing && cpfCnpj is null",
        () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      loadUseUrlSatSharing.mockUse(true);

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      final incrementValue = printedProductsPresenter
          .getServiceChargeValue(printedProductsPresenter.printed);
      final printed =
          PrintedModel.fromViewModel(printedProductsPresenter.printed!)
              .toEntity();

      verifyNever(() => generateXmlForNfce.generate(
            printed: printed,
            finalizations: sut.successfulPayments,
            customer: sut.selectedCustomer?.customer.toEntity(),
            cpfCnpj: sut.cpfCnpj,
            pdvNumber:
                homePresenter.commandEntityController?.pdv?.PdvNumber?.toInt(),
            incrementValue: incrementValue,
            couponFiscalNumber: sut.couponNumber ?? 1,
          ));
    });

    test("Should send xml as nfce to BS", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verify(() => sendSaleMovementAsNfce.send(xmlGeneratedLocally)).called(1);
    });

    test("Should dont continue if send xml return error", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );
      sendSaleMovementAsNfce.mockSend(faker.randomGenerator.string(10));

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: faker.guid.guid(),
      );

      verifyNever(() => printedProductsPresenter.getServiceChargeValue(
            EntityFactory.makePrintedViewModel(),
          ));
    });
    test("Should delete sale request", () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: faker.guid.guid(),
      );

      verify(() => deleteSaleRequest
          .delete(printedProductsPresenter.printed!.SaleRequestId!.toInt()));
    });
    test(
        "Should call generate Xml for nfce if cpf cnpj is not null && is not using sat sharing",
        () async {
      await sut.updateSelectedCustomer(
        customersViewModel[0],
        faker.randomGenerator.integer(100),
      );

      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: faker.guid.guid(),
      );

      final incrementValue = printedProductsPresenter
          .getServiceChargeValue(printedProductsPresenter.printed);
      final printed =
          PrintedModel.fromViewModel(printedProductsPresenter.printed!)
              .toEntity();

      verify(() => generateXmlForNfce.generate(
            printed: printed,
            finalizations: sut.successfulPayments,
            customer: sut.selectedCustomer?.customer.toEntity(),
            cpfCnpj: sut.cpfCnpj,
            pdvNumber:
                homePresenter.commandEntityController?.pdv?.PdvNumber?.toInt(),
            incrementValue: incrementValue,
            couponFiscalNumber: sut.couponNumber ?? 1,
          ));
    });

    test("Should not try to get a new authorization if has a pendent",
        () async {
      final covenantCode = faker.randomGenerator.integer(100);
      await sut.updateSelectedCustomer(customersViewModel[0], covenantCode);

      couponFiscalNumber.mockSaveError();
      await sut.finishSaleRequestByCovenant(
        showSuccessAndCloseUntilHomePage: () {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      expect(sut.authorizationPendingModel, isNotNull);

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
          covenantCode: covenantCode,
          customerCode: customersViewModel[0].Code!.toInt(),
          value: totalLiquidMocked.toDouble(),
        ),
      ).called(1);
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
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
      );
      expect(sut.lastRequestedPaymentFinalization, isNotNull);

      sut.clearPayments();
      expect(sut.lastRequestedPaymentFinalization, null);
    });
    test("Should clear successfulPayments", () async {
      concInsertSaleMovement.mockInsertError();

      await sut.callPayment(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.credit,
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        showSuccessAndCloseUntilHomePage: () {},
      );

      await sut.liquidateCommand(
        showErrorMessageReturnedByBs: (error) {},
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
        showSuccessAndCloseUntilHomePage: () {},
      );
      expect(sut.successfulPayments, isNotEmpty);

      sut.clearPayments();
      expect(sut.successfulPayments, []);
    });
  });

  group("Change cpf cnpj", () {
    test("Should set cpfCnpj to null value if is not a int value", () {
      sut.changeCpfCnpj(faker.randomGenerator.decimal().toString());

      expect(sut.cpfCnpj, null);
    });
    test("Should call validateCpfCnpj usecase if is a int value", () {
      final value = faker.randomGenerator.integer(100).toString();
      sut.changeCpfCnpj(value);

      verify(() => validateCpfCnpj.isValid(value)).called(1);
    });
    test("Should not update cpfCnpj if usecase return false", () {
      validateCpfCnpj.mockIsValid(false);

      sut.changeCpfCnpj(faker.randomGenerator.integer(100).toString());

      expect(sut.cpfCnpj, null);
    });
    test("Should update cpfCnpj if usecase return true", () {
      final value = faker.randomGenerator.integer(100).toString();

      sut.changeCpfCnpj(value);

      expect(sut.cpfCnpj, value.toInt());
    });
  });
}
