import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxWebEnterprisesPresenter extends GetxController
    with LoadingManager, UIErrorManager, ErrorHandling
    implements WebEnterprisesPresenter {
  final LoadAllEnterprises loadAllEnterprises;
  final NavigateTo navigateTo;
  final UpdateDeviceInformations updateDeviceInformations;
  final UpdateEnterpriseParameters updateEnterpriseParameters;
  final DeleteEnterprise deleteEnterprise;
  final LoadDevicesInfo loadDevicesInfo;

  GetxWebEnterprisesPresenter({
    required this.loadAllEnterprises,
    required this.navigateTo,
    required this.updateDeviceInformations,
    required this.updateEnterpriseParameters,
    required this.deleteEnterprise,
    required this.loadDevicesInfo,
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
      mainError = getUIError(e);
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
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<bool> updateEnterprise(EnterpriseEntity entity) async {
    try {
      isLoading = true;
      mainError = null;

      final enterprise = entity.copyWith(
        enterpriseName:
            (_selectedEnterprise?.enterpriseName ?? entity.enterpriseName)
                .toLowerCase()
                .removeWhiteSpaces(),
        updateDevicesInformations:
            _selectedEnterprise?.updateDevicesInformations == null
                ? null
                : (_selectedEnterprise!.updateDevicesInformations! + 1),
        persistApp: false,
        enterpriseConcentradorParametersEntity: null,
        updateEnterprise: (_selectedEnterprise?.updateEnterprise ?? 0) + 1,
        url: entity.url?.toLowerCase().removeWhiteSpaces(),
        concentradorUrl:
            entity.concentradorUrl?.toLowerCase().removeWhiteSpaces(),
        urlCCS: entity.urlCCS?.toLowerCase().removeWhiteSpaces(),
      );

      await updateEnterpriseParameters.update(enterprise);
      return true;
    } catch (e) {
      mainError = getUIError(e);
      return false;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<bool> deleteEnterpriseData() async {
    try {
      isLoading = true;
      mainError = null;

      if (_selectedEnterprise == null) {
        throw Exception();
      }

      await deleteEnterprise.delete(_selectedEnterprise!.enterpriseName);
      return true;
    } catch (e) {
      mainError = getUIError(e);
      return false;
    } finally {
      isLoading = false;
    }
  }

  final _devicesStream = Rx<List<DeviceInfoViewModel>?>(null);
  @override
  Stream<List<DeviceInfoViewModel>?> get devicesStream => _devicesStream.stream;
  set devices(List<DeviceInfoViewModel>? value) => _devicesStream.value = value;

  @override
  Future<void> getDevicesInfo() async {
    try {
      isLoading = true;
      mainError = null;
      devices = null;

      if (_selectedEnterprise == null) {
        throw DomainError.unexpected;
      }

      final result =
          await loadDevicesInfo.load(_selectedEnterprise!.enterpriseName);

      devices = result.map((e) => DeviceInfoViewModel.fromEntity(e)).toList();
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToDevicesInfoPage() {
    navigateTo.navigate(pageRoute: PageRoutes.webDevicesInfo);
  }
}
