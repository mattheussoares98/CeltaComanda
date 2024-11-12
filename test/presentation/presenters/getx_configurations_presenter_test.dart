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

import '../../ui/mocks/mocks.dart';

void main() {
  late GetxConfigurationsPresenter sut;
  late MenuPresenterSpy menuPresenter;
  late PrintedProductsPresenterSpy printedProductsPresenter;
  late CartPresenterSpy cartPresenter;
  late HomePresenterSpy homePresenter;

  late UserValidationsSpy userValidations;
  late CommandInformationsSpy commandInformations;
  late NavigateToSpy navigateTo;
  late PersistentSpy persistent;

  late String password;
  late int userCode;
  late int newFixedCommandNumber;
  late SellersViewModel selectedSeller;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initPresenters() {
    menuPresenter = MenuPresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
    cartPresenter = CartPresenterSpy();
    homePresenter = HomePresenterSpy();
    sut = GetxConfigurationsPresenter(
      userValidations: userValidations,
      commandInformations: commandInformations,
      navigateTo: navigateTo,
      persistent: persistent,
    );
  }

  void initUsecases() {
    userValidations = UserValidationsSpy();
    commandInformations = CommandInformationsSpy();
    navigateTo = NavigateToSpy();
    persistent = PersistentSpy();
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
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(HomePresenterSpy());
  });

  group("Open or blockade command number", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.openOrBlockadeCommand(
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
    test("Should return true on success", () async {
      bool isOpen = faker.randomGenerator.boolean();

      final value = await sut.openOrBlockadeCommand(
        commandNumber: newFixedCommandNumber,
        isOpen: isOpen,
      );

      expect(value, true);
    });
    test("Should return false on error", () async {
      commandInformations.mockErrorOpenOrBlockade(DomainError.unexpected);
      bool isOpen = faker.randomGenerator.boolean();

      final value = await sut.openOrBlockadeCommand(
        commandNumber: newFixedCommandNumber,
        isOpen: isOpen,
      );

      expect(value, false);
    });
    test("Should call userValidations", () async {
      await sut.openOrBlockadeCommand(
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

  group("Do logout", () {
    test("Should call menuPresenter.clear", () async {
      await sut.doLogout(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(() => menuPresenter.clear()).called(1);
    });
    test("Should call printedProductsPresenter.clear", () async {
      await sut.doLogout(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(() => printedProductsPresenter.clear()).called(1);
    });
    test("Should call cartPresenter.clear", () async {
      await sut.doLogout(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(() => cartPresenter.clear()).called(1);
    });
    test("Should call homePresenter.clear", () async {
      await sut.doLogout(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(() => homePresenter.clear()).called(1);
    });
    test("Should make not persistent", () async {
      await sut.doLogout(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(() => persistent.makeNotPersistent()).called(1);
    });
    test("Should call navigate to splash page correctly", () async {
      await sut.doLogout(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.splash,
            clear: true,
          )).called(1);
    });
  });

  group("Go to configurations page", () {
    test("Should call navigateTo with correct values", () async {
      await sut.goToCancelProductsPage();

      verify(() => navigateTo.navigate(pageRoute: PageRoutes.cancelProducts))
          .called(1);
    });
  });
}
