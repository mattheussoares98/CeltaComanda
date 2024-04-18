import '../../../../presentation/presenters/getx_products_presenter.dart';
import '../../../../ui/pages/products/products.dart';
import '../../../factories/usecases/usecases.dart';

ProductsPresenter makeGetxProductsPresenter() => GetxProductsPresenter(
      navigateTo: makeNavigateTo(),
      loadProducts: makeRemoteLoadProducts(),
    );
