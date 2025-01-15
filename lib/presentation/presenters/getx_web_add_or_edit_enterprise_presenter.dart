import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxWebAddOrEditEnterprisePresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements WebAddOrEditEnterprisePresenter {
  GetxWebAddOrEditEnterprisePresenter();

  @override
  Future<void> updateEnterprise(EnterpriseEntity enterprise) async {
    //TODO update function
  }
}
