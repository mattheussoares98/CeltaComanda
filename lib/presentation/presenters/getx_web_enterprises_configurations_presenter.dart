import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxWebEnterprisesConfigurationsPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements WebEnterprisesConfigurationsPresenter {
  GetxWebEnterprisesConfigurationsPresenter();

  @override
  Future<void> loadEnterprises() async {
    try {
      isLoading = true;
      mainError = null;
    } catch (error) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
