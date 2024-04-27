import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:get/get.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProductDetailsPresenterSpy presenter;
  late ProductsPresenterSpy productsPresenter;
  Get.testMode = true;

  setUp(() {
    presenter = ProductDetailsPresenterSpy();
    productsPresenter = ProductsPresenterSpy();
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      makePage(
          path: PageRoutes.products,
          //quando está na página de produtos e clica em um produto, esse produto é
          //enviado como argumento para a página de detalhes do produto. Porém, não
          //estava funcionando os testes com a rota inicial sendo a de detalhes do
          //produto porque não estava encontrando um argumento ao carregar a página.
          //Por isso fiz a rota inicial ser a de produtos, pra navegar pra de detalhes
          //do produto e a partir daí fazer os testes corretamente
          page: () => ProductsPage(productsPresenter)),
    );
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should go to CartPage', (WidgetTester tester) async {
    //quando está na página de produtos e clica em um produto, esse produto é
    //enviado como argumento para a página de detalhes do produto. Porém, não
    //estava funcionando os testes com a rota inicial sendo a de detalhes do
    //produto porque não estava encontrando um argumento ao carregar a página.
    //Por isso fiz a rota inicial ser a de produtos, pra navegar pra de detalhes
    //do produto e a partir daí fazer os testes corretamente
    await loadPage(tester);
    productsPresenter.goToProductDetailsPage();
    await tester.pumpAndSettle();
    expect(currentRoute, PageRoutes.productDetails);

    presenter.goToCartPage();
    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.cart);
  });
}
