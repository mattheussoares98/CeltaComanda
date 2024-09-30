import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxCovenantPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements CovenantPresenter {
  GetxCovenantPresenter();

  @override
  Future<void> getCustomer() async {}
}
