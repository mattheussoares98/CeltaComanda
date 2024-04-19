import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final NavigateTo navigateTo;

  GetxSplashPresenter({
    required this.navigateTo,
  });

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      navigateTo.navigate(
        pageRoute: PageRoutes.expansibleGroups,
        clear: true,
      );
      navigateTo.navigate(
        pageRoute: PageRoutes.login,
        clear: true,
      );
    } catch (error) {
      navigateTo.navigate(pageRoute: PageRoutes.login, clear: true);
    }
  }
}
