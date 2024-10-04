import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/mocks.dart';
import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late CovenantPresenterSpy presenter;
  EnterpriseDataBuilder.enterpriseDataEntity =
      EntityFactory.makeEnterpriseData();

  setUp(() {
    presenter = CovenantPresenterSpy();
  });

  setUpAll(() {
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      makePage(
        path: PageRoutes.covenant,
        page: () => CovenantPage(covenantPresenter: presenter),
      ),
    );
  }

  testWidgets('Should handle spinner on is loading',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(
      () => presenter.updateSelectedCovenant(null, ""),
    ).called(1);
  });
}
