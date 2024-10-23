import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/mocks.dart';
import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EnterpriseValidationPresenterSpy presenter;
  late HomePresenterSpy homePresenter;
  EnterpriseDataBuilder.enterpriseDataEntity =
      EntityFactory.makeEnterpriseData();

  setUp(() {
    homePresenter = HomePresenterSpy();
    presenter = EnterpriseValidationPresenterSpy();
    presenter.mockLoadRemoteData(EnterpriseDataBuilder.enterpriseDataEntity);
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      makePage(
          path: PageRoutes.enterpriseValidation,
          page: () => EnterpriseValidationPage()),
    );
  }

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeCommandEntity());
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
  });

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should handle spinner on is loading',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();
    expect(find.byKey(const Key("loading")), findsOneWidget);

    presenter.emitLoading(false);
    await tester.pump();
    expect(find.byKey(const Key("loading")), findsNothing);
  });

  testWidgets('Should show error error to load enterprise',
      (WidgetTester tester) async {
    await loadPage(tester);
    presenter.mockLoadRemoteDataError();

    await presenter.validateApiAndGoToHomePage(
      commandEntity: EntityFactory.makeCommandEntity(),
      homePresenter: homePresenter,
    );
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.enterpriseValidation);
  });

  testWidgets('Should call validateEnterpriseInput on didChangeDependencies',
      (WidgetTester tester) async {
    await loadPage(tester);

    // Verificando se a função foi chamada quando didChangeDependencies é chamado
    verify(() => presenter
        .validateEnterpriseInput(presenter.enterpriseNameController.text));
  });
}
