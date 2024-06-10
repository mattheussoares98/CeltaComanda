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

  late PaySpy pay;
  late LoadPrintedProductsSpy loadPrintedProducts;

  late double longAmountValue;
  late int portionQuantity;
  late PrintedEntity printedEntity;

  initUseCases() {
    pay = PaySpy();
    loadPrintedProducts = LoadPrintedProductsSpy();
  }

  initPresenters() {
    sut = GetxPaymentPresenter(
      pay: pay,
      loadPrintedProducts: loadPrintedProducts,
    );
    homePresenter = HomePresenterSpy();
  }

  initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    longAmountValue = faker.randomGenerator.decimal();
    portionQuantity = faker.randomGenerator.integer(99);
    printedEntity = EntityFactory.makePrintedProductsEntity();
    homePresenter.commandNumberMock = faker.randomGenerator.integer(999).toString();
  }

  mockSuccess() {
    pay.mockPay();
    loadPrintedProducts.mockLoadPrintedProducts(printedEntity);
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
    registerFallbackValue(PaymentMode.credit);
    registerFallbackValue(PaymentMode.startRedeSdk);
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
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
              longAmountValue: longAmountValue.toString().toInt(true),
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should convert amountValue correctly', () async {
      await sut.payWithCredit(
        longAmountValue: 280.25,
        portionQuantity: portionQuantity,
      );

      verify(() => pay.pay(
            paymentMode: PaymentMode.credit,
            params: PayParams(
              longAmountValue: 28025,
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
              longAmountValue: longAmountValue.toString().toInt(true),
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should convert amountValue correctly', () async {
      await sut.payWithCreditPortion(
        longAmountValue: 280.25,
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
              longAmountValue: longAmountValue.toString().toInt(true),
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should convert amountValue correctly', () async {
      await sut.payWithDebit(
        longAmountValue: 280.25,
        portionQuantity: portionQuantity,
      );

      verify(() => pay.pay(
            paymentMode: PaymentMode.debit,
            params: PayParams(
              longAmountValue: 28025,
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
              longAmountValue: longAmountValue.toString().toInt(true),
              portionQuantity: portionQuantity,
            ),
          )).called(1);
    });
    test('Should convert amountValue correctly', () async {
      await sut.payWithPix(
        longAmountValue: 280.25,
        portionQuantity: portionQuantity,
      );

      verify(() => pay.pay(
            paymentMode: PaymentMode.pix,
            params: PayParams(
              longAmountValue: 28025,
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
    test("Should call loadPrintedProducts with correct commandNumber",
        () async {
      await sut.getTotalValue(homePresenter);

      verify(
        () => loadPrintedProducts.load(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: homePresenter.commandNumber!.toInt(),
        ),
      );
    });
    test("Should emit correct values on loadPrintedProducts success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.totalAmountValueStream, emits(printedEntity.TotalLiquid));

      await sut.getTotalValue(homePresenter);
    });

    test("Should emit correct values on loadPrintedProducts throws", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getTotalValue(homePresenter);
    });

    test("Should emit correct values on loadPrintedProducts returns null",
        () async {
      loadPrintedProducts.mockLoadPrintedProducts(null);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getTotalValue(homePresenter);
    });
  });
}
