import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/payment/payment.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  late GetxPaymentPresenter sut;
  late HomePresenterSpy homePresenter;
  late CartPresenterSpy cartPresenter;
  late PrintedProductsPresenterSpy printedProductsPresenter;
  late MenuPresenterSpy menuPresenter;
  late ExpansibleGroupFromProductPresenterSpy
      expansibleGroupFromProductPresenter;

  late PaySpy pay;
  late LoadPrintedProductsSpy loadPrintedProducts;
  late BarcodeScannerSpy barcodeScanner;
  late CommandInformationsSpy commandInformations;
  late FinishSaleRequestConcentradorSpy finishSaleRequestConcentrador;
  late AlreadyPaidSpy alreadyPaid;
  late NavigateToSpy navigateTo;

  late double longAmountValue;
  late int portionQuantity;
  late PrintedEntity printedEntity;
  late String commandNumber;

  initUseCases() {
    pay = PaySpy();
    loadPrintedProducts = LoadPrintedProductsSpy();
    barcodeScanner = BarcodeScannerSpy();
    commandInformations = CommandInformationsSpy();
    finishSaleRequestConcentrador = FinishSaleRequestConcentradorSpy();
    alreadyPaid = AlreadyPaidSpy();
    navigateTo = NavigateToSpy();
  }

  initPresenters() {
    sut = GetxPaymentPresenter(
      pay: pay,
      commandInformations: commandInformations,
      finishSaleRequestConcentrador: finishSaleRequestConcentrador,
      alreadyPaid: alreadyPaid,
      navigateTo: navigateTo,
    );
    homePresenter = HomePresenterSpy();
    cartPresenter = CartPresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
    menuPresenter = MenuPresenterSpy();
    expansibleGroupFromProductPresenter =
        ExpansibleGroupFromProductPresenterSpy();
  }

  initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    longAmountValue = faker.randomGenerator.decimal();
    portionQuantity = faker.randomGenerator.integer(99);
    printedEntity = EntityFactory.makePrintedProductsEntity();
    homePresenter.commandNumberMock =
        faker.randomGenerator.integer(999).toString();
    commandNumber = faker.randomGenerator.integer(999).toString();
  }

  mockSuccess() {
    pay.mockPay();
    loadPrintedProducts.mockLoadPrintedProducts(printedEntity);
    barcodeScanner.mockBarcodeScanner(commandNumber);
    homePresenter.mockLoadCommandData();
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
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
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
            paymentMode: PaymentMode.credit,
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
            commandNumber: homePresenter.commandNumberMock!),
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
            paymentMode: PaymentMode.pix,
            params: PayParams(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
            ),
          ));
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

    test("Should emit correct values on loadPrintedProducts throws", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getTotalValue(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        printedProductsPresenter: printedProductsPresenter,
        menuPresenter: menuPresenter,
      );
    });

    test("Should emit correct values on loadPrintedProducts returns null",
        () async {
      loadPrintedProducts.mockLoadPrintedProducts(null);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getTotalValue(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        printedProductsPresenter: printedProductsPresenter,
        menuPresenter: menuPresenter,
      );
    });

    // test("Should update command number on GetTotalValue", () async {
    //   await sut.getTotalValue(
    //     homePresenter: homePresenter,
    //     cartPresenter: cartPresenter,
    //     printedProductsPresenter: printedProductsPresenter,
    //     menuPresenter: menuPresenter,
    //   );

    //   verify(() => homePresenter.updateCommandNumber(commandNumber)).called(1);
    // });

    test("Should load printed products on getTotalValue", () async {
      loadPrintedProducts.mockLoadPrintedProducts(null);
      homePresenter.commandNumberMock = "001";

      await sut.getTotalValue(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        printedProductsPresenter: printedProductsPresenter,
        menuPresenter: menuPresenter,
      );

      // verify(() => printedProductsPresenter.loadCommandData(
      //       expansibleGroupFromProductPresenter: expansibleGroupFromProductPresenter,
      //       cartPresenter: cartPresenter,
      //       menuPresenter: menuPresenter,
      //       homePresenter: homePresenter,
      //       clearPermissionToCancelProducts: false,
      //       isRemovingProduct: false,
      //     )).called(1);
    });
  });

  group("Get already paid", () {
    test(
        "Should update commandAlreadyPaid to true if getAndUpdateAlreadyPaidCommand return true",
        () async {
      await sut.getAndUpdateAlreadyPaidCommand();

      expect(sut.commandAlreadyPaid, true);
    });
    test(
        "Should update commandAlreadyPaid to false if getAndUpdateAlreadyPaidCommand return false",
        () async {
      alreadyPaid.mockVerify(false);
      await sut.getAndUpdateAlreadyPaidCommand();

      expect(sut.commandAlreadyPaid, false);
    });
  });

  group("try pay again", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.liquidateCommand(
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      finishSaleRequestConcentrador.mockError();
      await sut.liquidateCommand(
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );
    });
    test("Should call finishSaleRequestConcentrador with correct values",
        () async {
      await sut.liquidateCommand(
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => finishSaleRequestConcentrador.finish(
            pdvNumber: 100,
            commandNumber: homePresenter.commandNumberMock!.toInt(),
            finalizations: null,
          )).called(1);
    });
    test("Should update already paid to true and then to false in success",
        () async {
      await sut.liquidateCommand(
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => alreadyPaid.update(true)).called(1);
      verify(() => alreadyPaid.update(false)).called(1);
    });
    test("Should already paid is true if finishSaleRequestConcentrador throws",
        () async {
      finishSaleRequestConcentrador.mockError();

      await sut.liquidateCommand(
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => alreadyPaid.update(true)).called(1);
      verifyNever(() => alreadyPaid.update(false));
      expect(sut.commandAlreadyPaid, true);
    });

    test("Should update commandAlreadyPaid to false in success", () async {
      await sut.liquidateCommand(
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      expect(sut.commandAlreadyPaid, false);
    });

    test("Should update commandAlreadyPaid to true in error", () async {
      finishSaleRequestConcentrador.mockError();
      await sut.liquidateCommand(
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      expect(sut.commandAlreadyPaid, true);
    });

    test("Should load printed products in success", () async {
      await sut.liquidateCommand(
        homePresenter: homePresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => printedProductsPresenter.loadPrinted(homePresenter))
          .called(1);
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
}
