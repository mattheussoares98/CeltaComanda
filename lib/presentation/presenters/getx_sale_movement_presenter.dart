import '../../data/models/models.dart';
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
      sales = null;

      final loadedSales = await loadSaleMovementConcentrator.load(date: date);

      if (loadedSales == null) {
        //TODO see what is returned when dont has sales
        throw Exception();
      }

      sales = loadedSales
          .map((e) => SaleMovementConcentratorModel.fromEntity(e))
          .toList();
    } catch (error) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  final _salesStream = Rx<List<SaleMovementConcentratorModel>?>(null);
  @override
  Stream<List<SaleMovementConcentratorModel>?> get salesStream =>
      _salesStream.stream;
  set sales(List<SaleMovementConcentratorModel>? value) =>
      _salesStream.value = value;
}
