import '../../../../main/factories/usecases/usecases.dart';
import '../../../../presentation/presenters/presenters.dart';

GetxPrintedProductsPresenter makeGetxPrintedProductsPresenter() =>
    GetxPrintedProductsPresenter(
      userValidations: makeRemoteUserValidations(),
      loadPrintedProducts: makeRemoteLoadPrintedProducts(),
      removePrintedProduct: makeRemoteRemovePrintedProduct(),
    );
