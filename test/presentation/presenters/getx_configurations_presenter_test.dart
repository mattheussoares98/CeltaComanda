import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
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
  late CommandInformationsSpy commandInformations;

  late String password;
  late int userCode;
  late int newFixedCommandNumber;
  late SellersViewModel selectedSeller;

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
      commandInformations: commandInformations,
    );
  }

  void initUsecases() {
    loadCustomer = LoadCustomerSpy();
    validation = ValidationSpy();
    covenantLimit = CovenantLimitSpy();
    updateSaleRequest = UpdateSaleRequestSpy();
    checkPasswordByCustomerCode = CheckPasswordByCustomerCodeSpy();
    userValidations = UserValidationsSpy();
    commandInformations = CommandInformationsSpy();
  }

  void initMocks() {}

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    password = faker.guid.guid();
    userCode = faker.randomGenerator.integer(100);
    newFixedCommandNumber = faker.randomGenerator.integer(999);
    selectedSeller = EntityFactory.makeSellersViewModel();
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
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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

  group("Update selected command", () {
    test("Should update to correctly", () {
      final newValue = faker.randomGenerator.integer(100);
      sut.updateSelectedCommand(newValue);

      expect(sut.selectedCommand, newValue);
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
}
