import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../protocols/protocols.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxEnterprisePresenter extends GetxController
    with LoadingManager, FormManager, UIErrorManager
    implements EnterprisePresenter {
  final Validation validation;
  final LocalEnterpriseData localEntepriseData;
  final LoadEnterpriseData loadEnterpriseData;
  final NavigateTo navigateTo;
  final CommandInformations commandInformations;
  final LocalCommandData localCommandData;
  final Persistent persistent;
  final LoadEnterpriseConcentradorParameters
      loadEnterpriseConcentradorParameters;
  final PdvRegistration pdvRegistration;
  final LoadDeviceData loadDeviceData;

  GetxEnterprisePresenter({
    required this.validation,
    required this.localEntepriseData,
    required this.loadEnterpriseData,
    required this.navigateTo,
    required this.commandInformations,
    required this.localCommandData,
    required this.persistent,
    required this.loadEnterpriseConcentradorParameters,
    required this.pdvRegistration,
    required this.loadDeviceData,
  });

  @override
  Future<void> updateEnterpriseWithLocalData() async {
    isLoading = true;
    mainError = null;
    try {
      EnterpriseDataBuilder.enterpriseDataEntity =
          await localEntepriseData.load();
    } catch (e) {
      e;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> validateEnterpriseByName({
    required bool isFixedCommandNumber,
    required String? commandNumber,
    required HomePresenter homePresenter,
  }) async {
    try {
      mainError = null;
      isLoading = true;

      if (isUpdatedEnterpriseName ||
          EnterpriseDataBuilder.enterpriseDataEntity!.url == null) {
        final firebaseData = await loadEnterpriseData.load();

        if (firebaseData == null) {
          throw DomainError.enterpriseOrUrlNotFound;
        } else {
          final concentradorData =
              await loadEnterpriseConcentradorParameters.load(
            concentradorUrl: firebaseData.concentradorUrl!,
            enterpriseId: firebaseData.enterpriseId!,
          );

          EnterpriseDataBuilder.enterpriseDataEntity = EnterpriseEntity(
            enterpriseName: firebaseData.enterpriseName,
            url: firebaseData.url,
            enterpriseId: firebaseData.enterpriseId,
            concentradorUrl: firebaseData.concentradorUrl,
            persistApp: firebaseData.persistApp,
            urlCCS: firebaseData.urlCCS,
            useCovenant: firebaseData.useCovenant,
            enterpriseConcentradorParametersEntity: concentradorData,
            updateMenu: firebaseData.updateMenu,
            updateConcentratorEnterpriseData:
                firebaseData.updateConcentratorEnterpriseData,
            updateDevicesInformations: firebaseData.updateDevicesInformations,
            serviceChargePercentageOrValue:
                firebaseData.serviceChargePercentageOrValue,
            serviceChargeType: firebaseData.serviceChargeType,
            updateEnterprise: firebaseData.updateEnterprise,
            zoomImage: firebaseData.zoomImage,
            pendingDevicesToUpdate: firebaseData.pendingDevicesToUpdate,
            updatePendingDevices: firebaseData.updatePendingDevices,
          );

          await localEntepriseData
              .add(EnterpriseDataBuilder.enterpriseDataEntity!);
        }
      }

      await commandInformations.ticketIsPermitted(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        commandNumber: commandNumber == null || commandNumber.isEmpty == true
            ? "001"
            : commandNumber.padLeft(3, "0"),
      );

      await localCommandData.update(
        CommandEntity(
          commandNumber: commandNumber == null || commandNumber.isEmpty == true
              ? null
              : commandNumber.padLeft(3, "0"),
          isFixedCommandNumber: isFixedCommandNumber,
          pdv: null,
        ),
      );

      if (EnterpriseDataBuilder.enterpriseDataEntity?.persistApp == true &&
          !homePresenter.isGeneratingVersionToRede &&
          !homePresenter.isGeneratingVersionToGetNet) {
        await persistent.makePersistent();
      } else {
        await persistent.makeNotPersistent();
      }

      if (homePresenter.isGeneratingVersionToGetNet ||
          homePresenter.isGeneratingVersionToRede) {
        final pdvs = await pdvRegistration.getPdvNotUsing();
        pdvsNotUsing =
            pdvs.map((e) => PdvNotUsingViewModel.fromEntity(e)).toList();
      } else {
        isLoading = false;
        navigateTo.navigate(pageRoute: PageRoutes.home, clear: true);
      }
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
          break;
        case DomainError.dontHaveUnusedPdvs:
          mainError = UIError.dontHaveUnusedPdvs;
          break;
        case DomainError.enterpriseOrUrlNotFound:
          mainError = UIError.enterpriseOrUrlNotFound;
          break;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void validateEnterpriseInput(
    String enterpriseName, {
    bool? updateEnterpriseNameController = false,
  }) {
    EnterpriseDataBuilder.enterpriseDataEntity = EnterpriseEntity(
      enterpriseName: enterpriseName,
      url: null,
      enterpriseId: null,
      concentradorUrl: null,
      persistApp: null,
      urlCCS: null,
      useCovenant: null,
      enterpriseConcentradorParametersEntity: null,
      updateMenu: null,
      updateConcentratorEnterpriseData: null,
      serviceChargePercentageOrValue: null,
      serviceChargeType: null,
      updateDevicesInformations: null,
      updateEnterprise: null,
      zoomImage: null,
      pendingDevicesToUpdate: null,
      updatePendingDevices: null,
    );

    _enterpriseError.value =
        _validateField(field: "enterpriseName", enterpriseName: enterpriseName);
    _validateForm(enterpriseName);
    if (updateEnterpriseNameController == true) {
      isUpdatedEnterpriseName = true;
    }
  }

  UIError? _validateField({
    required String field,
    required String enterpriseName,
  }) {
    final formData = {
      'enterpriseName': enterpriseName,
    };
    final error = validation.validate(field: field, input: formData);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validateForm(String enterpriseName) {
    isFormValid =
        _enterpriseError.value == null && enterpriseName.isNotEmpty == true;
  }

  @override
  Future<void> updateConcentratorEnterpriseParameters() async {
    try {
      final enterprise = EnterpriseDataBuilder.enterpriseDataEntity!;
      final concentradorData = await loadEnterpriseConcentradorParameters.load(
        concentradorUrl: enterprise.concentradorUrl!,
        enterpriseId: enterprise.enterpriseId!,
      );

      EnterpriseDataBuilder.enterpriseDataEntity = EnterpriseEntity(
        enterpriseName: enterprise.enterpriseName,
        url: enterprise.url,
        enterpriseId: enterprise.enterpriseId,
        concentradorUrl: enterprise.concentradorUrl,
        persistApp: enterprise.persistApp,
        urlCCS: enterprise.urlCCS,
        useCovenant: enterprise.useCovenant,
        enterpriseConcentradorParametersEntity: concentradorData,
        updateMenu: enterprise.updateMenu,
        updateConcentratorEnterpriseData:
            enterprise.updateConcentratorEnterpriseData,
        updateDevicesInformations: enterprise.updateDevicesInformations,
        serviceChargePercentageOrValue:
            enterprise.serviceChargePercentageOrValue,
        serviceChargeType: enterprise.serviceChargeType,
        updateEnterprise: enterprise.updateEnterprise,
        zoomImage: enterprise.zoomImage,
        pendingDevicesToUpdate: enterprise.pendingDevicesToUpdate,
        updatePendingDevices: enterprise.updatePendingDevices,
      );

      await localEntepriseData.add(EnterpriseDataBuilder.enterpriseDataEntity!);
    } catch (e) {
      e;
    }
  }

  @override
  Future<void> clearEnterpriseData() async {
    try {
      final oldEnterpriseName =
          EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName;

      final newEnterprise = EnterpriseEntity(
        enterpriseName: oldEnterpriseName ?? "",
        url: null,
        enterpriseId: null,
        concentradorUrl: null,
        persistApp: null,
        urlCCS: null,
        useCovenant: null,
        enterpriseConcentradorParametersEntity: null,
        updateMenu: null,
        updateConcentratorEnterpriseData: null,
        serviceChargePercentageOrValue: null,
        serviceChargeType: null,
        updateDevicesInformations: null,
        updateEnterprise: null,
        zoomImage: null,
        pendingDevicesToUpdate: null,
        updatePendingDevices: null,
      );

      EnterpriseDataBuilder.enterpriseDataEntity = newEnterprise;

      await localEntepriseData.add(newEnterprise);
    } catch (e) {
      e;
    }
  }

  @override
  void updateSelectedPdv(PdvNotUsingViewModel pdv) {
    _selectedPdv.value = pdv;
  }

  @override
  Future<void> registerPdvAndGoToHomePage({
    required PdvNotUsingViewModel selectedPdv,
    required String? commandNumber,
    required bool isFixedCommandNumber,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      final imeiOrWindowsId = await loadDeviceData.getImeiOrWindowsId();
      final applicationVersion = await loadDeviceData.getApplicationVersion();

      await pdvRegistration.setPdvRegister(
        pdvId: selectedPdv.PdvId.toInt(),
        imeiOrWindowsId: imeiOrWindowsId,
        versionNumber: applicationVersion,
      );

      await localCommandData.update(
        CommandEntity(
          commandNumber: commandNumber?.toString().padLeft(3, "0"),
          isFixedCommandNumber: isFixedCommandNumber,
          pdv: selectedPdv.toEntity(),
        ),
      );

      navigateTo.navigate(pageRoute: PageRoutes.home, clear: true);
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  bool isUpdatedEnterpriseName = false;

  final _enterpriseError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get enterpriseErrorStream => _enterpriseError.stream;

  final _pdvsNotUsing = Rx<List<PdvNotUsingViewModel>?>(null);
  @override
  Stream<List<PdvNotUsingViewModel>?> get pdvsNotUsingStream =>
      _pdvsNotUsing.stream;
  set pdvsNotUsing(List<PdvNotUsingViewModel>? value) =>
      _pdvsNotUsing.value = value;

  final _selectedPdv = Rx<PdvNotUsingViewModel?>(null);
  @override
  Stream<PdvNotUsingViewModel?> get selectedPdvStream => _selectedPdv.stream;
}
