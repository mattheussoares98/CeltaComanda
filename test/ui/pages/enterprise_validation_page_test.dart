import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../navigation/navigation.dart';

void main() {
  late EnterpriseValidationPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = EnterpriseValidationPresenterSpy();
    await tester.pumpWidget(makePage(
        path: PageRoutes.splash,
        page: () => EnterpriseValidationPage(presenter)));
  }

  setUpAll(() {
    registerFallbackValue(EnterpriseValidationPresenterSpy());
    // registerFallbackValue(ExpansibleGroupsPresenterSpy());
  });

  testWidgets('Should call LoadLocalData on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadLocalData()).called(1);
  });

  testWidgets('Should change to ExpansibleGroupsPage',
      (WidgetTester tester) async {
    await loadPage(tester);
    mockNavigation(routeName: PageRoutes.expansibleGroups);

    // presenter.navigateToLoginPage();
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.expansibleGroups);
  });
}
