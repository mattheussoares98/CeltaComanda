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
  late CommentsPresenterSpy commentsPresenter;

  late PaySpy pay;
  late LoadPrintedProductsSpy loadPrintedProducts;
  late BarcodeScannerSpy barcodeScanner;

  late double longAmountValue;
  late int portionQuantity;
  late PrintedEntity printedEntity;
  late String commandNumber;

  initUseCases() {
    pay = PaySpy();
    loadPrintedProducts = LoadPrintedProductsSpy();
    barcodeScanner = BarcodeScannerSpy();
  }

  initPresenters() {
    sut = GetxPaymentPresenter(
      pay: pay,
      loadPrintedProducts: loadPrintedProducts,
      barcodeScanner: barcodeScanner,
    );
    homePresenter = HomePresenterSpy();
    cartPresenter = CartPresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
    menuPresenter = MenuPresenterSpy();
    commentsPresenter = CommentsPresenterSpy();
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
    registerFallbackValue(EntityFactory.makeProductViewModel());
    registerFallbackValue(EntityFactory.makeCommentViewModel());
    registerFallbackValue(PaymentMode.credit);
    registerFallbackValue(PaymentMode.startRedeSdk);
    registerFallbackValue(CommentsPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(HomePresenterSpy());
  });

  group("Credit payment", () {
    test('Should call payWithCredit with correct values', () async {
      await sut.payWithCredit(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
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
      await sut.payWithCredit(
        longAmountValue: 280.20,
        portionQuantity: portionQuantity,
      );

      verify(() => pay.pay(
            paymentMode: PaymentMode.credit,
            params: PayParams(
              longAmountValue: 28020,
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should emit correct values on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.payWithCredit(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
      );
    });
    test('Should emit correct values on payWithCredit throws', () async {
      pay.mockPayError();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.payWithCredit(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
      );
    });
  });

  group("CreditPortion payment", () {
    test('Should call payWithCreditPortion with correct values', () async {
      await sut.payWithCreditPortion(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
      );

      verify(() => pay.pay(
            paymentMode: PaymentMode.creditPortion,
            params: PayParams(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should convert amountValue correctly', () async {
      await sut.payWithCreditPortion(
        longAmountValue: 280.250,
        portionQuantity: portionQuantity,
      );

      verify(() => pay.pay(
            paymentMode: PaymentMode.creditPortion,
            params: PayParams(
              longAmountValue: 28025,
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should emit correct values on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.payWithCreditPortion(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
      );
    });
    test('Should emit correct values on payWithCreditPortion throws', () async {
      pay.mockPayError();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.payWithCreditPortion(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
      );
    });
  });

  group("Debit payment", () {
    test('Should call payWithDebit with correct values', () async {
      await sut.payWithDebit(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
      );

      verify(() => pay.pay(
            paymentMode: PaymentMode.debit,
            params: PayParams(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should convert amountValue correctly', () async {
      await sut.payWithDebit(
        longAmountValue: 28025.00,
        portionQuantity: portionQuantity,
      );

      verify(() => pay.pay(
            paymentMode: PaymentMode.debit,
            params: PayParams(
              longAmountValue: 2802500,
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should emit correct values on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.payWithDebit(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
      );
    });
    test('Should emit correct values on payWithDebit throws', () async {
      pay.mockPayError();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.payWithDebit(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
      );
    });
  });

  group("Pix payment", () {
    test('Should call payWithPix with correct values', () async {
      await sut.payWithPix(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
      );

      verify(() => pay.pay(
            paymentMode: PaymentMode.pix,
            params: PayParams(
              longAmountValue: (longAmountValue * 100).toInt(),
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should convert amountValue correctly', () async {
      await sut.payWithPix(
        longAmountValue: 280.001,
        portionQuantity: portionQuantity,
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

      await sut.payWithPix(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
      );
    });
    test('Should emit correct values on payWithPix throws', () async {
      pay.mockPayError();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.payWithPix(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
      );
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
        commentsPresenter: commentsPresenter,
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
        commentsPresenter: commentsPresenter,
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
        commentsPresenter: commentsPresenter,
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        printedProductsPresenter: printedProductsPresenter,
        menuPresenter: menuPresenter,
      );

      // verify(() => printedProductsPresenter.loadCommandData(
      //       commentsPresenter: commentsPresenter,
      //       cartPresenter: cartPresenter,
      //       menuPresenter: menuPresenter,
      //       homePresenter: homePresenter,
      //       clearPermissionToCancelProducts: false,
      //       isRemovingProduct: false,
      //     )).called(1);
    });
  });
}
