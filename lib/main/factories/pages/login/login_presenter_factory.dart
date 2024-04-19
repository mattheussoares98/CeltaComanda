import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

LoginPresenter makeGetxLoginPresenter() => GetxLoginPresenter(
  validation: makeLoginValidation(),
  localLoginData: makeLocalLoadLoginData(),
  remoteLoginData: makeRemoteLoginData(),
  navigateTo: makeNavigateTo(),
);