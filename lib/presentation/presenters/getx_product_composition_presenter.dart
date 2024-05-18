import 'package:clean_celta_mobile/data/usecases/usecases.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxProductCompositionPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements ProductCompositionPresenter {
  final RemoteGetProductComposition getProductComposition;

  GetxProductCompositionPresenter({
    required this.getProductComposition,
  });

  final _productsComposition = Rx<List<ProductCompositionViewModel>?>(null);
  @override
  Stream<List<ProductCompositionViewModel>?> get productsComposition =>
      _productsComposition.stream;

  @override
  Future<void> loadProductComposition({
    required String url,
    required int enterpriseId,
    required int internalCodeOnERPCodeFather,
  }) async {
    isLoading = true;
    mainError = null;
    _productsComposition.subject.add(null);
    try {
      final productsComposition = await getProductComposition.getProducts(
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
    } finally {
      isLoading = false;
    }
  }
}
