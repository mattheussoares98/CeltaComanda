import 'package:get/get.dart';


import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSplashPresenter extends GetxController
    with NavigationManager
    implements SplashPresenter {
  final LoadCrossId loadCrossId;

  GetxSplashPresenter({required this.loadCrossId});

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      CrossIdEntity? crossIdEntity = await loadCrossId.load();
      if (crossIdEntity != null) {
        navigateTo = PageRoutes.expansibleGroups;
      } else {
        navigateTo = PageRoutes.login;
      }
    } catch (error) {
      navigateTo = PageRoutes.login;
    }
  }
}
