import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxWebEnterprisesPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements WebEnterprisesPresenter {
  final LoadAllEnterprises loadAllEnterprises;
  final NavigateTo navigateTo;
  final UpdateDeviceInformations updateDeviceInformations;
  final UpdateEnterpriseParameters updateEnterpriseParameters;

  GetxWebEnterprisesPresenter({
    required this.loadAllEnterprises,
    required this.navigateTo,
    required this.updateDeviceInformations,
    required this.updateEnterpriseParameters,
  });

  @override
  Future<void> loadEnterprises() async {
    try {
      isLoading = true;
      mainError = null;
      enterprises = null;

      final result = await loadAllEnterprises.load();

      enterprises = result;
    } catch (error) {
      mainError = UIError.notFound;
    } finally {
      isLoading = false;
    }
  }

  final _enterprises = Rx<List<EnterpriseEntity>?>(null);
  @override
  Stream<List<EnterpriseEntity>?> get enterprisesStream => _enterprises.stream;
  set enterprises(List<EnterpriseEntity>? value) => _enterprises.value = value;

  @override
  void goToAddOrEditEnterprise(EnterpriseEntity? enterprise) {
    try {
      mainError = null;

      _selectedEnterprise = enterprise;
      navigateTo.navigate(pageRoute: PageRoutes.webAddOrEditEnterprise);
    } catch (e) {
      mainError = UIError.unexpected;
    }
  }

  EnterpriseEntity? _selectedEnterprise;
  @override
  EnterpriseEntity? get selectedEnterprise => _selectedEnterprise;

  @override
  Future<void> updateDevicesData() async {
    try {
      isLoading = true;
      mainError = null;

      if (_selectedEnterprise == null) {
        throw Exception();
      }

      await updateDeviceInformations
          .update(_selectedEnterprise!.enterpriseName);
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<bool> updateEnterprise({
    required String navsUrl,
    required String concentratorUrl,
    required String ccsUrl,
    required int enterpriseId,
    required int? daysPreloadImage,
    required String? latestCompatibleVersion,
    required double? serviceChargePercentage,
    required bool? zoomImage,
    required bool? useCovenant,
    required String enterpriseName,
  }) async {
    try {
      isLoading = true;
      mainError = null;

      final enterprise = EnterpriseEntity(
        enterpriseName: (_selectedEnterprise?.enterpriseName ?? enterpriseName)
            .toLowerCase()
            .removeWhiteSpaces(),
        url: navsUrl.toLowerCase().removeWhiteSpaces(),
        enterpriseId: enterpriseId,
        concentradorUrl: concentratorUrl.toLowerCase().removeWhiteSpaces(),
        persistApp: false,
        urlCCS: ccsUrl.toLowerCase().removeWhiteSpaces(),
        useCovenant: useCovenant,
        enterpriseConcentradorParametersEntity: null,
        updateMenu: (_selectedEnterprise?.updateMenu ?? 0) + 1,
        serviceChargePercentageOrValue: serviceChargePercentage,
        serviceChargeType: serviceChargePercentage == null ? null : 1,
        updateDevicesInformations:
            _selectedEnterprise?.updateDevicesInformations == null
                ? null
                : (_selectedEnterprise!.updateDevicesInformations! +
                    1), //TODO clean devices before insert new devices
        updateEnterprise: (_selectedEnterprise?.updateEnterprise ?? 0) + 1,
        waitDaysToPreloadImages: daysPreloadImage,
        zoomImage: zoomImage,
        pendingDevicesToUpdate: _selectedEnterprise?.pendingDevicesToUpdate,
        updatePendingDevices: _selectedEnterprise?.updatePendingDevices,
        latestCompatibleVersion: latestCompatibleVersion,
      );

      await updateEnterpriseParameters.update(enterprise);
      return true;
    } catch (e) {
      mainError = UIError.unexpected;
      return false;
    } finally {
      isLoading = false;
    }
  }
}
