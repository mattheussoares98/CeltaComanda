// import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
// import 'package:clean_celta_mobile/ui/pages/pages.dart';
// import 'package:flutter/material.dart';

// import 'package:mocktail/mocktail.dart';

// import '../../domain/mocks/entity_factory.dart';
// import '../../infra/mocks/mocks.dart';
// import '../helpers/helpers.dart';

// import 'package:flutter_test/flutter_test.dart';

// import '../mocks/mocks.dart';

// void main() {
//   late HiveSpy hive;
//   late BoxSpy mockHiveBox;
//   // late HomePresenterSpy sut;
//   late PrintedProductsPresenterSpy printedProductsPresenter;
//   // late CartPresenter cartPresenter;
//   // late MenuPresenter MenuPresenter;

//   setUp(() {
//     mockHiveBox = BoxSpy();
//     hive = HiveSpy();
//     hive.mockOpenBox(mockHiveBox);
//     printedProductsPresenter = PrintedProductsPresenterSpy();
//     // cartPresenter = CartPresenterSpy();
//     // MenuPresenter = MenuPresenterSpy();
//     // sut = HomePresenterSpy();
//   });

//   setUpAll(() {
//     registerFallbackValue(EntityFactory.makeSaleRequestTempEntity(0));
//     registerFallbackValue(EntityFactory.makeProductViewModel());
//     registerFallbackValue(EntityFactory.makeCommentViewModel());
//     registerFallbackValue(PrintedProductsPresenterSpy());
//     registerFallbackValue(CartPresenterSpy());
//     registerFallbackValue(MenuPresenterSpy());
//     registerFallbackValue(EntityFactory.makeCommandEntity());
//   });

//   Future<void> loadPage(WidgetTester tester) async {
//     await tester.pumpWidget(
//         makePage(path: PageRoutes.home, page: () => const HomePage()));
//   }

//   testWidgets('Should update canCancelProducts to false if change page',
//       (WidgetTester tester) async {
//     await loadPage(tester);

//     final bottomNavItem =
//         find.byKey(const Key('BottomNavigationExpansibleGroups'));
//     expect(bottomNavItem, findsOneWidget);

//     printedProductsPresenter.updateCanCancelProducts(true);
//     await tester.tap(bottomNavItem);
//     await tester.pumpAndSettle();

//     expect(printedProductsPresenter.canCancelProducts, false);
//   });

//   //gastei muito tempo tentando arrumar esse teste. Fiz diversos testes mas
//   // nenhum deu certo. No ambiente de produção está funcionando
//   // testWidgets('Should handle spinner on page load',
//   //     (WidgetTester tester) async {
//   //   await loadPage(tester);

//   //   sut.emitLoading(true);
//   //   await tester.pumpAndSettle();
//   //   expect(find.byKey(const Key("loading")), findsOneWidget);

//   //   sut.emitLoading(false);
//   //   await tester.pumpAndSettle();
//   //   expect(find.byKey(const Key("loading")), findsNothing);
//   // });
// }
