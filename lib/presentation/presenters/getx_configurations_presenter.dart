import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helpers.dart';
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
  final ChangeSaleRequestPersonalizedCodeProducts
      changeSaleRequestPersonalizedCodeProducts;
  final CloseSaleRequest closeSaleRequest;
  final AddPendingDeviceToUpdate addPendingDeviceToUpdate;
  final LoadDeviceData loadDeviceData;
  final LaunchUrl launchUrl;
  final DeleteData deleteData;
  final LoadGroupPermissions loadGroupPermissions;
  final LastImport lastImport;
  final LoadUsers loadUsers;

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
    required this.changeSaleRequestPersonalizedCodeProducts,
    required this.closeSaleRequest,
    required this.addPendingDeviceToUpdate,
    required this.loadDeviceData,
    required this.launchUrl,
    required this.deleteData,
    required this.loadGroupPermissions,
    required this.lastImport,
    required this.loadUsers,
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
    await deleteData.delete([
      CacheKeys.alreadyPaid,
      CacheKeys.cartProducts,
      CacheKeys.commandData,
      CacheKeys.comments,
      CacheKeys.images,
      CacheKeys.lastImport,
      CacheKeys.parameters,
      CacheKeys.paidInformations,
      CacheKeys.printRequest,
      CacheKeys.updatedAllImages,
      CacheKeys.updatedSaleRequestTemp,
    ]);

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
  Future<bool> loadMenuAgain(String enterpriseName) async {
    isLoading = true;
    mainError = null;

    try {
      final imeiOrWindowsId = await loadDeviceData.getImeiOrWindowsId();
      await addPendingDeviceToUpdate.add(
        imeiOrWindowsId: imeiOrWindowsId,
        enterpriseName: enterpriseName,
      );
      await updateMenu.update(enterpriseName);
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

      await homePresenter.updateCommandEntity(
        commandNumber: commandNumber,
        isFixedCommandNumber:
            homePresenter.commandEntity?.isFixedCommandNumber == true,
        pdv: homePresenter.commandEntity?.pdv,
      );
      await localCommandData.update(
        CommandEntity(
          commandNumber: commandNumber,
          isFixedCommandNumber:
              homePresenter.commandEntity?.isFixedCommandNumber == true,
          pdv: homePresenter.commandEntity?.pdv,
        ),
      );

      final saleRequestTempEntity = await loadSaleRequestTemp.load(
        commandNumber: commandNumber,
      );

      await updateSaleRequestTemp.update(
        url: EnterpriseBuilder.entity!.url!,
        entity: UpdateSaleRequestTempEntity(
          Comments: null,
          Peoples: null,
          DeliveryControl: null,
          EnterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
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
      await printedProductsPresenter
          .loadPrinted(homePresenter.commandEntity!.commandNumber!);
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
  Future<bool> updateSaleRequestPersonalizedCode({
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
      return true;
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
      return false;
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToSendProductsToAnotherTablePage() {
    navigateTo.navigate(pageRoute: PageRoutes.sendProductsToAnotherTable);
  }

  @override
  Future<bool> closeCommand(int commandNumber) async {
    isLoading = true;
    mainError = null;
    try {
      await closeSaleRequest.close(commandNumber.toString().padLeft(3, "0"));
      return true;
    } catch (e) {
      mainError = UIError.unexpected;
      return false;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> goToParametersPage() async {
    await navigateTo.navigate(pageRoute: PageRoutes.parameters);
  }

  @override
  void goToSaleMovementsPage() {
    navigateTo.navigate(pageRoute: PageRoutes.saleMovements);
  }

  @override
  Future<void> goToUpdateApplication() async {
    try {
      isLoading = true;
      mainError = null;
      bool isAndroid = loadDeviceData.isAndroidPlatform();

      if (isAndroid) {
        await launchUrl.launch(
          "https://play.google.com/store/apps/details?id=br.com.celtaware.comanda",
        );
      } else {
        await launchUrl.launch(
          "https://apps.apple.com/br/app/celta-comanda/id6504995969?l=en-GB",
        );
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> updateUsersData({
    required bool loadLocally,
  }) async {
    try {
      if (loadLocally &&
          _loadedPermissions != null &&
          _loadedPermissions!.isNotEmpty == true) {
        return;
      }

      final result = await loadGroupPermissions.getAll(
        loadLocally: loadLocally,
      );

      _loadedPermissions = result;

      await lastImport.save([LoadTypeEnum.users]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<GroupPermissionConcentratorEntity>? _loadedPermissions;
  @override
  List<GroupPermissionConcentratorEntity>? get loadedPermissions =>
      _loadedPermissions;

  UserConcentratorEntity? _loggedUser;
  @override
  UserConcentratorEntity? get loggedUser => _loggedUser;

  @override
  void updateLoggedUser(UserConcentratorEntity? user) {
    _loggedUser = user;
  }

  @override
  bool userCanAccessResource(PermissionName permission) {
    if (_loggedUser == null ||
        _loadedPermissions == null ||
        _loadedPermissions?.isEmpty == true) {
      return false;
    }

    final userPermission = _loadedPermissions!
        .where((e) =>
            e.GroupId == _loggedUser?.Groups?.first.GroupId &&
            e.Permission?.Name == permission.description)
        .toList();

    final canAccess = userPermission.first.IsActive == true;

    if (!canAccess) {
      mainError = null;
      mainError = UIError.accessDenied;
    }

    return canAccess;
  }
}
