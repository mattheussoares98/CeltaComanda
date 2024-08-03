import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../../ui/mocks/mocks.dart';

import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

void main() {
  late GetxHomePresenter sut;
  late PrintedProductsPresenterSpy printedProductsPresenter;
  late CartPresenterSpy cartPresenter;
  late MenuPresenterSpy menuPresenter;
  late CommentsPresenterSpy commentsPresenter;
  late HomePresenterSpy homePresenter;

  late NavigateToSpy navigateTo;
  late LoadExpansibleGroupsSpy loadExpansibleGroups;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late TicketIsPermittedSpy ticketIsPermitted;
  late LoadCommandDataSpy localCommandData;
  late UserValidationsSpy userValidations;

  late ExpansibleGroupEntity expansibleGroupEntity;
  late CommandEntity commandEntity;
  late int newFixedCommandNumber;
  late int userPersonalizedCode;
  late String password;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initPresenters() {
    printedProductsPresenter = PrintedProductsPresenterSpy();
    cartPresenter = CartPresenterSpy();
    menuPresenter = MenuPresenterSpy();
    commentsPresenter = CommentsPresenterSpy();
    homePresenter = HomePresenterSpy();
    sut = GetxHomePresenter(
      loadExpansibleGroups: loadExpansibleGroups,
      navigateTo: navigateTo,
      localEnterpriseData: localEnterpriseData,
      ticketIsPermitted: ticketIsPermitted,
      localCommandData: localCommandData,
      userValidations: userValidations,
    );
  }

  void initUsecases() {
    loadExpansibleGroups = LoadExpansibleGroupsSpy();
    localEnterpriseData = LocalEnterpriseDataSpy();
    ticketIsPermitted = TicketIsPermittedSpy();
    navigateTo = NavigateToSpy();
    localCommandData = LoadCommandDataSpy();
    userValidations = UserValidationsSpy();
  }

  void initMocks() {
    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    localCommandData.mockLoad(commandEntity);
  }

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    expansibleGroupEntity = EntityFactory.makeExpansibleGroupsEntity()[0];
    commandEntity = EntityFactory.makeCommandEntity();
    newFixedCommandNumber = faker.randomGenerator.integer(999);
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
    registerFallbackValue(EntityFactory.makeEnterpriseData());
    registerFallbackValue(EntityFactory.makeProductViewModel());
    registerFallbackValue(EntityFactory.makeCommentViewModel());
    registerFallbackValue(CommentsPresenterSpy());
    registerFallbackValue(HomePresenterSpy());
  });

  group("Navigation", () {
    test('Should go to ProductsPage', () async {
      sut.goToProductsPage(expansibleGroupEntity);

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.products,
            arguments: expansibleGroupEntity,
          )).called(1);
    });
    test('Should go to PrintedProductsPage', () async {
      sut.goToPrintedProductsPage();

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.printedProducts,
          )).called(1);
    });
    test('Should go to SplashPage', () async {
      await sut.goToSplashPage(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
      );

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.splash,
            clear: true,
          )).called(1);
    });
    test('Should go to SplashPage', () async {
      sut.goToCartPage();

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.cart,
            clear: false,
          )).called(1);
    });
  });

  group("ClearEnterpriseData", () {
    test("Should call localEnterpriseData cleaning data", () async {
      await sut.clearEnterpriseData();

      verify(() => localEnterpriseData.add(
            EnterpriseEntity(
              enterpriseName:
                  EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
              enterpriseId: null,
              url: null,
            ),
          )).called(1);
    });
    test('Should clear EnterpriseDataBuilder when go to SplashPage', () async {
      await sut.goToSplashPage(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
      );

      expect(EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName,
          isNotEmpty);
      expect(EnterpriseDataBuilder.enterpriseDataEntity?.url, null);
      expect(EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseId, null);
    });
  });

  group("On page change", () {
    test("Should updateCanCancelProducts to false when change page", () {
      printedProductsPresenter.updateCanCancelProducts(true);

      sut.onChangePage(
        menuPresenter: menuPresenter,
        commentsPresenter: commentsPresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      expect(printedProductsPresenter.canCancelProducts, false);
    });
  });

  group("updateIsFixedCommandNumber", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateIsFixedCommandNumber();
    });
    test("Should emit correct values on error", () async {
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateIsFixedCommandNumber();
    });
    test("Should call localCommandData.udpate", () async {
      final commandNumber = faker.randomGenerator.integer(100).toString();
      sut.updateCommandNumber(commandNumber);

      await sut.updateIsFixedCommandNumber();

      verify(() => localCommandData.update(CommandEntity(
            commandNumber: commandNumber,
            isFixedCommandNumber: sut.isFixedCommandNumber,
          ))).called(1);
    });
  });

  group("getLocalCommandData", () {
    test("Should load useFixedCommandNumber on call loadUseFixedCommandNumber",
        () async {
      await sut.getLocalCommandData();

      verify(() => localCommandData.load()).called(1);
    });

    test("Should emit correct values on loadUseFixedCommandNumber", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.getLocalCommandData();
    });
    test("Should update sut.isFixedCommandNumber correctly", () async {
      const fixed = CommandEntity(
        commandNumber: "commandNumber",
        isFixedCommandNumber: true,
      );
      const notFixed = CommandEntity(
        commandNumber: "commandNumber",
        isFixedCommandNumber: false,
      );

      localCommandData.mockLoad(fixed);
      await sut.getLocalCommandData();
      expect(sut.isFixedCommandNumber, true);

      localCommandData.mockLoad(notFixed);
      await sut.getLocalCommandData();
      expect(sut.isFixedCommandNumber, false);
    });
    test("Should update sut.commandNumber correctly", () async {
      final entity1 = CommandEntity(
        commandNumber: faker.randomGenerator.integer(999).toString(),
        isFixedCommandNumber: faker.randomGenerator.boolean(),
      );

      final entity2 = CommandEntity(
        commandNumber: faker.randomGenerator.integer(999).toString(),
        isFixedCommandNumber: faker.randomGenerator.boolean(),
      );

      localCommandData.mockLoad(entity1);
      await sut.getLocalCommandData();
      expect(sut.commandNumber, entity1.commandNumber.toString());

      localCommandData.mockLoad(entity2);
      await sut.getLocalCommandData();
      expect(sut.commandNumber, entity2.commandNumber.toString());
    });
  });

  group("load command data", () {
    test("Should call menuPresenter.getGroupsAndProducts on loadCommandData",
        () async {
      await sut.loadCommandData(
        homePresenter: homePresenter,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        commentsPresenter: commentsPresenter,
      );

      verify(() => menuPresenter.getGroupsAndProducts(
          commandNumber: sut.commandNumber ?? "001",
          commentsPresenter: commentsPresenter)).called(1);
    });
    test(
        "Should not call cartPresenter.loadSaleRequest and printedProductsPresenter.loadPrinted when is not fixed command number",
        () async {
      expect(sut.isFixedCommandNumber, false);
      sut.updateCommandNumber("001");

      await sut.loadCommandData(
        homePresenter: homePresenter,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        commentsPresenter: commentsPresenter,
      );

      verifyNever(
          () => cartPresenter.loadSaleRequest(sut.commandNumber ?? "001"));
      verifyNever(() => printedProductsPresenter.loadPrinted(homePresenter));
    });
    test(
        "Should  call cartPresenter.loadSaleRequest and printedProductsPresenter.loadPrinted when is fixed command number",
        () async {
      sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber("001");

      await sut.loadCommandData(
        homePresenter: homePresenter,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        commentsPresenter: commentsPresenter,
      );

      verify(() => cartPresenter.loadSaleRequest(sut.commandNumber!)).called(1);
      verify(() => printedProductsPresenter.loadPrinted(homePresenter))
          .called(1);
    });
    test(
        "Should emit correct values on cartPresenter.loadSaleRequest throw DomainError.unexpected",
        () async {
      sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber("001");
      cartPresenter.mockLoadSaleRequestTempError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        homePresenter: homePresenter,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        commentsPresenter: commentsPresenter,
      );
    });
    test(
        "Should emit correct values on cartPresenter.loadSaleRequest throw DomainError.commandNotAvailable",
        () async {
      sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber("001");
      cartPresenter
          .mockLoadSaleRequestTempError(DomainError.commandNotAvailable);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        homePresenter: homePresenter,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        commentsPresenter: commentsPresenter,
      );
    });
    test(
        "Should emit correct values on printedProductsPresenter.loadPrinted throw DomainError.unexpected",
        () async {
      sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber("001");
      printedProductsPresenter.mockLoadPrintedError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        homePresenter: homePresenter,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        commentsPresenter: commentsPresenter,
      );
    });
    test(
        "Should emit correct values on printedProductsPresenter.loadPrinted throw DomainError.commandNotAvailable",
        () async {
      sut.updateIsFixedCommandNumber();
      sut.updateCommandNumber("001");
      printedProductsPresenter
          .mockLoadPrintedError(DomainError.commandNotAvailable);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        homePresenter: homePresenter,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        commentsPresenter: commentsPresenter,
      );
    });

    test(
        "Should emit correct values on menuPresenter.loadGroupsAndProducts trhows CommandNotAvailable",
        () async {
      menuPresenter.mockLoadDataError(DomainError.commandNotAvailable);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        homePresenter: homePresenter,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        commentsPresenter: commentsPresenter,
      );
    });
    test(
        "Should emit correct values on menuPresenter.loadGroupsAndProducts trhows unexpected",
        () async {
      menuPresenter.mockLoadDataError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommandData(
        homePresenter: homePresenter,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        commentsPresenter: commentsPresenter,
      );
    });
  });

  group("Update fixed command number", () {
    test("Should emit correct values when update command number", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateFixedCommandNumber(
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );
    });
    test("Should validate ticket is permitted to validate command number",
        () async {
      await sut.updateFixedCommandNumber(
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      verify(
        () => ticketIsPermitted.verify(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          commandNumber: newFixedCommandNumber.toString(),
        ),
      ).called(1);
    });
    test("Should validate user and password to change command number",
        () async {
      await sut.updateFixedCommandNumber(
        newFixedCommandNumber: newFixedCommandNumber,
        userPersonalizedCode: userPersonalizedCode,
        password: password,
      );

      verify(
        () => ticketIsPermitted.verify(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          commandNumber: newFixedCommandNumber.toString(),
        ),
      ).called(1);
    });
  });
}
