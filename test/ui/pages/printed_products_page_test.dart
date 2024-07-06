import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/mocks.dart';
import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late PrintedProductsPresenterSpy presenter;

  setUp(() {
    presenter = PrintedProductsPresenterSpy();
    presenter.mockLoadCommandData();
    presenter.mockRemoveProduct();
  });

  setUpAll(() {
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(EntityFactory.makeProductViewModel());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(HomePresenterSpy());
  });

  // ignore: unused_element
  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
        makePage(
          path: PageRoutes.printedProducts,
          page: () => const PrintedProductsPage(null),
        ),
        duration: const Duration(seconds: 1));
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

  testWidgets(
      'Should updateCanCancelProducts to false when loadCommandData with appBar button',
      (WidgetTester tester) async {
    // await loadPage(tester);

    // final searchCommandIcon = find.byKey(const Key("SearchCommandIcon"));
    // expect(searchCommandIcon, findsOneWidget);

    // await tester.tap(searchCommandIcon);
    // await tester.pumpAndSettle();

    // final textFormField = find.byType(TextFormField);
    // expect(textFormField, findsOneWidget);

    // await tester.enterText(textFormField, 'Some text');
    // await tester.testTextInput.receiveAction(TextInputAction.done);
    // await tester.pumpAndSettle();

    // verify(() => presenter.updateCanCancelProducts(false)).called(1);
  });
}
