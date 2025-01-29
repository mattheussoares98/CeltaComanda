import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

HomePresenter makeGetxHomePresenter() => GetxHomePresenter(
      localEnterpriseData: makeLocalEnterpriseData(),
      navigateTo: makeNavigateTo(),
      commandInformations: makeRemoteCommandInformations(),
      localCommandData: makeLocalCommandData(),
      userValidations: makeRemoteUserValidations(),
      loadSaleRequestTemp: makeRemoteLoadSaleRequestTemp(),
      updateSaleRequestTemp: makeRemoteUpdateSaleRequestTemp(),
      loadSellers: makeRemoteLoadSellers(),
      persistent: makeAndroidPersistent(),
      addDeviceInfo: makeRemoteAddDeviceInfo(),
      addPendingDeviceToUpdate: makeRemoteAddPendingDeviceToUpdate(),
      loadDeviceData: makeLocalLoadDeviceData(),
      pdvRegistration: makeConcentratorPdvRegistration(),
      deleteData: makeLocalDeleteData(),
    );
