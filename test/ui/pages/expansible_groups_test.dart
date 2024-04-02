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
}
