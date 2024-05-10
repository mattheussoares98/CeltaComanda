import '../../../../main/factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';

GetxSaleRequestTempPresenter makeGetxSaleRequestTempPresenter() =>
    GetxSaleRequestTempPresenter(
      loadSaleRequestTemp: makeRemoteLoadSaleRequestTemp(),
      updateProductQuantity: makeRemoteUpdateProductQuantity(),
      updateProductComment: makeRemoteUpdateProductComment(),
      finishSaleRequestTemp: makeRemoteFinishSaleRequestTemp(),
    );
