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
    required int internalCodeOnErp,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      final fathers = await getProductComposition.getFathers(
        url: url,
        enterpriseId: enterpriseId,
        internalCodeOnErp: internalCodeOnErp,
      );

      List<ProductCompositionViewModel> childs =
          await getProductComposition.getChildsOfFather(
        url: url,
        enterpriseId: enterpriseId,
        internalCodeOnErp: internalCodeOnErp,
        fathers: fathers,
      );

      _productsComposition.subject.add(childs);
    } catch (e) {
      mainError = UIError.unexpected;
      _productsComposition.subject.add([]);
    } finally {
      isLoading = false;
    }
  }

  @override
  bool comboxIsValid() {
    bool isValid = true;
    for (var element in _productsComposition.subject.value!) {
      if (element.IsOptionalItem == "false" &&
          element.indexOfSelectedChild == null) {
        return false;
      }
    }

    return isValid;
  }
}
