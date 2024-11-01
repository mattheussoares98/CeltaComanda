import '../../domain/usecases/usecases.dart';
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

  GetxConfigurationsPresenter({
    required this.loadCustomer,
    required this.validation,
    required this.covenantLimit,
    required this.updateSaleRequest,
    required this.checkPasswordByCustomerCode,
  });

  @override
  Future<void> goToSplashPage() async {}

  @override
  Future<bool> isValidUserAndPassword({
    required int personalizedCode,
    required String password,
  }) async {
    return false;
  }

  @override
  Future<bool> openOrBlockadeCommand({
    required int commandNumber,
    required bool isOpen,
    required int userCode,
    required String password,
  }) async {
    return false;
  }

  @override
  Future<bool> updateCommandData({
    required int newFixedCommandNumber,
    required int userPersonalizedCode,
    required String password,
    required int? peoples,
    required PrintedProductsPresenter printedProductsPresenter,
    required String? sellerCode,
  }) async {
    return false;
  }

  @override
  void updateSelectedCommand(int value) {}

  @override
  void updateSelectedPeoples(int? value) {}

  @override
  void updateSelectedSeller(SellersViewModel? seller) {}

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
