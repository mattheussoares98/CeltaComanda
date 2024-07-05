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
  EnterpriseDataBuilder.enterpriseDataEntity =
      EntityFactory.makeEnterpriseData();

  setUp(() {
    presenter = EnterpriseValidationPresenterSpy();
    presenter.mockLoadRemoteData(EnterpriseDataBuilder.enterpriseDataEntity);
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      makePage(
          path: PageRoutes.enterpriseValidation,
          page: () => EnterpriseValidationPage(presenter)),
    );
  }

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
  testWidgets('Should go to MenusPage on success validation',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.goToHomePage();

    expect(currentRoute, PageRoutes.menus);
  });

  testWidgets('Should show error error to load enterprise',
      (WidgetTester tester) async {
    await loadPage(tester);
    presenter.mockLoadRemoteDataError();

    await presenter.validateApiSaleRequest(useFixedCommandNumber: false);
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.enterpriseValidation);
  });

  testWidgets('Should call validateEnterpriseInput on didChangeDependencies',
      (WidgetTester tester) async {
    await loadPage(tester);

    // Verificando se a função foi chamada quando didChangeDependencies é chamado
    verify(() => presenter.validateEnterpriseInput(
        presenter.enterpriseNameController.text));
  });
}
