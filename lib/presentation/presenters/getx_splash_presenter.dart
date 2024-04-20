import 'package:get/get.dart';

import 'package:clean_celta_mobile/main/builders/builders.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final LoadApiSaleRequest loadApiSaleRequest;
  final LoadLoginData loadLoginData;
  final NavigateTo navigateTo;

  GetxSplashPresenter({
    required this.loadApiSaleRequest,
    required this.navigateTo,
    required this.loadLoginData,
  });

  @override
  Future<void> checkApiSaleRequest({
    int durationInSeconds = 2,
  }) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      LoginDataBuilder.loginDataEntity = await loadLoginData.load();

      if (LoginDataBuilder.loginDataEntity == null) {
        navigateTo.navigate(
          pageRoute: PageRoutes.expansibleGroups,
          clear: true,
        );
      }

      ApiSaleRequestEntity? apiSaleRequestEntity =
          await loadApiSaleRequest.load(
        enterpriseId: LoginDataBuilder.loginDataEntity!.enterpriseId!,
        url: LoginDataBuilder.loginDataEntity!.url,
      );
      if (apiSaleRequestEntity != null) {
        navigateTo.navigate(
          pageRoute: PageRoutes.expansibleGroups,
          clear: true,
        );
      } else {
        navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation,
          clear: true,
        );
      }
    } catch (error) {
      navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation, clear: true);
    }
  }
}
