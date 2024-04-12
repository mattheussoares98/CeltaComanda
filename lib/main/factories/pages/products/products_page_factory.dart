import '../../../../ui/pages/products/products.dart';
import './products.dart';

ProductsPage makeProductsPage() => ProductsPage(
      presenter: makeGetxProductsPresenter(),
    );
