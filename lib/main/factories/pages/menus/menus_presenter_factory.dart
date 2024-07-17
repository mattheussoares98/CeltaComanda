import '../../usecases/usecases.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

MenuPresenter makeGetxMenuPresenter() =>
    GetxMenuPresenter(
      loadExpansibleGroups: makeRemoteLoadExpansibleGroups(),
      loadExpansibleGroupsFromProductsComplete: makeRemoteLoadExpansibleGroupsFromProductsComplete(),
      navigateTo: makeNavigateTo(),
      ticketIsPermitted: makeRemoteticketIsPermitted(),
      searchProductByCode: makeRemoteSearchProductByCode(),
      barcodeScanner: makeCameraBarcodeScanner(),
      updateSaleRequestTemp: makeRemoteUpdateSaleRequestTemp(),
      loadProducts: makeRemoteLoadProducts(),
    );
