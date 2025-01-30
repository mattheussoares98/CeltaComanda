import '../../usecases/usecases.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

MenuPresenter makeGetxMenuPresenter() => GetxMenuPresenter(
      loadExpansibleGroups: makeRemoteLoadExpansibleGroups(),
      navigateTo: makeNavigateTo(),
      commandInformations: makeRemoteCommandInformations(),
      searchProductByCode: makeRemoteSearchProductByCode(),
      barcodeScanner: makeCameraBarcodeScanner(),
      loadProducts: makeRemoteLoadProducts(),
      getProductComposition: makeRemoteGetProductComposition(),
      loadSuggestionSale: makeRemoteLoadSuggestionSale(),
      manageProductSchedule: makeRemoteManageProductSchedule(),
      manageExpansibleGroupSchedule: makeRemoteManageExpansibleGroupSchedule(),
      parametersData: makeLocalParametersData(),
      loadImages: makeConcentratorLoadImages(),
      loadExportCharging: makeRemoteLoadExportsCharging(),
      lastImport: makeLocalLastImport(),
      menuDatabaseManagement: makeLocalMenuDatabaseManagement(),
    );
