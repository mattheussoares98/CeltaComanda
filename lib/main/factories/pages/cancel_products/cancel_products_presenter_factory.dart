import '../../../../main/factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

CancelProductsPresenter makeGetxCancelProductsPresenter() =>
    GetxCancelProductsPresenter(
      removePrintedProduct: makeRemoteRemovePrintedProduct(),
      loadPrintedProducts: makeRemoteLoadPrintedProducts(),
    );
