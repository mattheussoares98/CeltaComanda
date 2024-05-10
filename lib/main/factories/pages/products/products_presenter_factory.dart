import '../../../../presentation/presenters/getx_products_presenter.dart';
import '../../../factories/usecases/usecases.dart';

GetxProductsPresenter makeGetxProductsPresenter() => GetxProductsPresenter(
      navigateTo: makeNavigateTo(),
      loadProducts: makeRemoteLoadProducts(),
      updateSaleRequestTemp: makeRemoteUpdateSaleRequestTemp(),
    );
