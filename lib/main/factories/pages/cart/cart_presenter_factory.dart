import '../../factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

CartPresenter makeGetxCartPresenter() => GetxCartPresenter(
      loadSaleRequestTemp: makeRemoteLoadSaleRequestTemp(),
      updateProductQuantity: makeRemoteUpdateProductQuantity(),
      updateProductComment: makeRemoteUpdateProductComment(),
      finishSaleRequestTemp: makeRemoteFinishSaleRequestTemp(),
      commandInformations: makeRemoteCommandInformations(),
      addPrintRequest: makeRemoteAddPrintRequest(),
      localPrintRequest: makeLocalPrintRequest(),
      updateSaleRequestTemp: makeRemoteUpdateSaleRequestTemp(),
      confirmedCartProducts: makeLocalConfirmedCartProducts(),
      cartInformations: makeLocalCartInformations(),
      barcodeScanner: makeCameraBarcodeScanner(),
    );
