import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import '../mocks/mocks.dart';

void main() {
  late GetxConfigurationsPresenter sut;

  late LoadCustomerSpy loadCustomer;
  late ValidationSpy validation;
  late CovenantLimitSpy covenantLimit;
  late UpdateSaleRequestSpy updateSaleRequest;
  late CheckPasswordByCustomerCodeSpy checkPasswordByCustomerCode;
  late UserValidationsSpy userValidations;

  late int userPersonalizedCode;
  late String password;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initPresenters() {
    sut = GetxConfigurationsPresenter(
      loadCustomer: loadCustomer,
      validation: validation,
      covenantLimit: covenantLimit,
      updateSaleRequest: updateSaleRequest,
      checkPasswordByCustomerCode: checkPasswordByCustomerCode,
      userValidations: userValidations,
    );
  }

  void initUsecases() {
    loadCustomer = LoadCustomerSpy();
    validation = ValidationSpy();
    covenantLimit = CovenantLimitSpy();
    updateSaleRequest = UpdateSaleRequestSpy();
    checkPasswordByCustomerCode = CheckPasswordByCustomerCodeSpy();
    userValidations = UserValidationsSpy();
  }

  void initMocks() {}

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    userPersonalizedCode = faker.randomGenerator.integer(999);
    password = faker.guid.guid();
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMocks();
  });

  setUpAll(() {
    registerFallbackValue(
      EntityFactory.makeSaleRequestModel(
        covenantCode: 0,
        customerCode: 0,
      ),
    );
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
}
