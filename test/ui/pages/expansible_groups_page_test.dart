import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ExpansibleGroupsPresenterSpy presenter;

  setUp(() {
    presenter = ExpansibleGroupsPresenterSpy();
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      makePage(
          path: PageRoutes.expansibleGroups,
          page: () => ExpansibleGroupsPage(presenter)),
    );
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should handle spinner on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();
    expect(find.byKey(const Key("loading")), findsOneWidget);

    presenter.emitLoading(false);
    await tester.pump();
    expect(find.byKey(const Key("loading")), findsNothing);
  });

  testWidgets('Should present ReloadScreen if get expansible groups fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.mockExpansibleGroupStreamError(DomainError.unexpected);
    await tester.pumpAndSettle();

    expect(find.byType(ReloadScreen), findsOneWidget);
  });

  testWidgets('Should go to ProductsPage', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.goToProductsPage(faker.randomGenerator.integer(3));
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.products);
  });

  testWidgets('Should go to CartPage', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.goToCartPage();
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.cart);
  });

  testWidgets('Should go to SplashPage', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.goToSplashPage();
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.splash);
  });

  testWidgets('Should show CartIcon on AppBar', (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byKey(const Key("CartIcon")), findsOneWidget);
  });
}
