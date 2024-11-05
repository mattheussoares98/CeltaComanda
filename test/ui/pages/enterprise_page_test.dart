// import 'package:clean_celta_mobile/main/builders/builders.dart';
// import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
// import 'package:clean_celta_mobile/ui/pages/pages.dart';
// import 'package:mocktail/mocktail.dart';

// import '../../domain/mocks/mocks.dart';
// import '../helpers/helpers.dart';
// import '../mocks/mocks.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   late EnterprisePresenterSpy presenter;
//   late HomePresenterSpy homePresenter;
//   EnterpriseDataBuilder.enterpriseDataEntity =
//       EntityFactory.makeEnterpriseData();

//   setUp(() {
//     homePresenter = HomePresenterSpy();
//     presenter = EnterprisePresenterSpy();
//     presenter.mockLoadRemoteData(EnterpriseDataBuilder.enterpriseDataEntity);
//   });

//   Future<void> loadPage(WidgetTester tester) async {
//     await tester.pumpWidget(
//       makePage(
//           path: PageRoutes.enterpriseValidation,
//           page: () => EnterpriseValidationPage()),
//     );
//   }

//   setUpAll(() {
//     registerFallbackValue(EntityFactory.makeCommandEntity());
//     registerFallbackValue(EntityFactory.makeProductsViewModel());
//     registerFallbackValue(
//         EntityFactory.makeExpansibleGroupFromProductViewModel());
//     registerFallbackValue(HomePresenterSpy());
//     registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
//     registerFallbackValue(CartPresenterSpy());
//     registerFallbackValue(PrintedProductsPresenterSpy());
//     registerFallbackValue(MenuPresenterSpy());
//   });

//   tearDown(() {
//     presenter.dispose();
//   });
// }
