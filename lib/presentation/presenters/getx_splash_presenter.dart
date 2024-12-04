import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final LoadEnterpriseData loadEnterpriseData;
  final NavigateTo navigateTo;
  final ObtainPlataform obtainPlatform;

  GetxSplashPresenter({
    required this.navigateTo,
    required this.loadEnterpriseData,
    required this.obtainPlatform,
  });

  @override
  Future<void> checkPageToGo({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      EnterpriseDataBuilder.enterpriseDataEntity =
          await loadEnterpriseData.load();
      bool isWeb = obtainPlatform.isWeb();

      if (isWeb) {
        navigateTo.navigate(pageRoute: PageRoutes.webLogin, clear: true);
      } else if (EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseId ==
              null ||
          EnterpriseDataBuilder.enterpriseDataEntity?.url == null) {
        navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation,
          clear: true,
        );
      } else {
        //TODO if is generating version to getnet or rede and dont have pdv number, cant navigate to home page
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
