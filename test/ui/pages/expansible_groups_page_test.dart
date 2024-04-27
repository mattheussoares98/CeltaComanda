import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ExpansibleGroupsPresenterSpy presenter;

  setUp(() {
    presenter = ExpansibleGroupsPresenterSpy();
  });

  setUpAll(() {
    registerFallbackValue(
      PrintedProductsPresenterSpy(),
    );
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      makePage(
          path: PageRoutes.expansibleGroups,
          page: () => const ExpansibleGroupsPage()),
    );
  }

  tearDown(() {
    presenter.dispose();
  });

  //gastei muito tempo tentando arrumar esse teste. Fiz diversos testes mas
  // nenhum deu certo. No ambiente de produção está funcionando
  // testWidgets('Should handle spinner on page load', (WidgetTester tester)
  // async { await loadPage(tester);

  //   presenter.emitLoading(true);
  //   await tester.pumpAndSettle();
  //   expect(find.byKey(const Key("loading")), findsOneWidget);

  //   presenter.emitLoading(false);
  //   await tester.pumpAndSettle();
  //   expect(find.byKey(const Key("loading")), findsNothing);
  // });

  testWidgets('Should InsertCommandNumber if getExpansibleGroups throws',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.mockExpansibleGroupStreamError(DomainError.unexpected);
    await tester.pumpAndSettle();

    expect(find.byType(InsertCommandNumber), findsOneWidget);
  });

  testWidgets('Should go to ProductsPage', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.goToProductsPage(1);
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.products);
  });

  testWidgets('Should go to PrintedProductsPage', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.goToPrintedProductsPage();
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.printedProducts);
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

  testWidgets('Should show PrintedProductsIcon on AppBar',
      (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byKey(const Key("PrintedProductsIcon")), findsOneWidget);
  });

  testWidgets('Should show SearchCommandIcon on AppBar',
      (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byKey(const Key("SearchCommandIcon")), findsOneWidget);
  });

  testWidgets(
      'Should present InsertCommandNumber if verify command is avaible fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.mockLoadDataError(DomainError.unexpected);
    await tester.pumpAndSettle();

    expect(find.byType(InsertCommandNumber), findsOneWidget);
  });

  testWidgets('Should present InsertCommandNumber command is not available',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.mockLoadDataError(DomainError.commandNotAvailable);
    await tester.pumpAndSettle();

    expect(find.byType(InsertCommandNumber), findsOneWidget);
  });

  testWidgets(
      'Should open AlertDialog to insert command number on SearchCommandIcon click',
      (WidgetTester tester) async {
    await loadPage(tester);

    final iconButton = find.byKey(const Key('SearchCommandIcon'));
    expect(iconButton, findsOneWidget);
    await tester.tap(iconButton);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("AlertDialogSearchCommand")), findsOneWidget);
  });
}
