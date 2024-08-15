import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/entity_factory.dart';
import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late CartPresenterSpy presenter;

  setUp(() {
    presenter = CartPresenterSpy();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSaleRequestTempEntity(0));
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(EntityFactory.makeExpansibleGroupFromProductPresenter());
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      makePage(
        path: PageRoutes.cart,
        page: () => const CartPage(),
      ),
    );
  }

  tearDown(() {
    presenter.dispose();
  });

  // testWidgets('Should handle spinner on page load',
  //     (WidgetTester tester) async {
  //   await loadPage(tester);

  //   presenter.emitLoading();
  //   await tester.pump(const Duration(seconds: 1));
  //   expect(find.byKey(const Key("loading")), findsOneWidget);

  //   presenter.emitLoading(false);
  //   await tester.pump(const Duration(seconds: 1));
  //   expect(find.byKey(const Key("loading")), findsNothing);
  // });

  testWidgets('Should show InsertCommandNumber if saleRequestTemp is empty',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.clear();
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("emptyCartKey")), findsOneWidget);
  });
}
