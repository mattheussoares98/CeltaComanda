import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxSaleMovementPresenter extends GetxController
    with LoadingManager, FormManager, UIErrorManager
    implements SaleMovementPresenter {
  final LoadSaleMovementConcentrator loadSaleMovementConcentrator;

  GetxSaleMovementPresenter({
    required this.loadSaleMovementConcentrator,
  });

  @override
  Future<void> loadSales({required String date}) async {
    try {
      isLoading = true;
      mainError = null;
      final sales = await loadSaleMovementConcentrator.load(date: date);
    } catch (error) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
