import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late SplashPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    await tester.pumpWidget(makePage(path: PageRoutes.splash, page: () => SplashPage(presenter: presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should present spinner on page load', (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byKey(const Key("loading")), findsOneWidget);
  });

  testWidgets('Should call LoadCrossId on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.checkAccount()).called(1);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('');
    await tester.pump();
    expect(currentRoute, PageRoutes.splash);
  });
}