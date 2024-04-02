import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ExpansibleGroupsPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = ExpansibleGroupsPresenterSpy();
    await tester.pumpWidget(
        makePage(path: '/', page: () => ExpansibleGroupsPage(presenter)));
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
}
