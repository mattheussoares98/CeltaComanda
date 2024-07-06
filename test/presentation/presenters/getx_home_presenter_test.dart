import 'package:clean_celta_mobile/domain/entities/entities.dart';
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

  late NavigateToSpy navigateTo;
  late LoadExpansibleGroupsSpy loadExpansibleGroups;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late TicketIsPermittedSpy ticketIsPermitted;
  late LoadCommandDataSpy localCommandData;

  late ExpansibleGroupEntity expansibleGroupEntity;
  late CommandEntity commandEntity;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initPresenters() {
    printedProductsPresenter = PrintedProductsPresenterSpy();
    cartPresenter = CartPresenterSpy();
    menuPresenter = MenuPresenterSpy();
    commentsPresenter = CommentsPresenterSpy();
    sut = GetxHomePresenter(
      loadExpansibleGroups: loadExpansibleGroups,
      navigateTo: navigateTo,
      localEnterpriseData: localEnterpriseData,
      ticketIsPermitted: ticketIsPermitted,
      localCommandData: localCommandData,
    );
  }

  void initUsecases() {
    loadExpansibleGroups = LoadExpansibleGroupsSpy();
    localEnterpriseData = LocalEnterpriseDataSpy();
    ticketIsPermitted = TicketIsPermittedSpy();
    navigateTo = NavigateToSpy();
    localCommandData = LoadCommandDataSpy();
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
  });

  group("Navigation", () {
    test('Should go to ProductsPage', () async {
      sut.goToProductsPage(expansibleGroupEntity);

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.products,
            arguments: expansibleGroupEntity,
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
    test("Should clear selectedProduct when changePage", () {
      sut.onChangePage(
        menuPresenter: menuPresenter,
        commentsPresenter: commentsPresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(() => menuPresenter.updateSelectedProduct(
            selectedProduct: null,
            commentsPresenter: commentsPresenter,
          )).called(1);
    });
    test("Should updateCanCancelProducts to false when change page", () {
      printedProductsPresenter.updateCanCancelProducts(true);

      sut.onChangePage(
        menuPresenter: menuPresenter,
        commentsPresenter: commentsPresenter,
        printedProductsPresenter: printedProductsPresenter,
      );

      expect(printedProductsPresenter.canCancelProducts, false);
    });

    test("Should load useFixedCommandNumber on call loadUseFixedCommandNumber",
        () async {
      await sut.loadUseFixedCommandNumber();

      verify(() => localCommandData.load()).called(1);
    });

    test("Should emit correct values on loadUseFixedCommandNumber", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadUseFixedCommandNumber();
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
      await sut.loadUseFixedCommandNumber();
      expect(sut.isFixedCommandNumber, true);

      localCommandData.mockLoad(notFixed);
      await sut.loadUseFixedCommandNumber();
      expect(sut.isFixedCommandNumber, false);
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
            isFixedCommandNumber: false,
          ))).called(1);
    });
  });
}
