import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxWebEnterprisesConfigurationsPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements WebEnterprisesConfigurationsPresenter {
  final LoadAllEnterprises loadAllEnterprises;

  GetxWebEnterprisesConfigurationsPresenter({
    required this.loadAllEnterprises,
  });

  @override
  Future<void> loadEnterprises() async {
    try {
      isLoading = true;
      mainError = null;

      final result = await loadAllEnterprises.loadAll();
    } catch (error) {
      mainError = UIError.notFound;
    } finally {
      isLoading = false;
    }
  }
}
