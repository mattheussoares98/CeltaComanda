import '../../factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

InsertProductPresenter makeGetxInsertProductsPresenter() =>
    GetxInsertProductsPresenter(
      updateSaleRequestTemp: makeRemoteUpdateSaleRequestTemp(),
        validateCombox: makeLocalValidateCombox(),
    );
