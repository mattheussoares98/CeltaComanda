import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/entity_factory.dart';
import '../../infra/mocks/mocks.dart';
import '../helpers/helpers.dart';

import 'package:flutter_test/flutter_test.dart';

import '../mocks/mocks.dart';

void main() {
  late HiveSpy hive;
  late BoxSpy mockHiveBox;

  setUp(() {
    mockHiveBox = BoxSpy();
    hive = HiveSpy();
    hive.mockOpenBox(mockHiveBox);
  });

  setUpAll(() {
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(SaleRequestTempPresenterSpy());
    registerFallbackValue(ExpansibleGroupsPresenterSpy());
    registerFallbackValue(EntityFactory.makeSaleRequestTempEntity());
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
        makePage(path: PageRoutes.home, page: () => const HomePage()));
  }

  testWidgets('Should present SearchCommandIcon on AppBar',
      (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(SearchCommandIcon), findsOneWidget);
  });

  // testWidgets('Should present CommandNumber on AppBar when load data',
  //     (WidgetTester tester) async {
  //   await loadPage(tester);

  //   await sut.load(
  //     homePresenter.commandNumberMock!,
  //   );

  //   expect(find.byType(AppBarTitle), findsOneWidget);
  // });
}
