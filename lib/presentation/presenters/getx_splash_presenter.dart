import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final LoadEnterpriseData loadEnterpriseData;
  final NavigateTo navigateTo;
  final ObtainPlataform obtainPlatform;
  final LocalCommandData localCommandData;

  GetxSplashPresenter({
    required this.navigateTo,
    required this.loadEnterpriseData,
    required this.obtainPlatform,
    required this.localCommandData,
  });

  @override
  Future<void> checkPageToGo({
    required HomePresenter homePresenter,
    int durationInSeconds = 2,
  }) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      EnterpriseBuilder.entity = await loadEnterpriseData.load();
      bool isWeb = obtainPlatform.isWeb();

      final localCommandEntity = await localCommandData.load();

      if (isWeb) {
        navigateTo.navigate(pageRoute: PageRoutes.webLogin, clear: true);
      } else if (EnterpriseBuilder.entity?.enterpriseId == null ||
          EnterpriseBuilder.entity?.url == null) {
        navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation,
          clear: true,
        );
      } else if (localCommandEntity?.pdv == null &&
          (homePresenter.isGeneratingVersionToGetNet ||
              homePresenter.isGeneratingVersionToRede)) {
        navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation,
          clear: true,
        );
      } else {
        navigateTo.navigate(
          pageRoute: PageRoutes.home,
          clear: true,
        );
      }
    } catch (error) {
      navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation, clear: true);
    }
  }
}
