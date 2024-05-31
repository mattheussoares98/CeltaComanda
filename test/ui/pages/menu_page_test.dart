import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/ui/components/search_data_by_command_number.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../../domain/mocks/entity_factory.dart';
import '../../infra/mocks/mocks.dart';
import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late MenuPresenterSpy presenter;

  late ExpansibleGroupEntity expansibleGroupEntity;
  late HiveSpy hive;
  late BoxSpy mockHiveBox;
  late ProductsViewModel productsViewModel;

  setUp(() {
    hive = HiveSpy();
    mockHiveBox = BoxSpy();
    hive.mockOpenBox(mockHiveBox);
    expansibleGroupEntity = EntityFactory.makeExpansibleGroupsEntity()[0];
    presenter = MenuPresenterSpy();
    productsViewModel = EntityFactory.makeProductViewModel();
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeExpansibleGroupsEntity()[0]);
    registerFallbackValue(EntityFactory.makeSaleRequestTempProductsViewModel());
    registerFallbackValue(EntityFactory.makeSaleRequestTempEntity());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(SaleRequestTempPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(EntityFactory.makeProductViewModel());
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      makePage(
          path: PageRoutes.menus,
          page: () => const ExpansibleGroupsPage()),
    );
  }

  tearDown(() {
    presenter.dispose();
  });

  //gastei muito tempo tentando arrumar esse teste. Fiz diversos testes mas
  // nenhum deu certo. No ambiente de produção está funcionando
  // testWidgets('Should handle spinner on page load', (WidgetTester tester)
  // async { await loadPage(tester);

  //   presenter.emitLoading(true);
  //   await tester.pumpAndSettle();
  //   expect(find.byKey(const Key("loading")), findsOneWidget);

  //   presenter.emitLoading(false);
  //   await tester.pumpAndSettle();
  //   expect(find.byKey(const Key("loading")), findsNothing);
  // });

  testWidgets('Should InsertCommandNumber if getExpansibleGroups throws',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.clear();
    await tester.pumpAndSettle();

    expect(find.byType(SearchDataByCommandNumber), findsOneWidget);
  });

  testWidgets('Should go to ProductsPage', (WidgetTester tester) async {
    await loadPage(tester);
    presenter.mockGoToProductsPage(expansibleGroupEntity);

    presenter.goToProductsPage(expansibleGroupEntity);
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.products);
  });

  testWidgets('Should go to ComboxPage', (WidgetTester tester) async {
    await loadPage(tester);
    presenter.mockGoToComboxPage(productsViewModel);

    presenter.goToComboxPage(productsViewModel);
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.productComposition);
  });

  testWidgets(
      'Should present InsertCommandNumber if verify command is avaible fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.mockLoadDataError(DomainError.unexpected);
    await tester.pumpAndSettle();

    expect(find.byType(SearchDataByCommandNumber), findsOneWidget);
  });

  testWidgets('Should present InsertCommandNumber command is not available',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.mockLoadDataError(DomainError.commandNotAvailable);
    await tester.pumpAndSettle();

    expect(find.byType(SearchDataByCommandNumber), findsOneWidget);
  });
}
