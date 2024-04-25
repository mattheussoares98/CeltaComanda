import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxPrintedProductsPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements PrintedProductsPresenter {
  final NavigateTo navigateTo;

  GetxPrintedProductsPresenter({
    required this.navigateTo,
  });
}
