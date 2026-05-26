import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helpers.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxHomePresenter
    with ChangeNotifier, ErrorHandling
    implements HomePresenter {
  final NavigateTo navigateTo;
  final LocalEnterpriseData localEnterpriseData;
  final CommandInformations commandInformations;
  final LocalCommandData localCommandData;
  final UserValidations userValidations;
  final UpdateSaleRequestTemp updateSaleRequestTemp;
  final LoadSaleRequestTemp loadSaleRequestTemp;
  final LoadSellers loadSellers;
  final Persistent persistent;
  final AddDeviceInfo addDeviceInfo;
  final AddPendingDeviceToUpdate addPendingDeviceToUpdate;
  final LoadDeviceData loadDeviceData;
  final PdvRegistration pdvRegistration;
  final DeleteData deleteData;
  final LastImport lastImport;
  final LoadExportCharging loadExportCharging;
  final ConcentratorLogin concentratorLogin;

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
    required this.addDeviceInfo,
    required this.addPendingDeviceToUpdate,
    required this.loadDeviceData,
    required this.pdvRegistration,
    required this.deleteData,
    required this.lastImport,
    required this.loadExportCharging,
    required this.concentratorLogin,
  });

  @override
  Future<void> doLogout({
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required MenuPresenter menuPresenter,
    required EnterprisePresenter enterprisePresenter,
  }) async {
    isLoading = true;
    menuPresenter.clear(clearImages: true);
    printedProductsPresenter.clear();
    cartPresenter.clear();

    try {
      final localEntity = await localCommandData.load();
      if (localEntity?.pdv?.PdvId != null) {
        await pdvRegistration.setPdvRegister(
          pdvId: localEntity!.pdv!.PdvId!,
          imeiOrWindowsId: "",
          versionNumber: "",
          ip: "",
          isUsing: false,
        );
      }

      await enterprisePresenter.clearEnterpriseData();
      await persistent.makeNotPersistent();
      await clear();
      await deleteData.delete([
        CacheKeys.alreadyPaid,
        CacheKeys.cartProducts,
        CacheKeys.commandData,
        CacheKeys.comments,
        CacheKeys.parameters,
        CacheKeys.paidInformations,
        CacheKeys.printRequest,
        CacheKeys.updatedAllImages,
        CacheKeys.updatedSaleRequestTemp,
      ]);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      await navigateTo.navigate(pageRoute: PageRoutes.splash, clear: true);
      isLoading = false;
    }
  }

  @override
  Future<void> goToPaymentPage() async {
    navigateTo.navigate(pageRoute: PageRoutes.payment);
  }

  @override
  Future<void> clear() async {
    _commandEntity = null;
    await localCommandData.update(
      const CommandEntity(
        commandNumber: null,
        isFixedCommandNumber: false,
        pdv: null,
      ),
    );
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
  Future<void> loadCommandData({
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      if (EnterpriseBuilder.entity?.persistApp == true &&
          _isGeneratingVersionToTablet) {
        await persistent.makePersistent();
      } else {
        await persistent.makeNotPersistent();
      }

      CommandEntity? loadedCommand = await localCommandData.load();

      if (loadedCommand != null) {
        await updateCommandEntity(
          commandNumber: loadedCommand.isFixedCommandNumber
              ? loadedCommand.commandNumber
              : null,
          isFixedCommandNumber: loadedCommand.isFixedCommandNumber,
          pdv: loadedCommand.pdv,
        );
      }

      final sellersEntity = await loadSellers.load();
      _sellers =
          sellersEntity.map((e) => SellersViewModel.fromEntity(e)).toList();

      if (commandEntity?.isFixedCommandNumber == true &&
          commandEntity?.commandNumber != null) {
        final saleRequest = await loadSaleRequestTemp.load(
          commandNumber: commandEntity!.commandNumber!.padLeft(3, "0"),
        );

        updateSelectedPeoples(saleRequest.Peoples);
        updateSelectedSeller(
          _sellers.firstWhereOrNull(
              (e) => e.SellersId.toString() == saleRequest.SellerCode),
        );

        await cartPresenter.getSaleRequestTemp(commandEntity!.commandNumber!);
        await printedProductsPresenter.loadPrinted(
          commandEntity!.commandNumber!,
        );

        final isValid = await commandInformations.isValidDatetime(
          commandNumber: commandEntity!.commandNumber!,
        );
        if (!isValid) {
          throw DomainError.blockedCommand;
        }
      }
    } catch (e) {
      mainError = getUIError(e);
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
  Future<bool> isValidUserAndPassword({
    required int personalizedCode,
    required String password,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      final isValid = await userValidations.isValidPassword(
        url: EnterpriseBuilder.entity!.url!,
        personalizedCode: personalizedCode,
        password: password,
      );

      if (!isValid) {
        throw DomainError.invalidCredentials;
      }

      return isValid;
    } catch (e) {
      mainError = getUIError(e);
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
        url: EnterpriseBuilder.entity!.url!,
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
    } catch (e) {
      mainError = getUIError(e);
      return false;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> updateCommandEntity({
    required String? commandNumber,
    required bool isFixedCommandNumber,
    required PdvEntity? pdv,
  }) async {
    final entity = CommandEntity(
      commandNumber: commandNumber?.padLeft(3, "0"),
      isFixedCommandNumber: isFixedCommandNumber,
      pdv: pdv ?? _commandEntity?.pdv,
    );

    _commandEntity = entity;
    await localCommandData.update(entity);

    notifyListeners();
  }

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

  @override
  bool get isGeneratingVersionToRede => false;
  @override
  bool get isGeneratingVersionToGetNet => false;
  @override
  bool get isGeneratingVersionToMicrosoftStore => false;
  @override
  bool get isGeneratingVersionToCielo => true;

  bool _isGeneratingVersionToTablet = false;
  @override
  bool get isGeneratingVersionToTablet => _isGeneratingVersionToTablet;

  final bool _isGeneratingVersionToWebSaleRequestDetails = false;
  @override
  bool get isGeneratingVersionToWebSaleRequestDetails =>
      _isGeneratingVersionToWebSaleRequestDetails;

  @override
  void changeIsGeneratingVersionToTablet(bool value) {
    _isGeneratingVersionToTablet = value;
  }

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
  Future<void> doOnRemoteEnterpriseChanges({
    required Map<String, dynamic> data,
    required MenuPresenter menuPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required EnterprisePresenter enterprisePresenter,
  }) async {
    if (EnterpriseBuilder.entity?.enterpriseId == null ||
        EnterpriseBuilder.entity?.url == null) {
      return;
    }

    try {
      final enterprise = EnterpriseModel.fromJson(
        data,
        enterpriseConcentradorParametersEntity:
            EnterpriseBuilder.entity?.enterpriseConcentradorParametersEntity,
      ).toEntity();

      if (enterprise.updateEnterprise !=
          EnterpriseBuilder.entity?.updateEnterprise) {
        EnterpriseBuilder.entity = enterprise;
        await enterprisePresenter.updateConcentratorEnterpriseParameters();
        await localEnterpriseData.add(enterprise);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> goToConfigurationsPage({
    required int userPersonalizedCode,
    required String password,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      bool isValidPassword = await userValidations.isValidPassword(
        url: EnterpriseBuilder.entity!.url!,
        personalizedCode: userPersonalizedCode,
        password: password,
      );

      if (!isValidPassword) {
        throw DomainError.invalidCredentials;
      }

      final canCancel = await userValidations.canCancel(
        personalizedCode: userPersonalizedCode,
        url: EnterpriseBuilder.entity!.url!,
      );

      if (!canCancel) {
        throw DomainError.accessDenied;
      }

      isLoading = false;
      await navigateTo.navigate(pageRoute: PageRoutes.configurations);
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  CommandEntity? _commandEntity;
  @override
  CommandEntity? get commandEntity => _commandEntity;

  @override
  Future<bool> applicationIsInLatestVersion() async {
    try {
      if (!isGeneratingVersionToTablet) {
        return true;
      }

      final remoteVersion = EnterpriseBuilder.entity?.latestCompatibleVersion
          ?.replaceAll(RegExp(r'\.'), '')
          .toInt();

      if (remoteVersion == null) {
        return true;
      }

      var localVersion = await loadDeviceData.getApplicationVersion();

      return localVersion.replaceAll(RegExp(r'\.'), '').toInt() >=
          remoteVersion;
    } catch (e) {
      return true;
    }
  }

  @override
  Future<void> updateWhatNeed({
    required MenuPresenter menuPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required ConfigurationsPresenter configurationsPresenter,
    required EnterprisePresenter enterprisePresenter,
  }) async {
    try {
      final lastImported = await lastImport.load();
      final lastExports = await loadExportCharging.load(
        pdvNumber: commandEntity?.pdv?.PdvNumber ?? "100",
      );

      mainError = null;
      isLoading = true;

      bool needUpdateProductsRemotelly = _needLoadRemote(
        exports: lastExports,
        loadType: LoadTypeEnum.products,
        lastImported: lastImported,
      );
      await menuPresenter.getGroupsAndProducts(
        commandEntity: commandEntity,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        loadLocally: !needUpdateProductsRemotelly,
      );

      bool needUpdateImagesRemotelly = _needLoadRemote(
        exports: lastExports,
        loadType: LoadTypeEnum.images,
        lastImported: lastImported,
      );

      await menuPresenter.loadAllImages(
        loadLocally: !needUpdateImagesRemotelly,
        updatedImages: lastExports
            .where((e) =>
                e.LoadType == LoadTypeEnum.images &&
                e.FileName != null &&
                e.Date?.isAfter(lastImported?.images ??
                        DateTime(DateTime.now().year)) ==
                    true)
            .map((e) => e.FileName?.toString() ?? "")
            .toList(),
      );

      bool needUpdateUsersRemotelly = _needLoadRemote(
        exports: lastExports,
        loadType: LoadTypeEnum.users,
        lastImported: lastImported,
      );
      await configurationsPresenter.updateUsersData(
        loadLocally: !needUpdateUsersRemotelly,
      );

      bool needUpdateEnterpriseRemotelly = _needLoadRemote(
        exports: lastExports,
        loadType: LoadTypeEnum.enterprise,
        lastImported: lastImported,
      );

      if (needUpdateEnterpriseRemotelly) {
        await enterprisePresenter.updateConcentratorEnterpriseParameters();
      }
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  bool _needLoadRemote({
    required List<ExportChargingEntity>? exports,
    required LoadTypeEnum loadType,
    required LastImportEntity? lastImported,
  }) {
    if (lastImported == null && loadType == LoadTypeEnum.images) {
      return true;
    } else if ((exports == null || exports.isEmpty) && lastImported != null) {
      return false;
    }

    final latestExportByLoadType = exports
        ?.where((entity) => entity.LoadType == loadType)
        .fold<ExportChargingEntity?>(null, (latest, entity) {
      if (latest == null ||
          (entity.Date != null && entity.Date!.isAfter(latest.Date!))) {
        return entity;
      }
      return latest;
    });

    if (loadType == LoadTypeEnum.images) {
      return lastImported?.images == null ||
          (latestExportByLoadType?.Date != null &&
              latestExportByLoadType!.Date!.isAfter(lastImported!.images!));
    } else if (loadType == LoadTypeEnum.products) {
      return lastImported?.products == null ||
          (latestExportByLoadType?.Date != null &&
              latestExportByLoadType!.Date!.isAfter(lastImported!.products!));
    } else if (loadType == LoadTypeEnum.users) {
      return lastImported?.users == null ||
          (latestExportByLoadType?.Date != null &&
              latestExportByLoadType!.Date!.isAfter(lastImported!.users!));
    } else if (loadType == LoadTypeEnum.enterprise) {
      return lastImported?.enterprise == null ||
          (latestExportByLoadType?.Date != null &&
              latestExportByLoadType!.Date!.isAfter(lastImported!.enterprise!));
    } else {
      return false;
    }
  }

  @override
  Future<void> newGoToConfigurationsPage({
    required String username,
    required String password,
    required ConfigurationsPresenter configurationsPresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      UserConcentratorEntity? user =
          await concentratorLogin.login(username: username, password: password);

      if (user == null) {
        throw Exception();
      } else {
        configurationsPresenter.updateLoggedUser(user);
      }

      isLoading = false;
      navigateTo.navigate(pageRoute: PageRoutes.configurations);
    } catch (e) {
      mainError = UIError.invalidCredentials;
      isLoading = false;
    }
  }

  @override
  Future<void> updateDeviceInformations() async {
    final applicationVersion = await loadDeviceData.getApplicationVersion();
    final imeiOrWindowsId = await loadDeviceData.getImeiOrWindowsId(
      isRedeVersion: isGeneratingVersionToRede,
    );

    await addDeviceInfo.add(
      commandNumber: commandEntity?.commandNumber?.toInt(),
      imeiOrWindowsId: imeiOrWindowsId,
      applicationVersion: applicationVersion,
      pdvNumber: commandEntity?.pdv?.PdvNumber,
    );
  }
}
