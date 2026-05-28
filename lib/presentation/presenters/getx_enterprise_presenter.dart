import 'package:clean_celta_mobile/presentation/helpers/app_platform.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';
import '../protocols/protocols.dart';

class GetxEnterprisePresenter extends GetxController
    with LoadingManager, FormManager, UIErrorManager, ErrorHandling
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
  final LastImport lastImport;

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
    required this.lastImport,
  });

  @override
  Future<void> updateEnterpriseWithLocalData() async {
    isLoading = true;
    mainError = null;
    try {
      EnterpriseBuilder.entity = await localEntepriseData.load();
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

      if (isUpdatedEnterpriseName || EnterpriseBuilder.entity!.url == null) {
        final firebaseData = await loadEnterpriseData.load();

        if (firebaseData == null) {
          throw DomainError.enterpriseOrUrlNotFound;
        } else {
          final concentradorData =
              await loadEnterpriseConcentradorParameters.load(
            concentradorUrl: firebaseData.concentradorUrl!,
            enterpriseId: firebaseData.enterpriseId!,
          );

          EnterpriseBuilder.entity = EnterpriseEntity(
            enterpriseName: firebaseData.enterpriseName,
            url: firebaseData.url,
            enterpriseId: firebaseData.enterpriseId,
            concentradorUrl: firebaseData.concentradorUrl,
            persistApp: firebaseData.persistApp,
            urlCCS: firebaseData.urlCCS,
            useCovenant: firebaseData.useCovenant,
            enterpriseConcentradorParametersEntity: concentradorData,
            updateDevicesInformations: firebaseData.updateDevicesInformations,
            serviceChargePercentageOrValue:
                firebaseData.serviceChargePercentageOrValue,
            updateEnterprise: firebaseData.updateEnterprise,
            zoomImage: firebaseData.zoomImage,
            latestCompatibleVersion: firebaseData.latestCompatibleVersion,
            minutesVerifyUpdateMenu: firebaseData.minutesVerifyUpdateMenu,
            useReducedNameOnProduct: firebaseData.useReducedNameOnProduct,
            verifyCommandBlocked: firebaseData.verifyCommandBlocked,
            canInsertCommentManually: firebaseData.canInsertCommentManually,
            blockUseAppIfIsOutdated: firebaseData.blockUseAppIfIsOutdated,
            canInsertQuantityManually: firebaseData.canInsertQuantityManually,
            canInsertCustomer: firebaseData.canInsertCustomer,
            requestTableNumber: firebaseData.requestTableNumber,
            useOldPrintWay: firebaseData.useOldPrintWay,
            httpsUrl: firebaseData.httpsUrl,
          );

          await localEntepriseData.add(EnterpriseBuilder.entity!);
        }
      }

      await commandInformations.ticketIsPermitted(
        url: EnterpriseBuilder.entity!.url!,
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

      if (EnterpriseBuilder.entity?.persistApp == true &&
          !activePlatform.isPaymentPlatform) {
        await persistent.makePersistent();
      } else {
        await persistent.makeNotPersistent();
      }

      var pdvs = await pdvRegistration.getByEnterpriseId();

      bool removedAny = await _removeRegistration(pdvs);
      if (removedAny) {
        pdvs = await pdvRegistration.getByEnterpriseId();
      }

      pdvsNotUsing = pdvs
          .where((e) =>
              e.IsUsing == false &&
              e.PdvNumber?.toInt() != null &&
              e.PdvNumber!.toInt() >= 100)
          .map((e) => PdvNotUsingViewModel.fromEntity(e))
          .toList();

      if (pdvs
          .where((e) =>
              e.PdvNumber != null &&
              e.PdvNumber!.toInt() >= 100 &&
              e.IsUsing != true)
          .isEmpty) {
        throw DomainError.dontHaveUnusedPdvs;
      }
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  Future<bool> _removeRegistration(List<PdvEntity> pdvs) async {
    try {
      bool removedAny = false;

      if (pdvs.isNotEmpty) {
        final atualDate = DateTime.now();
        for (var pdv in pdvs) {
          if (pdv.VersionNumber?.contains("=") == false) {
            continue;
          }

          final parts = pdv.VersionNumber?.split('=');
          if (parts?.length == 2) {
            final lastUpdatedDate = parts![1].trim();
            final differenceDays = DateFormat('dd/MM/yyyy')
                .parse(lastUpdatedDate)
                .difference(atualDate)
                .inDays
                .abs();

            differenceDays.toString();

            if (differenceDays > 30) {
              await pdvRegistration.setPdvRegister(
                pdvId: pdv.PdvId?.toInt() ?? 99999,
                imeiOrWindowsId: "",
                versionNumber: "",
                ip: "",
                isUsing: false,
              );
              removedAny = true;
            }
          }
        }
      }
      return removedAny;
    } catch (e) {
      return false;
    }
  }

  @override
  void validateEnterpriseInput(
    String enterpriseName, {
    bool? updateEnterpriseNameController = false,
  }) {
    EnterpriseBuilder.entity = EnterpriseEntity.empty(enterpriseName);

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
      final enterprise = EnterpriseBuilder.entity!;
      final concentradorData = await loadEnterpriseConcentradorParameters.load(
        concentradorUrl: enterprise.concentradorUrl!,
        enterpriseId: enterprise.enterpriseId!,
      );

      await lastImport.save([LoadTypeEnum.enterprise]);

      EnterpriseBuilder.entity = enterprise.copyWith(
          enterpriseConcentradorParametersEntity: concentradorData);

      await localEntepriseData.add(EnterpriseBuilder.entity!);
    } catch (e) {
      e;
    }
  }

  @override
  Future<void> clearEnterpriseData() async {
    try {
      final oldEnterpriseName = EnterpriseBuilder.entity?.enterpriseName;

      final newEnterprise = EnterpriseEntity.empty(oldEnterpriseName ?? "");

      EnterpriseBuilder.entity = newEnterprise;

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
        ip: "127.0.0.1",
        isUsing: true,
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
      mainError = getUIError(e);
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
