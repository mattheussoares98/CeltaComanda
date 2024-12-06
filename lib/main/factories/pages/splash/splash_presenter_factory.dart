import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/usecases.dart';

SplashPresenter makeGetxSplashPresenter() => GetxSplashPresenter(
      navigateTo: makeNavigateTo(),
      loadEnterpriseData: makeLocalEnterpriseData(),
      obtainPlatform: makeFlutterGetPlatform(),
      localCommandData: makeLocalCommandData(),
      pdvRegistration: makeConcentratorPdvRegistration(),
      loadDeviceData: makeLocalLoadDeviceData(),
    );
