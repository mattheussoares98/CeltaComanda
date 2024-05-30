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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  late GetxPaymentPresenter sut;

  late PaySpy pay;

  late double longAmountValue;
  late int portionQuantity;

  initUseCases() {
    pay = PaySpy();
  }

  initPresenters() {
    sut = GetxPaymentPresenter(pay: pay);
  }

  initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    longAmountValue = faker.randomGenerator.decimal();
    portionQuantity = faker.randomGenerator.integer(99);
  }

  mockSuccess() {
    pay.mockPaytCall();
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
              longAmountValue: longAmountValue,
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
      when(() => pay.pay(
            paymentMode: PaymentMode.credit,
            params: any(named: "params"),
          )).thenThrow(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.payWithCredit(
        longAmountValue: longAmountValue,
        portionQuantity: portionQuantity,
      );
    });
  });
}
