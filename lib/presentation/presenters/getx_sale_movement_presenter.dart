import '../../domain/usecases/usecases.dart';
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
}
