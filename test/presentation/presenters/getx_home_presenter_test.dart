import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import '../../ui/mocks/mocks.dart';

void main() {
  late GetxHomePresenter sut;
  late PrintedProductsPresenterSpy printedProductsPresenter;
  late SaleRequestTempPresenterSpy saleRequestTempPresenter;
  late ExpansibleGroupsPresenterSpy expansibleGroupsPresenter;

  late NavigateToSpy navigateTo;
  late LoadExpansibleGroupsSpy loadExpansibleGroups;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late TicketIsPermittedSpy ticketIsPermitted;

  late ExpansibleGroupEntity expansibleGroupEntity;
  late String commandNumber = faker.randomGenerator.integer(3).toString();

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initPresenters() {
    printedProductsPresenter = PrintedProductsPresenterSpy();
    saleRequestTempPresenter = SaleRequestTempPresenterSpy();
    expansibleGroupsPresenter = ExpansibleGroupsPresenterSpy();
    sut = GetxHomePresenter(
      loadExpansibleGroups: loadExpansibleGroups,
      navigateTo: navigateTo,
      localEnterpriseData: localEnterpriseData,
      ticketIsPermitted: ticketIsPermitted,
    );
  }

  void initUsecases() {
    loadExpansibleGroups = LoadExpansibleGroupsSpy();
    localEnterpriseData = LocalEnterpriseDataSpy();
    ticketIsPermitted = TicketIsPermittedSpy();
    navigateTo = NavigateToSpy();
  }

  void initMocks() {
    navigateTo.mockNavigate();
    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
  }

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    expansibleGroupEntity = EntityFactory.makeExpansibleGroupsEntity()[0];
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMocks();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseData());
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
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
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
  });

  group("LoadData", () {
    test("Should emit correct events on loadData throws commandNotAvailable",
        () async {
      ticketIsPermitted.mockError(DomainError.commandNotAvailable);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.load(
        commandNumber: commandNumber,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
      );
    });

    test("Should emit correct events on loadData throws", () async {
      ticketIsPermitted.mockError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.load(
        commandNumber: commandNumber,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
      );
    });

    test("Should clear commandNumber if loadData throws", () async {
      ticketIsPermitted.mockError(DomainError.unexpected);

      await sut.load(
        commandNumber: commandNumber,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
      );

      expect(sut.commandNumber, null);
    });

    test("Should emit correct events on loadData success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.load(
        commandNumber: commandNumber,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
      );
    });

    test("Should update commandNumber on loadCall", () async {
      expect(sut.commandNumber, null);
      await sut.load(
        commandNumber: commandNumber,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
      );

      expect(sut.commandNumber, commandNumber);
    });

    test("Should clear data of presenters when call loadData", () async {
      await sut.load(
        commandNumber: commandNumber,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
      );

      verify(() => printedProductsPresenter.clear()).called(1);
      verify(() => saleRequestTempPresenter.clear()).called(1);
      verify(() => expansibleGroupsPresenter.clear()).called(1);
    });

    test("Should call ticketIsPermitted when call loadData", () async {
      await sut.load(
        commandNumber: commandNumber,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
      );

      verify(() => ticketIsPermitted.verify(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            commandNumber: commandNumber,
          )).called(1);
    });

    test("Should load data of presenters when call loadData", () async {
      await sut.load(
        commandNumber: commandNumber,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
      );

      verify(() => printedProductsPresenter.loadPrinted(commandNumber)).called(1);
      verify(() => saleRequestTempPresenter.loadSaleRequest(commandNumber)).called(1);
      verify(() => expansibleGroupsPresenter.loadGroups(commandNumber)).called(1);
    });

    test('Should clear EnterpriseDataBuilder when go to SplashPage', () async {
      await sut.goToSplashPage(
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
      );

      expect(EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName,
          isNotEmpty);
      expect(EnterpriseDataBuilder.enterpriseDataEntity?.url, null);
      expect(EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseId, null);
    });
  });
}
