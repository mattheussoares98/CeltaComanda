import '../../../domain/usecases/usecases.dart';
import '../../../ui/pages/pages.dart';

class LocalValidateCombox implements ValidateCombox {
  @override
  bool comboxIsValid(List<ProductCompositionViewModel> productsComposition) {
    bool isValid = true;
    for (var element in productsComposition) {
      if (element.IsOptionalItem == "false" &&
          element.indexOfSelectedChild == null) {
        return false;
      }
    }
    return isValid;
  }
}
