// import 'package:clean_celta_mobile/main/builders/builders.dart';
// import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
// import 'package:clean_celta_mobile/ui/pages/pages.dart';
// import 'package:flutter/material.dart';
// import 'package:mocktail/mocktail.dart';

// import '../../domain/mocks/mocks.dart';
// import '../helpers/helpers.dart';
// import '../mocks/mocks.dart';

// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   late CovenantPresenterSpy presenter;
//   EnterpriseDataBuilder.enterpriseDataEntity =
//       EntityFactory.makeEnterpriseData();

//   setUp(() {
//     presenter = CovenantPresenterSpy();
//   });

//   setUpAll(() {
//     registerFallbackValue(HomePresenterSpy());
//     registerFallbackValue(PrintedProductsPresenterSpy());
//     registerFallbackValue(PaymentPresenterSpy());
//   });

//   Future<void> loadPage(WidgetTester tester) async {
//     await tester.pumpWidget(
//       makePage(
//         path: PageRoutes.covenant,
//         page: () => CovenantPage(),
//       ),
//     );
//   }

//   testWidgets('Should clear selected covenant when page load',
//       (WidgetTester tester) async {
//     await loadPage(tester);

//     verify(
//       () => presenter.updateSelectedCovenant(null, ""),
//     ).called(1);
//   });
//   testWidgets('Should clear selected covenant when close the page',
//       (WidgetTester tester) async {
//     await loadPage(tester);

//     final BuildContext context = tester.element(find.byType(CovenantPage));
//     Navigator.of(context).pop();
//     await tester.pumpAndSettle();

//     verify(
//       () => presenter.updateSelectedCovenant(null, ""),
//     ).called(2);
//   });
// }
