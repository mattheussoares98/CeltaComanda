import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxCancelProductsPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements CancelProductsPresenter {
  // GetxCancelProductsPresenter({
  // });

  @override
  Future<void> cancelProduct(String productId) async {
    isLoading = true;
    mainError = null;

    try {} catch (e) {
      e;
    } finally {
      isLoading = false;
    }
  }
}
