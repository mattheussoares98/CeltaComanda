import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../navigation/navigation.dart';

void main() {
  late SplashPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    await tester.pumpWidget(makePage(
        path: PageRoutes.splash, page: () => SplashPage(presenter: presenter)));
  }

  setUpAll(() {
    registerFallbackValue(SplashPresenterSpy());
    registerFallbackValue(LoginDataEntitySpy());
    registerFallbackValue(ExpansibleGroupsPresenterSpy());
  });

  testWidgets('Should present spinner on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byKey(const Key("loading")), findsOneWidget);
  });

  testWidgets('Should call LoadCrossId on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.checkAccount()).called(1);
  });

  testWidgets('Should change to LoginPage', (WidgetTester tester) async {
    await loadPage(tester);
    mockNavigation(routeName: PageRoutes.login);

    // presenter.navigateToLoginPage();
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.login);
  });

  testWidgets('Should change to ExpansibleGroupsPage',
      (WidgetTester tester) async {
    await loadPage(tester);
    mockNavigation(routeName: PageRoutes.expansibleGroups);

    // presenter.navigateToExpansibleGroupsPage();
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.expansibleGroups);
  });
}
