import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

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
  late UseFixedCommandNumberSpy useFixedCommandNumber;

  late ExpansibleGroupEntity expansibleGroupEntity;

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
      useFixedCommandNumber: useFixedCommandNumber,
    );
  }

  void initUsecases() {
    loadExpansibleGroups = LoadExpansibleGroupsSpy();
    localEnterpriseData = LocalEnterpriseDataSpy();
    ticketIsPermitted = TicketIsPermittedSpy();
    navigateTo = NavigateToSpy();
    useFixedCommandNumber = UseFixedCommandNumberSpy();
  }

  void initMocks() {
    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    useFixedCommandNumber.mockLoad(true);
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

      verify(() => useFixedCommandNumber.load()).called(1);
    });
  });
}
