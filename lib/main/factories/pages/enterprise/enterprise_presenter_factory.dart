import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

EnterprisePresenter makeGetxEnterprisePresenter() => GetxEnterprisePresenter(
      validation: makeEnterpriseValidation(),
      localEntepriseData: makeLocalEnterpriseData(),
      loadEnterpriseData: makeRemoteLoadEnterpriseData(),
      navigateTo: makeNavigateTo(),
      commandInformations: makeRemoteCommandInformations(),
      localCommandData: makeLocalCommandData(),
      persistent: makeAndroidPersistent(),
      loadEnterpriseConcentradorParameters:
          makeRemoteLoadEnterpriseConcentradorParameters(),
      pdvRegistration: makeConcentratorPdvRegistration(),
      loadDeviceData: makeLocalLoadDeviceData(),
      lastImport: makeLocalLastImport(),
    );
