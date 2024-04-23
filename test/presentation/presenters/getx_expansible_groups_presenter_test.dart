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
  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late SaleRequestTempEntity saleRequestTemp;
  late String commandNumber;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    commandNumber = "001";
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    loadExpansibleGroups = LoadExpansibleGroupsSpy();
    expansibleGroups = EntityFactory.makeExpansibleGroups();
    loadExpansibleGroups.mockLoadExpansibleGroups(expansibleGroups);
    saleRequestTemp = EntityFactory.makeApiSaleRequestEntity();
    navigateTo = NavigateToSpy();
    navigateTo.mockNavigate();
    localEnterpriseData = LocalEnterpriseDataSpy();
    sut = GetxExpansibleGroupsPresenter(
      navigateTo: navigateTo,
      loadExpansibleGroups: loadExpansibleGroups,
      localEnterpriseData: localEnterpriseData,
      loadSaleRequestTemp: loadSaleRequestTemp,
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

    await sut.getSaleRequestTemp(commandNumber);
  });
  test('Should return correct value on loadSaleRequestTemp', () async {
    loadSaleRequestTemp.mockLoadCommandsAvailable(saleRequestTemp);
    final value = await loadSaleRequestTemp.load(
      url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
      commandNumber: commandNumber,
    );

    expect(value, saleRequestTemp);
  });

  test('Should correct events on load command throws commandNotAvailable',
      () async {
    loadSaleRequestTemp.mockError(DomainError.commandNotAvailable);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emits(UIError.commandNotAvailable));

    await sut.getSaleRequestTemp(commandNumber);
  });

  test('Should emit correct events on get saleRequestTemp', () async {
    loadSaleRequestTemp.mockLoadCommandsAvailable(saleRequestTemp);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.saleRequestTemp.listen(expectAsync1((saleRequest) => expect(
          saleRequest,
          SaleRequestViewModel(
            Products: saleRequest!.Products,
            PersonalizedCode: saleRequest.PersonalizedCode,
            EnterpriseId: saleRequest.EnterpriseId,
            TotalLiquid: saleRequest.TotalLiquid,
            DeliveryControl: saleRequest.DeliveryControl,
            Comments: saleRequest.Comments,
          ),
        )));

    await sut.getSaleRequestTemp(commandNumber);
  });
}
