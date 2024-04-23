import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/main/builders/enterprise_data_builder.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/mocks/load_expansible_groups_spy.dart';
import '../../domain/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxExpansibleGroupsPresenter sut;
  late NavigateToSpy navigateTo;
  late LoadExpansibleGroupsSpy loadExpansibleGroups;
  late List<ExpansibleGroupEntity> expansibleGroups;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late LoadCommandsAvailableSpy loadCommandsAvailable;
  late ApiSaleRequestEntity apiSaleRequest;
  late String commandNumber;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    commandNumber = "001";
    loadCommandsAvailable = LoadCommandsAvailableSpy();
    loadExpansibleGroups = LoadExpansibleGroupsSpy();
    expansibleGroups = EntityFactory.makeExpansibleGroups();
    loadExpansibleGroups.mockLoadExpansibleGroups(expansibleGroups);
    apiSaleRequest = EntityFactory.makeApiSaleRequestEntity();
    navigateTo = NavigateToSpy();
    navigateTo.mockNavigate();
    localEnterpriseData = LocalEnterpriseDataSpy();
    sut = GetxExpansibleGroupsPresenter(
      navigateTo: navigateTo,
      loadExpansibleGroups: loadExpansibleGroups,
      localEnterpriseData: localEnterpriseData,
      loadCommandsAvailable: loadCommandsAvailable,
    );
  });

  setUpAll(() {
    registerFallbackValue(EnterpriseDataBuilder.enterpriseDataEntity);
    registerFallbackValue(const EnterpriseEntity(enterpriseName: ""));
  });

  test('Should call load products', () async {
    await sut.load();

    verify(() => loadExpansibleGroups.load()).called(1);
  });

  test('Should throw DomainErrorUnexpected', () async {
    loadExpansibleGroups.mockLoadExpansibleGroupsError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.expansibleGroupsStream
        .listen(expectAsync1((expansibleGroups) => expect(expansibleGroups, [
              ExpansibleGroupsViewModel(
                Name: expansibleGroups[0].Name,
                ExpansibleGroupId: expansibleGroups[0].ExpansibleGroupId,
                ExpansibleGroupType: expansibleGroups[0].ExpansibleGroupType,
                OrderClassification: expansibleGroups[0].OrderClassification,
              ),
              ExpansibleGroupsViewModel(
                Name: expansibleGroups[1].Name,
                ExpansibleGroupId: expansibleGroups[1].ExpansibleGroupId,
                ExpansibleGroupType: expansibleGroups[1].ExpansibleGroupType,
                OrderClassification: expansibleGroups[1].OrderClassification,
              ),
            ])));

    await sut.load();
  });

  test('Should go to cart page on CartIcon click', () async {
    sut.goToCartPage();

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.cart,
      ),
    ).called(1);
  });

  test('Should go to products page ExpansibleGroupItem click', () async {
    sut.goToProductsPage(expansibleGroups[0].ExpansibleGroupId);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.products,
        arguments: expansibleGroups[0].ExpansibleGroupId,
      ),
    ).called(1);
  });

  test('Should go to SplashPage on logout click', () async {
    sut.goToSplashPage();

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.splash,
        clear: true,
      ),
    ).called(1);
  });

  test('Should clear local data on logout', () async {
    final enterpriseEntity = EnterpriseEntity(
      enterpriseName:
          EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
    );
    localEnterpriseData.mockAdd(enterpriseEntity);

    await sut.clearEnterpriseData();

    verify(() => localEnterpriseData.add(enterpriseEntity)).called(1);
  });

  test('Should emit correct events on verify command success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.verifyCommandAvailable(commandNumber);
  });
  test('Should return correct value on loadCommandsAvailable', () async {
    loadCommandsAvailable.mockLoadCommandsAvailable(apiSaleRequest);
    final value = await loadCommandsAvailable.load(
      url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
      commandNumber: commandNumber,
    );

    expect(value, apiSaleRequest);
  });

  test('Should correct events on load command throws commandNotAvailable', () async {
    loadCommandsAvailable.mockError(DomainError.commandNotAvailable);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emits(UIError.commandNotAvailable));

    await sut.verifyCommandAvailable(commandNumber);
  });

  test('Should correct events on load command throws unexpected', () async {
    loadCommandsAvailable.mockError(DomainError.unexpected);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emits(UIError.unexpected));

    await sut.verifyCommandAvailable(commandNumber);
  });

  test('Should correct events on load command throws enterpriseOrUrlNotFound', () async {
    loadCommandsAvailable.mockError(DomainError.enterpriseOrUrlNotFound);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emits(UIError.enterpriseOrUrlNotFound));

    await sut.verifyCommandAvailable(commandNumber);
  });
}
