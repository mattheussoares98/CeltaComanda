import '../../domain/usecases/usecases.dart';

import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';
import 'package:get/get.dart';
import '../../domain/usecases/cross_id/load_cross_id.dart';

class GetxSplashPresenter extends GetxController
    with NavigationManager
    implements SplashPresenter {
  final LoadCrossId loadCrossId;

  GetxSplashPresenter({required this.loadCrossId});

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      await loadCrossId.load();
      navigateTo = '/home';
    } catch (error) {
      navigateTo = '/login';
    }
  }
}
