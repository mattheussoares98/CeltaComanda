import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/mocks.dart';
import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProductsPresenterSpy presenter;

  late int internalCodeOnERPCodeFather;

  setUp(() {
    presenter = ProductsPresenterSpy();
    internalCodeOnERPCodeFather = faker.randomGenerator.integer(10);
    EnterpriseDataBuilder.enterpriseDataEntity = EntityFactory.makeEnterpriseData();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeProductViewModel());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(SaleRequestTempPresenterSpy());
    registerFallbackValue(ExpansibleGroupsPresenterSpy());
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      makePage(
        path: PageRoutes.products,
        page: () => const ProductsPage(),
        arguments: faker.randomGenerator.integer(3),
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

  // testWidgets('Should present ReloadScreen if get expansible groups fails',
  //     (WidgetTester tester) async {
  //   await loadPage(tester);

  //   presenter.mockProductStreamError(DomainError.unexpected);
  //   await tester.pumpAndSettle();

  //   expect(find.byType(ReloadScreen), findsOneWidget);
  // });

  testWidgets('Should go to ComboxPage', (WidgetTester tester) async {
    await loadPage(tester);
    presenter.mockGoToComboxPage(internalCodeOnERPCodeFather);

    presenter.goToComboxPage(internalCodeOnERPCodeFather);
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.productComposition);
  });
}
