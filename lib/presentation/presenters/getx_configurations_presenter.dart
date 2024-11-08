import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

import '../protocols/protocols.dart';

class GetxConfigurationsPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements ConfigurationsPresenter {
  final Validation validation;
  final LoadCustomer loadCustomer;
  final CovenantLimit covenantLimit;
  final UpdateSaleRequest updateSaleRequest;
  final CheckPasswordByCustomerCode checkPasswordByCustomerCode;
  final UserValidations userValidations;
  final CommandInformations commandInformations;
  final NavigateTo navigateTo;
  final Persistent persistent;

  GetxConfigurationsPresenter({
    required this.loadCustomer,
    required this.validation,
    required this.covenantLimit,
    required this.updateSaleRequest,
    required this.checkPasswordByCustomerCode,
    required this.userValidations,
    required this.commandInformations,
    required this.navigateTo,
    required this.persistent,
  });

  @override
  Future<void> goToSplashPage() async {}

  @override
  Future<bool> openOrBlockadeCommand({
    required int commandNumber,
    required bool isOpen,
    required int userCode,
    required String password,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      bool isValidPassword = await userValidations.isValidPassword(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        personalizedCode: userCode.toInt(),
        password: password,
      );

      if (isValidPassword != true) {
        throw DomainError.invalidCredentialsOrAccessDenied;
      }

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
}
