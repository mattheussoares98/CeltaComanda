import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxCovenantPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements CovenantPresenter {
  final LoadCustomer loadCustomer;
  GetxCovenantPresenter({
    required this.loadCustomer,
  });

  @override
  Future<void> getCustomer(String value) async {
    mainError = null;
    isLoading = true;
    try {} catch (e) {
      e;
    } finally {
      isLoading = false;
    }
  }
}
