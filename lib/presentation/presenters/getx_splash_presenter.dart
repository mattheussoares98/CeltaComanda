import 'package:clean_celta_mobile/domain/entities/entities.dart';

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
      CrossIdEntity? crossIdEntity = await loadCrossId.load();
      if (crossIdEntity != null) {
        navigateTo = '/expansible_groups';
      } else {
        navigateTo = '/login';
      }
    } catch (error) {
      navigateTo = '/login';
    }
  }
}
