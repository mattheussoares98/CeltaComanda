import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../../ui/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxExpansibleGroupsPresenter sut;
  late HomePresenterSpy homePresenter;

  late List<ExpansibleGroupEntity> expansibleGroups;
  late List<ExpansibleGroupsViewModel> expansibleGroupsViewModel;

  late LoadExpansibleGroupsSpy loadExpansibleGroups;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late NavigateToSpy navigateTo;
  late TicketIsPermittedSpy ticketIsPermitted;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUseCases() {
    loadExpansibleGroups = LoadExpansibleGroupsSpy();
    ticketIsPermitted = TicketIsPermittedSpy();
    localEnterpriseData = LocalEnterpriseDataSpy();
    navigateTo = NavigateToSpy();
  }

  void initPresenters() {
    homePresenter = HomePresenterSpy();

    sut = GetxExpansibleGroupsPresenter(
      navigateTo: navigateTo,
      loadExpansibleGroups: loadExpansibleGroups,
      ticketIsPermitted: ticketIsPermitted,
    );
  }

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    expansibleGroups = EntityFactory.makeExpansibleGroupsEntity();
    homePresenter.commandNumberMock =
        faker.randomGenerator.integer(3).toString();
    expansibleGroupsViewModel = expansibleGroups
        .map((e) => ExpansibleGroupsViewModel(
              Name: e.Name,
              ExpansibleGroupId: e.ExpansibleGroupId.toString(),
              ExpansibleGroupType: e.ExpansibleGroupType.toString(),
              OrderClassification: e.OrderClassification.toString(),
            ))
        .toList();
  }

  void mockSuccess() {
    loadExpansibleGroups.mockLoadExpansibleGroups(expansibleGroups);
    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    navigateTo.mockNavigate();
  }

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EnterpriseDataBuilder.enterpriseDataEntity);
    registerFallbackValue(EntityFactory.makeSaleRequestTempProductsViewModel());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(SaleRequestTempPresenterSpy());
    registerFallbackValue(ExpansibleGroupsPresenterSpy());
    registerFallbackValue(const EnterpriseEntity(enterpriseName: ""));
  });

  test('Should call LoadExpansibleGroups', () async {
    await sut.load(homePresenter.commandNumberMock!);

    verify(() => loadExpansibleGroups.load()).called(1);
  });

  test('Should throw DomainErrorUnexpected', () async {
    loadExpansibleGroups.mockLoadExpansibleGroupsError(DomainError.unexpected);

    final error = sut.load(homePresenter.commandNumberMock!);

    expect(sut.expansibleGroups, []);
    expect(error, throwsA(DomainError.unexpected));
  });

  test('Should return correct value on success to load', () async {
    await sut.load(homePresenter.commandNumberMock!);

    expect(sut.expansibleGroups, expansibleGroupsViewModel);
  });
  
  test('Should clear expansibleGroups', () async {
    await sut.load(homePresenter.commandNumberMock!);
    expect(sut.expansibleGroups, expansibleGroupsViewModel);

    sut.clear();
    expect(sut.expansibleGroups, []);
  });

  test('Should go to products page ExpansibleGroupItem click', () async {
    sut.goToProductsPage(expansibleGroups[0]);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.products,
        arguments: expansibleGroups[0],
      ),
    ).called(1);
  });

  test('Should call ticketIsPermitted on load data', () async {
    await sut.load(homePresenter.commandNumberMock!);

    verify(() => ticketIsPermitted.verify(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          commandNumber: homePresenter.commandNumberMock!,
        )).called(1);
  });

  test(
      'Should throw DomainError.commandNotAvailable on ticketIsPermitted throws commandNotAvailable',
      () async {
    ticketIsPermitted.mockError(DomainError.commandNotAvailable);

    final error = sut.load(homePresenter.commandNumberMock!);

    expect(error, throwsA(DomainError.commandNotAvailable));
  });

  test(
      'Should throw DomainError.unexpected on ticketIsPermitted throws unexpected',
      () async {
    ticketIsPermitted.mockError(DomainError.unexpected);

    final error = sut.load(homePresenter.commandNumberMock!);

    expect(error, throwsA(DomainError.unexpected));
  });
}
