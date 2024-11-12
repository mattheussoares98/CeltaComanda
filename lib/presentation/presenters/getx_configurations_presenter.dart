import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxConfigurationsPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements ConfigurationsPresenter {
  final UserValidations userValidations;
  final CommandInformations commandInformations;
  final NavigateTo navigateTo;
  final Persistent persistent;
  final UpdateMenu updateMenu;

  GetxConfigurationsPresenter({
    required this.userValidations,
    required this.commandInformations,
    required this.navigateTo,
    required this.persistent,
    required this.updateMenu,
  });

  @override
  Future<void> doLogout({
    required MenuPresenter menuPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
  }) async {
    menuPresenter.clear();
    printedProductsPresenter.clear();
    cartPresenter.clear();
    homePresenter.clear();
    await persistent.makeNotPersistent();

    await navigateTo.navigate(pageRoute: PageRoutes.splash, clear: true);
  }

  @override
  Future<bool> openOrBlockadeCommand({
    required int commandNumber,
    required bool isOpen,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      await commandInformations.openOrBlockade(
        commandNumber: commandNumber.toString().padLeft(3, "0"),
        isOpen: isOpen,
      );

      return true;
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.invalidCredentialsOrAccessDenied:
          mainError = UIError.invalidCredentialsOrAccessDenied;
          break;
        default:
          mainError = UIError.unexpected;
      }
      return false;
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateSelectedCommand(int value) {
    _selectedCommand = value;
  }

  @override
  void updateSelectedPeoples(int? value) {
    _peoples = value;
  }

  @override
  void updateSelectedSeller(SellersViewModel? seller) {
    _selectedSeller = seller;
  }

  final List<SellersViewModel> _sellers = [];
  @override
  List<SellersViewModel> get sellers => _sellers;

  SellersViewModel? _selectedSeller;
  @override
  SellersViewModel? get selectedSeller => _selectedSeller;

  int? _selectedCommand;
  @override
  int? get selectedCommand => _selectedCommand;

  int? _peoples;
  @override
  int? get selectedPeoples => _peoples;

  @override
  Future<void> goToCancelProductsPage() async {
    await navigateTo.navigate(pageRoute: PageRoutes.cancelProducts);
  }
}
