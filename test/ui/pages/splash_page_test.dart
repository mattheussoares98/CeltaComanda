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
    registerFallbackValue(EntityFactory.makeExpansibleGroupFromProductPresenter());
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
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

  testWidgets('Should call LoadCrossId on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.checkApiSaleRequest()).called(1);
  });

  testWidgets('Should change to EnterpriseValidationPage',
      (WidgetTester tester) async {
    await loadPage(tester);
    mockNavigation(routeName: PageRoutes.enterpriseValidation);

    // presenter.navigateToLoginPage();
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.enterpriseValidation);
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
