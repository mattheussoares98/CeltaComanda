import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

EnterpriseValidationPresenter makeGetxEnterpriseValidationPresenter() =>
    GetxEnterpriseValidationPresenter(
      validation: makeEnterpriseValidation(),
      localEntepriseData: makeLocalEnterpriseData(),
      remoteEnterpriseData: makeRemoteEnterpriseData(),
      navigateTo: makeNavigateTo(),
      loadCommandsAvailable: makeRemoteLoadCommandsAvailable(),
    );
