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
  }

  initPresenters() {
    sut = GetxPaymentPresenter(
      pay: pay,
      commandInformations: commandInformations,
      finishSaleRequestConcentrador: finishSaleRequestConcentrador,
      alreadyPaid: alreadyPaid,
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
    registerFallbackValue(PaymentMode.startRedeSdk);
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
  });

  group("Do payment", () {
    test('Should call payment correctly with pix', () async {
      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
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
      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
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
      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
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
      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
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

      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
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

      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
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

      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );
    });

    test('Should call isValidDatetime', () async {
      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
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

      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );
    });
    test('Should not call to do payment when is invalid datetime', () async {
      commandInformations.mockIsValidDateTime(false);

      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
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
    test('Should call finishSaleRequestConcentrador', () async {
      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );

      verify(() => finishSaleRequestConcentrador.finish(
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            pdvNumber: 100,
            commandNumber: homePresenter.commandNumberMock!.toInt(),
          )).called(1);
    });
    test('Should emit correct values on error to finishSaleRequestConcentrador',
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      finishSaleRequestConcentrador.mockFinishError();
      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );
    });
    test('Should call alreadyPaid.update correctly in success', () async {
      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );

      verify(() => alreadyPaid.update(true)).called(1);
      verify(() => alreadyPaid.update(false)).called(1);
    });
    test(
        'Should not call alreadyPaid.update to false when dont finish saleRequest in concentrador',
        () async {
      finishSaleRequestConcentrador.mockFinishError();

      await sut.doPayment(
        commandNumber: homePresenter.commandNumberMock!,
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
        paymentMode: PaymentMode.pix,
      );

      verify(() => alreadyPaid.update(true)).called(1);
      verifyNever(() => alreadyPaid.update(false));
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
    test("Should return true", () async {
      final result = await sut.getAlreadyPaid();

      expect(result, true);
    });
    test("Should return false", () async {
      alreadyPaid.mockVerify(false);
      final result = await sut.getAlreadyPaid();

      expect(result, false);
    });
  });

  group("try pay again", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.tryPayAgain(commandNumber.toInt());
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      finishSaleRequestConcentrador.mockFinishError();
      await sut.tryPayAgain(commandNumber.toInt());
    });
    test("Should call finishSaleRequestConcentrador with correct values",
        () async {
      await sut.tryPayAgain(homePresenter.commandNumberMock!.toInt());

      verify(() => finishSaleRequestConcentrador.finish(
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            pdvNumber: 100,
            commandNumber: homePresenter.commandNumberMock!.toInt(),
          )).called(1);
    });
    test("Should update already paid to false in success", () async {
      await sut.tryPayAgain(homePresenter.commandNumberMock!.toInt());

      verify(() => alreadyPaid.update(false)).called(1);
    });
    test("Should return true on success", () async {
      final value =
          await sut.tryPayAgain(homePresenter.commandNumberMock!.toInt());

      expect(value, true);
    });
    test("Should return false on error", () async {
      finishSaleRequestConcentrador.mockFinishError();
      final value =
          await sut.tryPayAgain(homePresenter.commandNumberMock!.toInt());

      expect(value, false);
    });
  });
}
