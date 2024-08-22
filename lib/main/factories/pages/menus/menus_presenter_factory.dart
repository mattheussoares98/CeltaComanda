import '../../usecases/usecases.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

MenuPresenter makeGetxMenuPresenter() =>
    GetxMenuPresenter(
      loadExpansibleGroups: makeRemoteLoadExpansibleGroups(),
      navigateTo: makeNavigateTo(),
      commandInformations: makeRemoteCommandInformations(),
      searchProductByCode: makeRemoteSearchProductByCode(),
      barcodeScanner: makeCameraBarcodeScanner(),
      updateSaleRequestTemp: makeRemoteUpdateSaleRequestTemp(),
      loadProducts: makeRemoteLoadProducts(),
      getProductComposition: makeRemoteGetProductComposition(),
    );
