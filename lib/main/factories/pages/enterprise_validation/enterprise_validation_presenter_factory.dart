import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

LoginPresenter makeGetxEnterpriseValidationPresenter() => GetxLoginPresenter(
  validation: makeEnterpriseValidation(),
  localLoginData: makeLocalLoadLoginData(),
  remoteLoginData: makeRemoteLoginData(),
  navigateTo: makeNavigateTo(),
);