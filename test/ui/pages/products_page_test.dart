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
  late ProductsPresenterSpy presenter;

  setUp(() {
    presenter = ProductsPresenterSpy();
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
        makePage(
          path: PageRoutes.products,
          page: () => ProductsPage(presenter),
          arguments: faker.randomGenerator.integer(3),
        ),
        const Duration(seconds: 1));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should handle spinner on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(const Key("loading")), findsOneWidget);

    presenter.emitLoading(false);
    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(const Key("loading")), findsNothing);
  });

  testWidgets('Should present ReloadScreen if get expansible groups fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.mockProductStreamError(DomainError.unexpected);
    await tester.pumpAndSettle();

    expect(find.byType(ReloadScreen), findsOneWidget);
  });

  testWidgets('Should go to ProductDetailsPage', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.goToProductDetailsPage();
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.productDetails);
  });
  testWidgets('Should go to CartPage', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.goToCartPage();
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.saleRequestTemp);
  });
}
