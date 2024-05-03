import '../../../../main/factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

SaleRequestTempPresenter makeGetxSaleRequestTempPresenter() =>
    GetxSaleRequestTempPresenter(
      loadSaleRequestTemp: makeRemoteLoadSaleRequestTemp(),
      updateProductQuantity: makeRemoteUpdateProductQuantity(),
      updateProductComment: makeRemoteUpdateProductComment(),
    );
