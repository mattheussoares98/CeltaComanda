import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    loadExpansibleGroups = LoadExpansibleGroupsSpy();
    expansibleGroups = EntityFactory.makeExpansibleGroups();
    loadExpansibleGroups.mockLoadExpansibleGroups(expansibleGroups);
    navigateTo = NavigateToSpy();
    navigateTo.mockNavigate();
    sut = GetxExpansibleGroupsPresenter(
      navigateTo: navigateTo,
      loadExpansibleGroups: loadExpansibleGroups,
    );
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
                name: expansibleGroups[0].name,
              ),
              ExpansibleGroupsViewModel(
                name: expansibleGroups[1].name,
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
    sut.goToProductsPage();

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.products,
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
}
