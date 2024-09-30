import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxHomePresenter with ChangeNotifier implements HomePresenter {
  final NavigateTo navigateTo;
  final LocalEnterpriseData localEnterpriseData;
  final CommandInformations commandInformations;
  final LocalCommandData localCommandData;
  final UserValidations userValidations;
  final UpdateSaleRequestTemp updateSaleRequestTemp;
  final LoadSaleRequestTemp loadSaleRequestTemp;
  final LoadSellers loadSellers;
  final Persistent persistent;
  final AlreadyPaid alreadyPaid;

  GetxHomePresenter({
    required this.navigateTo,
    required this.localEnterpriseData,
    required this.commandInformations,
    required this.localCommandData,
    required this.userValidations,
    required this.updateSaleRequestTemp,
    required this.loadSaleRequestTemp,
    required this.loadSellers,
    required this.persistent,
    required this.alreadyPaid,
  });

  @override
  Future<void> goToSplashPage({
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required MenuPresenter menuPresenter,
  }) async {
    navigateTo.navigate(pageRoute: PageRoutes.splash, clear: true);

    _commandNumber = null;
    menuPresenter.clear();
    printedProductsPresenter.clear();
    cartPresenter.clear();
    await clearEnterpriseData();
    await persistent.makeNotPersistent();
  }

  @override
  Future<void> goToPaymentPage() async {
    navigateTo.navigate(pageRoute: PageRoutes.payment);
  }

  @override
  Future<void> clearEnterpriseData() async {
    final emptyEntity = EnterpriseEntity(
      enterpriseName:
          EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName ?? "",
      enterpriseId: null,
      url: null,
      concentradorUrl: null,
      persistApp: null,
      urlCCS: null,
      useCovenant: null,
    );
    EnterpriseDataBuilder.enterpriseDataEntity = emptyEntity;

    await localEnterpriseData.add(emptyEntity);
  }

  @override
  void onChangePage({
    required MenuPresenter menuPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
  }) {
    printedProductsPresenter.updateCanCancelProducts(false);
  }

  @override
  Future<void> updateIsFixedCommandNumber() async {
    isLoading = true;
    mainError = null;

    try {
      _isFixedCommandNumber = !_isFixedCommandNumber;

      await localCommandData.update(
        CommandEntity(
          commandNumber: _commandNumber,
          isFixedCommandNumber: _isFixedCommandNumber,
        ),
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> loadCommandData({
    required MenuPresenter menuPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      if (EnterpriseDataBuilder.enterpriseDataEntity?.persistApp == true &&
          !_isGeneratingVersionToTablet) {
        await persistent.makePersistent();
      } else {
        await persistent.makeNotPersistent();
      }

      CommandEntity? loadedCommand = await localCommandData.load();

      if (loadedCommand != null) {
        _isFixedCommandNumber = loadedCommand.isFixedCommandNumber;
        _commandNumber = loadedCommand.commandNumber;
      }

      await menuPresenter.getGroupsAndProducts(
        commandNumber: commandNumber ?? "001",
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      if (isFixedCommandNumber && commandNumber != null) {
        final saleRequest = await loadSaleRequestTemp.load(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: commandNumber!,
        );

        final sellersEntity = await loadSellers.load();
        _sellers =
            sellersEntity.map((e) => SellersViewModel.fromEntity(e)).toList();

        updateSelectedPeoples(saleRequest.Peoples);
        updateSelectedSeller(
          _sellers.firstWhereOrNull(
              (e) => e.SellersId.toString() == saleRequest.SellerCode),
        );

        await cartPresenter.loadSaleRequest(commandNumber!);
        await printedProductsPresenter.loadPrinted(this);

        final isValid = await commandInformations.isValidDatetime(
            commandNumber: commandNumber!);
        if (!isValid) {
          throw DomainError.blockedCommand;
        }
      }
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.blockedCommand:
          mainError = UIError.blockedCommand;
          break;
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
          break;
        default:
          mainError = UIError.unexpected;
          break;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void goToCartPage() {
    navigateTo.navigate(pageRoute: PageRoutes.cart);
  }

  @override
  void goToPrintedProductsPage() {
    navigateTo.navigate(pageRoute: PageRoutes.printedProducts);
  }

  @override
  Future<bool> updateCommandData({
    required int newFixedCommandNumber,
    required int userPersonalizedCode,
    required String password,
    required String? sellerCode,
    required int? peoples,
    required PrintedProductsPresenter printedProductsPresenter,
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

      bool isValidPassword = await userValidations.isValidPassword(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        personalizedCode: userPersonalizedCode,
        password: password,
      );

      if (isValidPassword != true) {
        throw DomainError.invalidCredentialsOrAccessDenied;
      }

      updateCommandNumber(commandNumber);
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
          Peoples: peoples,
          SellerCode: sellerCode,
          Comments: saleRequestTempEntity.Comments,
          DeliveryControl: saleRequestTempEntity.DeliveryControl,
          EnterpriseId: saleRequestTempEntity.EnterpriseId,
          PersonalizedCode: saleRequestTempEntity.PersonalizedCode,
          SaleRequestTempId: saleRequestTempEntity.SaleRequestTempId,
          TotalLiquid: saleRequestTempEntity.TotalLiquid,
          Products: saleRequestTempEntity.Products.map(
            (e) => UpdateSaleRequestTempProductEntity(
              ProductInternalCodeOnErp: e.ProductInternalCodeOnErp,
              ProductPriceLookUpCode: e.ProductPriceLookUpCode,
              Quantity: e.Quantity,
              SaleRequestTempId: e.SaleRequestTempId,
              TotalLiquid: e.TotalLiquid,
              Value: e.Value,
              Comments: e.Comments,
            ),
          ).toList(),
        ),
      );

      _peoples = peoples;
      await printedProductsPresenter.loadPrinted(this);
      notifyListeners();
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
  Future<bool> isValidUserAndPassword({
    required int personalizedCode,
    required String password,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      final isValid = await userValidations.isValidPassword(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        personalizedCode: personalizedCode,
        password: password,
      );

      if (!isValid) {
        throw DomainError.invalidCredentials;
      }

      return isValid;
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
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

      await alreadyPaid.update(false);

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
  void updateCommandNumber(String? value) {
    _commandNumber = value;
  }

  String? _commandNumber;
  @override
  String? get commandNumber => _commandNumber;

  final _isLoading = false.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  final _mainError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;

  bool _isFixedCommandNumber = false;
  @override
  bool get isFixedCommandNumber => _isFixedCommandNumber;

  @override
  bool get isGeneratingVersionToRede => true;

  bool _isGeneratingVersionToTablet = false;
  @override
  bool get isGeneratingVersionToTablet => _isGeneratingVersionToTablet;

  List<SellersViewModel> _sellers = [];
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

  @override
  Future<void> closeApp() async {
    await persistent.closeApp();
  }

  @override
  void changeIsGeneratingVersionToRede(bool value) {
    _isGeneratingVersionToTablet = value;
  }
}
