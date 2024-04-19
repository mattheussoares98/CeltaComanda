import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final LoadApiSaleRequest loadApiSaleRequest;
  final NavigateTo navigateTo;

  GetxSplashPresenter({
    required this.loadApiSaleRequest,
    required this.navigateTo,
  });

  @override
  Future<void> checkApiSaleRequest({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      //precisa testar o local. Se não der certo, testa o remote
      ApiSaleRequestEntity? apiSaleRequestEntity = await loadApiSaleRequest.load();
      if (apiSaleRequestEntity != null) {
        navigateTo.navigate(
          pageRoute: PageRoutes.expansibleGroups,
          clear: true,
        );
      } else {
        navigateTo.navigate(
          pageRoute: PageRoutes.login,
          clear: true,
        );
      }
    } catch (error) {
      navigateTo.navigate(pageRoute: PageRoutes.login, clear: true);
    }
  }
}
