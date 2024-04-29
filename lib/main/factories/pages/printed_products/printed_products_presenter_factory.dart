import '../../../../main/factories/usecases/usecases.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

PrintedProductsPresenter makeGetxPrintedProductsPresenter() =>
    GetxPrintedProductsPresenter(
      userValidations: makeRemoteUserValidations(),
      loadPrintedProducts: makeRemoteLoadPrintedProducts(),
      removePrintedProduct: makeRemoteRemovePrintedProduct(),
    );
