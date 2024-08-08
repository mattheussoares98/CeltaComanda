import '../../factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

InsertProductPresenter makeGetxInsertProductsPresenter() =>
    GetxInsertProductsPresenter(
      getProductComposition: makeRemoteGetProductComposition(),
      updateSaleRequestTemp: makeRemoteUpdateSaleRequestTemp(),
        validateCombox: makeLocalValidateCombox(),
    );
