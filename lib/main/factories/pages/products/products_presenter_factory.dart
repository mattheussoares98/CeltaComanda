import '../../../../presentation/presenters/getx_products_presenter.dart';
import '../../../../ui/pages/pages.dart';
import '../../../factories/usecases/usecases.dart';

ProductsPresenter makeGetxProductsPresenter() => GetxProductsPresenter(
      navigateTo: makeNavigateTo(),
      loadProducts: makeRemoteLoadProducts(),
      updateSaleRequestTemp: makeRemoteUpdateSaleRequestTemp(),
    );
