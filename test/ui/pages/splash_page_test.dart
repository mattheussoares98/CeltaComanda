import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../../domain/mocks/entity_factory.dart';
import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../navigation/navigation.dart';

void main() {
  late SplashPresenterSpy presenter;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSaleRequestTempEntity(0));
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(EntityFactory.makeCommandEntity());
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    registerFallbackValue(EntityFactory.makeCartProductEntity(
      maximumProductQuantity: 0,
      minimumProductQuantity: 0,
    ));
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
  });

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    await tester.pumpWidget(makePage(
        path: PageRoutes.splash, page: () => SplashPage(presenter: presenter)));
  }

  testWidgets('Should present spinner on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byKey(const Key("loading")), findsOneWidget);
  });

  testWidgets('Should change to ExpansibleGroupsPage',
      (WidgetTester tester) async {
    await loadPage(tester);
    mockNavigation(routeName: PageRoutes.menus);

    // presenter.navigateToExpansibleGroupsPage();
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.menus);
  });
}
