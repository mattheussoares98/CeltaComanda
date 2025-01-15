import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late GetxWebAllEnterprisesPresenter sut;

  late LoadAllEnterprisesSpy loadAllEnterprises;
  late NavigateToSpy navigateTo;

  void initUseCases() {
    loadAllEnterprises = LoadAllEnterprisesSpy();
    navigateTo = NavigateToSpy();
  }

  void initPresenters() {
    sut = GetxWebAllEnterprisesPresenter(
      loadAllEnterprises: loadAllEnterprises,
      navigateTo: navigateTo,
    );
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
  }

  void mockSuccess() {
    loadAllEnterprises.mockLoadAll([EnterpriseBuilder.entity!]);
  }

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {});

  group("Load all enterprises", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(
          sut.enterprisesStream,
          emitsInOrder([
            null,
            [EnterpriseBuilder.entity!]
          ]));

      await sut.loadEnterprises();
    });

    test("Should emit correct values on failure", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.notFound]));
      expectLater(sut.enterprisesStream, emits(null));

      loadAllEnterprises.mockLoadAllError();

      await sut.loadEnterprises();
    });

    test("Should call load all enterprises", () async {
      await sut.loadEnterprises();

      verify(() => loadAllEnterprises.load()).called(1);
    });
  });

  group("Go to add or edit enterprise", () {
    test("Should emit correct values on success", () {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity);
    });
    test("Should emit correct values on failure", () {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      navigateTo.mockNavigateError();

      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity);
    });

    test("Should call navigate to with correct values", () {
      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity);

      verify(
        () => navigateTo.navigate(
          pageRoute: PageRoutes.webAddOrEditEnterprise,
        ),
      ).called(1);
    });
    test("Should update selected enterprise correctly", () {
      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity);
      expect(sut.selectedEnterprise, EnterpriseBuilder.entity);

      sut.goToAddOrEditEnterprise(null);
      expect(sut.selectedEnterprise, null);
    });
  });
}
