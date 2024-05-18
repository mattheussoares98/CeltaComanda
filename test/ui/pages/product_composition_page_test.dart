// import 'package:clean_celta_mobile/main/builders/builders.dart';
// import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
// import 'package:clean_celta_mobile/ui/pages/pages.dart';

// import 'package:faker/faker.dart';
// import 'package:mocktail/mocktail.dart';

// import '../../domain/mocks/mocks.dart';
// import '../helpers/helpers.dart';
// import '../mocks/mocks.dart';

// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   late ProductCompositionPresenterSpy presenter;

//   late int internalCodeOnERPCodeFather;

//   setUp(() {
//     presenter = ProductCompositionPresenterSpy();
//     EnterpriseDataBuilder.enterpriseDataEntity =
//         EntityFactory.makeEnterpriseData();
//     internalCodeOnERPCodeFather = faker.randomGenerator.integer(10);
//   });

//   setUpAll(() {
//     registerFallbackValue(EntityFactory.makeProductViewModel());
//     registerFallbackValue(PrintedProductsPresenterSpy());
//     registerFallbackValue(SaleRequestTempPresenterSpy());
//     registerFallbackValue(ExpansibleGroupsPresenterSpy());
//   });

//   Future<void> loadPage(WidgetTester tester) async {
//     await tester.pumpWidget(
//       makePage(
//         path: PageRoutes.combox,
//         page: () => ProductCompositionPage(presenter),
//         arguments: faker.randomGenerator.integer(3),
//       ),
//     );
//   }

//   tearDown(() {
//     presenter.dispose();
//   });

//   testWidgets('Should present ReloadScreen if get expansible groups fails',
//       (WidgetTester tester) async {
//     await loadPage(tester);

//     verify(() => presenter.loadProductComposition(
//           url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
//           enterpriseId:
//               EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
//           internalCodeOnERPCodeFather: internalCodeOnERPCodeFather,
//         )).called(1);
//   });
// }
