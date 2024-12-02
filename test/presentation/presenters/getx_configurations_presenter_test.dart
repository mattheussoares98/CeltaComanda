import 'package:clean_celta_mobile/domain/entities/entities.dart';
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
  late UpdateMenuSpy updateMenu;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late LocalCommandDataSpy localCommandData;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late ChangeSaleRequestPersonalizedCodeSpy changeSaleRequestPersonalizedCode;
  late ChangeSaleRequestPersonalizedCodeProductsSpy
      changeSaleRequestPersonalizedCodeProducts;
  late CloseSaleRequestSpy closeSaleRequest;
  late AddPendingDeviceToUpdateSpy addPendingDeviceToUpdate;
  late LoadUniqueIdentifierSpy loadUniqueIdentifier;

  late int newFixedCommandNumber;
  late SellersViewModel selectedSeller;
  late int? peoples;
  late String? sellerCode;
  late CommandEntity fixedCommandEntity;
  late SaleRequestTempEntity saleRequestTempEntity;
  late String identifier;

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
      updateMenu: updateMenu,
      loadSaleRequestTemp: loadSaleRequestTemp,
      localCommandData: localCommandData,
      updateSaleRequestTemp: updateSaleRequestTemp,
      changeSaleRequestPersonalizedCode: changeSaleRequestPersonalizedCode,
      changeSaleRequestPersonalizedCodeProducts:
          changeSaleRequestPersonalizedCodeProducts,
      closeSaleRequest: closeSaleRequest,
      addPendingDeviceToUpdate: addPendingDeviceToUpdate,
      loadUniqueIdentifier: loadUniqueIdentifier,
    );
  }

  void initUsecases() {
    userValidations = UserValidationsSpy();
    commandInformations = CommandInformationsSpy();
    navigateTo = NavigateToSpy();
    persistent = PersistentSpy();
    updateMenu = UpdateMenuSpy();
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    localCommandData = LocalCommandDataSpy();
    updateSaleRequestTemp = UpdateSaleRequestTempSpy();
    changeSaleRequestPersonalizedCode = ChangeSaleRequestPersonalizedCodeSpy();
    changeSaleRequestPersonalizedCodeProducts =
        ChangeSaleRequestPersonalizedCodeProductsSpy();
    closeSaleRequest = CloseSaleRequestSpy();
    addPendingDeviceToUpdate = AddPendingDeviceToUpdateSpy();
    loadUniqueIdentifier = LoadUniqueIdentifierSpy();
  }

  void initMocks() {
    localCommandData.mockLoad(fixedCommandEntity);
    loadSaleRequestTemp.mockLoadSaleRequestTemp(saleRequestTempEntity);
    loadUniqueIdentifier.mockGet(identifier);
    addPendingDeviceToUpdate.mockAdd(identifier);
  }

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    newFixedCommandNumber = faker.randomGenerator.integer(999);
    selectedSeller = EntityFactory.makeSellersViewModel();
    peoples = faker.randomGenerator.integer(100);
    sellerCode = faker.randomGenerator.integer(100).toString();
    fixedCommandEntity = EntityFactory.makeCommandEntity(true);
    saleRequestTempEntity = EntityFactory.makeSaleRequestTempEntity(
      newFixedCommandNumber,
    );
    homePresenter.commandNumberMock = newFixedCommandNumber.toString();
    identifier = faker.randomGenerator.string(10);
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
    registerFallbackValue(EntityFactory.makeUpdateSaleRequestTempEntity());
    registerFallbackValue(EntityFactory.makeCommandEntity());
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

  group("Load menu again", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.loadMenuAgain();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      updateMenu.mockUpdateError();

      await sut.loadMenuAgain();
    });
    test("Should call updateMenu.update", () async {
      await sut.loadMenuAgain();

      verify(() => updateMenu.update()).called(1);
    });
    test("Should return true on success", () async {
      final value = await sut.loadMenuAgain();

      expect(value, true);
    });
    test("Should return false on error", () async {
      updateMenu.mockUpdateError();

      final value = await sut.loadMenuAgain();

      expect(value, false);
    });

    test("Should call addPendingDeviceToUpdate.add", () async {
      await sut.loadMenuAgain();

      verify(() => addPendingDeviceToUpdate.add(identifier)).called(1);
    });
    test("Should call load pending device", () async {
      await sut.loadMenuAgain();

      verify(() => loadUniqueIdentifier.get()).called(1);
    });
  });

  group("Update command data", () {
    test("Should call printedProductsPresenter.load", () async {
      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        homePresenter: homePresenter,
      );

      verify(() => printedProductsPresenter
          .loadPrinted(homePresenter.commandNumber!)).called(1);
    });
    test("Should emit correct values when update command number", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        homePresenter: homePresenter,
      );
    });
    test("Should call is valid datetime with correct values", () async {
      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        homePresenter: homePresenter,
      );

      verify(
        () => commandInformations.isValidDatetime(
          commandNumber: newFixedCommandNumber.toString().padLeft(3, "0"),
        ),
      ).called(1);
    });

    test("Should update local command data", () async {
      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        homePresenter: homePresenter,
      );

      verify(
        () => localCommandData.update(
          CommandEntity(
            commandNumber: newFixedCommandNumber.toString().padLeft(3, '0'),
            isFixedCommandNumber: true,
          ),
        ),
      ).called(1);
    });
    test("Should emit correct values on validate time throws", () async {
      commandInformations.mockErrorIsValidDateTime();

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.blockedCommand]),
      );
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        homePresenter: homePresenter,
      );
    });

    test("Should update command number", () async {
      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        homePresenter: homePresenter,
      );

      verify(
        () => homePresenter.updateCommandNumber(
            newFixedCommandNumber.toString().padLeft(3, '0')),
      ).called(1);
    });
    test("Should return false if update fixed command number throws", () async {
      commandInformations.mockErrorIsValidDateTime();

      final value = await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        homePresenter: homePresenter,
      );

      expect(value, false);
    });
    test("Should return true if update fixed command number success", () async {
      final value = await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        homePresenter: homePresenter,
      );

      expect(value, true);
    });
    test("Should call loadSaleRequestTemp", () async {
      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        homePresenter: homePresenter,
      );

      verify(
        () => loadSaleRequestTemp.load(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: newFixedCommandNumber.toString().padLeft(3, "0"),
        ),
      ).called(1);
    });
    // test("Should call updateSaleRequestTemp", () async {
    //   await sut.updateCommandData(
    //     sellerCode: sellerCode,
    //     peoples: peoples,
    //     printedProductsPresenter: printedProductsPresenter,
    //     newFixedCommandNumber: newFixedCommandNumber,
    //     homePresenter: homePresenter,
    //   );

    //   verify(
    //     () => updateSaleRequestTemp.update(
    //       url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
    //       entity: updateSaleRequestTempEntity,
    //     ),
    //   ).called(1);
    // });
    test("Should update peoples number", () async {
      expect(sut.selectedPeoples, null);

      await sut.updateCommandData(
        sellerCode: sellerCode,
        peoples: peoples,
        printedProductsPresenter: printedProductsPresenter,
        newFixedCommandNumber: newFixedCommandNumber,
        homePresenter: homePresenter,
      );

      expect(sut.selectedPeoples, peoples);
    });
  });

  group("Go to products schedules page", () {
    test("Should call navigateTo with correct values", () async {
      await sut.goToSchedulesPage();

      verify(() => navigateTo.navigate(pageRoute: PageRoutes.schedules))
          .called(1);
    });
  });

  group("Update sale request personalized code", () {
    final int oldPersonalizedCode = faker.randomGenerator.integer(100);
    final int newPersonalizedCode = faker.randomGenerator.integer(100);
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.updateSaleRequestPersonalizedCode(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
      );
    });
    test("Should emit correct values on DomainError.unexpected", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      changeSaleRequestPersonalizedCode.mockError(DomainError.unexpected);

      await sut.updateSaleRequestPersonalizedCode(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
      );
    });
    test("Should emit correct values on DomainError.newCommandIsNotEmpty",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.newCommandMustBeEmpty]));

      changeSaleRequestPersonalizedCode
          .mockError(DomainError.newCommandMustBeEmpty);

      await sut.updateSaleRequestPersonalizedCode(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
      );
    });
    test("Should emit correct values on DomainError.oldCommandIsEmpty",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.oldCommandIsEmpty]));

      changeSaleRequestPersonalizedCode
          .mockError(DomainError.oldCommandIsEmpty);

      await sut.updateSaleRequestPersonalizedCode(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
      );
    });
    test("Should call changeSaleRequestPersonalizedCode with correct values",
        () async {
      await sut.updateSaleRequestPersonalizedCode(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
      );

      verify(() => changeSaleRequestPersonalizedCode.change(
            oldPersonalizedCode: oldPersonalizedCode.toString(),
            newPersonalizedCode: newPersonalizedCode.toString(),
          )).called(1);
    });
    test("Should return true on success", () async {
      final updated = await sut.updateSaleRequestPersonalizedCode(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
      );

      expect(updated, true);
    });
    test("Should return false on error", () async {
      changeSaleRequestPersonalizedCode.mockError(DomainError.unexpected);

      final updated = await sut.updateSaleRequestPersonalizedCode(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
      );

      expect(updated, false);
    });
  });

  group("Go to send products to another table page", () {
    test("Should call navigateTo with correct values", () {
      sut.goToSendProductsToAnotherTablePage();

      verify(() => navigateTo.navigate(
          pageRoute: PageRoutes.sendProductsToAnotherTable)).called(1);
    });
  });

  group("Close command", () {
    int commandNumber = faker.randomGenerator.integer(100);
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.closeCommand(commandNumber);
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      closeSaleRequest.mockError();

      await sut.closeCommand(commandNumber);
    });
    test("Should call close sale request with correct values", () async {
      await sut.closeCommand(commandNumber);

      verify(
        () => closeSaleRequest.close(commandNumber.toString().padLeft(3, "0")),
      ).called(1);
    });
    test("Should return true on success", () async {
      final value = await sut.closeCommand(commandNumber);

      expect(value, true);
    });
    test("Should return false on error", () async {
      closeSaleRequest.mockError();

      final value = await sut.closeCommand(commandNumber);

      expect(value, false);
    });
  });
}
