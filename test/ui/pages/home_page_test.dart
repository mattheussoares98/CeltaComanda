import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mocks.dart';

void main() {
  late ExpansibleGroupsPresenterSpy sut;
  late PrintedProductsPresenterSpy printedProductsPresenter;
  late SaleRequestTempPresenterSpy saleRequestTempPresenter;
  late String commandNumber;

  setUp(() {
    sut = ExpansibleGroupsPresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
    saleRequestTempPresenter = SaleRequestTempPresenterSpy();

    commandNumber = faker.randomGenerator.integer(3).toString();
  });

  setUpAll(() {
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(SaleRequestTempPresenterSpy());
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
        makePage(path: PageRoutes.home, page: () => const HomePage()));
  }

  testWidgets('Should present SearchCommandIcon on AppBar',
      (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byKey(const Key("SearchCommandIcon")), findsOneWidget);
  });

  testWidgets('Should present CommandNumber on AppBar when load data',
      (WidgetTester tester) async {
    await loadPage(tester);

    await sut.load(
      commandNumber: commandNumber,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
    );

    expect(find.byType(AppBarTitle), findsOneWidget);
  });
}
