import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProductsPresenterSpy presenter;

  setUp(() {
    presenter = ProductsPresenterSpy();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeProductViewModel());
  });

  // Future<void> loadPage(WidgetTester tester) async {
  //   await tester.pumpWidget(
  //       makePage(
  //         path: PageRoutes.products,
  //         page: () => const ProductsPage(),
  //         arguments: faker.randomGenerator.integer(3),
  //       ),
  //       const Duration(seconds: 1));
  // }

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

  // testWidgets('Should present ReloadScreen if get expansible groups fails',
  //     (WidgetTester tester) async {
  //   await loadPage(tester);

  //   presenter.mockProductStreamError(DomainError.unexpected);
  //   await tester.pumpAndSettle();

  //   expect(find.byType(ReloadScreen), findsOneWidget);
  // });
}
