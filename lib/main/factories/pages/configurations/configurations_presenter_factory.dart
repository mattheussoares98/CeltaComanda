import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/usecases.dart';

ConfigurationsPresenter makeConfigurationsPresenter() =>
    GetxConfigurationsPresenter(
      userValidations: makeRemoteUserValidations(),
      commandInformations: makeRemoteCommandInformations(),
      navigateTo: makeNavigateTo(),
      persistent: makeAndroidPersistent(),
    );
