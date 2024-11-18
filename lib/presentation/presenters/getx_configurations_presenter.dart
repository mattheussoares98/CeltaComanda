import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
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
  final LocalCommandData localCommandData;
  final LoadSaleRequestTemp loadSaleRequestTemp;
  final UpdateSaleRequestTemp updateSaleRequestTemp;
  final ChangeSaleRequestPersonalizedCode changeSaleRequestPersonalizedCode;

  GetxConfigurationsPresenter({
    required this.userValidations,
    required this.commandInformations,
    required this.navigateTo,
    required this.persistent,
    required this.updateMenu,
    required this.localCommandData,
    required this.loadSaleRequestTemp,
    required this.updateSaleRequestTemp,
    required this.changeSaleRequestPersonalizedCode,
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

  @override
  Future<bool> loadMenuAgain() async {
    isLoading = true;
    mainError = null;

    try {
      await updateMenu.update();
      return true;
    } catch (e) {
      mainError = UIError.unexpected;
      return false;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<bool> updateCommandData({
    required int newFixedCommandNumber,
    required int? peoples,
    required PrintedProductsPresenter printedProductsPresenter,
    required String? sellerCode,
    required HomePresenter homePresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      final commandNumber = newFixedCommandNumber.toString().padLeft(3, '0');

      bool isValid = await commandInformations.isValidDatetime(
        commandNumber: commandNumber,
      );

      if (!isValid) {
        throw DomainError.blockedCommand;
      }

      homePresenter.updateCommandNumber(commandNumber);
      await localCommandData.update(
        CommandEntity(
          commandNumber: commandNumber,
          isFixedCommandNumber: true,
        ),
      );

      final saleRequestTempEntity = await loadSaleRequestTemp.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: commandNumber,
      );

      await updateSaleRequestTemp.update(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        entity: UpdateSaleRequestTempEntity(
          Comments: null,
          Peoples: null,
          DeliveryControl: null,
          EnterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          PersonalizedCode: saleRequestTempEntity.PersonalizedCode,
          SaleRequestTempId: saleRequestTempEntity.SaleRequestTempId,
          TotalLiquid: saleRequestTempEntity.TotalLiquid,
          Products: [],
          SellerCode: sellerCode,
          CustomerCode: null,
          CovenantCode: null,
          IncrementValue: null,
          IncrementType: null,
        ),
      );

      _peoples = peoples;
      await printedProductsPresenter.loadPrinted(homePresenter.commandNumber!);
      return true;
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.blockedCommand:
          mainError = UIError.blockedCommand;
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
        case DomainError.invalidCredentialsOrAccessDenied:
          mainError = UIError.invalidCredentialsOrAccessDenied;
        default:
          mainError = UIError.unexpected;
      }
      return false;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> goToSchedulesPage() async {
    await navigateTo.navigate(pageRoute: PageRoutes.schedules);
  }

  @override
  Future<void> updateSaleRequestPersonalizedCode({
    required int oldPersonalizedCode,
    required int newPersonalizedCode,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      await changeSaleRequestPersonalizedCode.change(
        oldPersonalizedCode: oldPersonalizedCode.toString(),
        newPersonalizedCode: newPersonalizedCode.toString(),
      );
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.newCommandMustBeEmpty:
          mainError = UIError.newCommandMustBeEmpty;
          break;
        case DomainError.oldCommandIsEmpty:
          mainError = UIError.oldCommandIsEmpty;
          break;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }
}
