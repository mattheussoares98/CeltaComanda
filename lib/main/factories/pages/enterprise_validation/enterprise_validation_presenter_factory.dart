import 'package:clean_celta_mobile/main/factories/usecases/app_manager/android_manager_factory.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

EnterpriseValidationPresenter makeGetxEnterpriseValidationPresenter() =>
    GetxEnterpriseValidationPresenter(
      validation: makeEnterpriseValidation(),
      localEntepriseData: makeLocalEnterpriseData(),
      loadEnterpriseData: makeRemoteLoadEnterpriseData(),
      navigateTo: makeNavigateTo(),
      commandInformations: makeRemoteCommandInformations(),
      localCommandData: makeLocalUseFixedCommandNumber(),
      persistent: makeAndroidPersistent(),
    );
