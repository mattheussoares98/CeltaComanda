import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

LoginPresenter makeGetxLoginPresenter() => GetxLoginPresenter(
  authentication: makeRemoteAuthentication(),
  validation: makeLoginValidation(),
  saveCrossId: makeLocalSaveCrossId(),
  saveUrl: makeLocalSaveUrl(),
  saveUser: makeLocalSaveUser(),
);