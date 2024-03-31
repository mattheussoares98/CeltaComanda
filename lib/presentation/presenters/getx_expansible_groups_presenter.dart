import 'package:clean_celta_mobile/ui/pages/expansible_groups/expansible_groups.dart';
import 'package:get/get.dart';

import '../mixins/mixins.dart';

class GetxExpansibleGroupsPresenter extends GetxController
    with LoadingManager, NavigationManager, UIErrorManager
    implements ExpansibleGroupPresenter {
  @override
  Future<void> getProducts() async {
    isLoading = true;
    Future.delayed(const Duration(seconds: 5), () {
      isLoading = false;
    });
  }
}
