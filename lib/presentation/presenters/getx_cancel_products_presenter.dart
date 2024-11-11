import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxCancelProductsPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements CancelProductsPresenter {
  final RemovePrintedProduct removePrintedProduct;

  GetxCancelProductsPresenter({
    required this.removePrintedProduct,
  });

  @override
  Future<void> cancelProduct(String productId) async {
    isLoading = true;
    mainError = null;

    try {
      await removePrintedProduct.remove(productId);
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
