import 'package:clean_celta_mobile/main/factories/usecases/app_manager/app_manager.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

HomePresenter makeGetxHomePresenter() => GetxHomePresenter(
      localEnterpriseData: makeLocalEnterpriseData(),
      navigateTo: makeNavigateTo(),
      commandInformations: makeRemoteCommandInformations(),
      localCommandData: makeLocalUseFixedCommandNumber(),
      userValidations: makeRemoteUserValidations(),
      loadSaleRequestTemp: makeRemoteLoadSaleRequestTemp(),
      updateSaleRequestTemp: makeRemoteUpdateSaleRequestTemp(),
      loadSellers: makeRemoteLoadSellers(),
      persistent: makeAndroidPersistent(),
      alreadyPaid: makeLocalAlreadyPaid(),
    );
