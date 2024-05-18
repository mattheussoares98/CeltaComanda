import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxProductCompositionPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements ProductCompositionPresenter {
  final GetProductComposition getProductComposition;

  GetxProductCompositionPresenter({
    required this.getProductComposition,
  });

  final _productsComposition = Rx<List<ProductCompositionViewModel>>([]);
  @override
  Stream<List<ProductCompositionViewModel>> get productsCompositionStream =>
      _productsComposition.stream;

  @override
  Future<void> loadProductComposition({
    required String url,
    required int enterpriseId,
    required int internalCodeOnERPCodeFather,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      final productsComposition = await getProductComposition.get(
        url: url,
        enterpriseId: enterpriseId,
        internalCodeOnERPCodeFather: internalCodeOnERPCodeFather,
      );

      _productsComposition.subject.add(
        productsComposition
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );
    } catch (e) {
      mainError = UIError.unexpected;
      _productsComposition.subject.add([]);
    } finally {
      isLoading = false;
    }
  }
}
