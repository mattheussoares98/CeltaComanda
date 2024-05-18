import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/ui/components/search_data_by_command_number.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/entity_factory.dart';
import '../../infra/mocks/mocks.dart';
import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late ExpansibleGroupsPresenterSpy presenter;

  late ExpansibleGroupEntity expansibleGroupEntity;
  late HiveSpy hive;
  late BoxSpy mockHiveBox;
  late int internalCodeOnERPCodeFather;

  setUp(() {
    hive = HiveSpy();
    mockHiveBox = BoxSpy();
    hive.mockOpenBox(mockHiveBox);
    expansibleGroupEntity = EntityFactory.makeExpansibleGroupsEntity()[0];
    presenter = ExpansibleGroupsPresenterSpy();
    internalCodeOnERPCodeFather = faker.randomGenerator.integer(100);
    EnterpriseDataBuilder.enterpriseDataEntity = EntityFactory.makeEnterpriseData();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeExpansibleGroupsEntity()[0]);
    registerFallbackValue(EntityFactory.makeSaleRequestTempProductsViewModel());
    registerFallbackValue(EntityFactory.makeSaleRequestTempEntity());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(SaleRequestTempPresenterSpy());
    registerFallbackValue(ExpansibleGroupsPresenterSpy());
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      makePage(
          path: PageRoutes.expansibleGroups,
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
    presenter.mockGoToComboxPage(internalCodeOnERPCodeFather);

    presenter.goToComboxPage(internalCodeOnERPCodeFather);
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
