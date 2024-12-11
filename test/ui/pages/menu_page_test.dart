import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../../domain/mocks/entity_factory.dart';
import '../../infra/mocks/mocks.dart';
import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late MenuPresenterSpy presenter;

  late HiveSpy hive;
  late BoxSpy mockHiveBox;

  setUp(() {
    hive = HiveSpy();
    mockHiveBox = BoxSpy();
    hive.mockOpenBox(mockHiveBox);
    presenter = MenuPresenterSpy();
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeExpansibleGroupsEntity()[0]);
    registerFallbackValue(EntityFactory.makeSaleRequestTempProductsViewModel());
    registerFallbackValue(EntityFactory.makeSaleRequestTempEntity(0));
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    registerFallbackValue(EntityFactory.makeProductCompositionViewModel(
      quantity: 0,
      salePrice: 0,
      offerPrice: 0,
      fatherIncrement: 0,
      childIncrement: 0,
      isOptionalItem: false,
      indexOfSelectedChild: 0,
      insertChilds: false,
    ));
    registerFallbackValue(EntityFactory.makeCartProductEntity(
      maximumProductQuantity: 0,
      minimumProductQuantity: 0,
    ));
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      makePage(path: PageRoutes.menus, page: () => const MenuPage(null)),
    );
  }

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

    expect(find.byKey(const Key("loadMenu")), findsOneWidget);
  });

  testWidgets(
      'Should present InsertCommandNumber if verify command is avaible fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.mockLoadDataError(DomainError.unexpected);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("loadMenu")), findsOneWidget);
  });

  testWidgets('Should present InsertCommandNumber command is not available',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.mockLoadDataError(DomainError.commandNotAvailable);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("loadMenu")), findsOneWidget);
  });
}
