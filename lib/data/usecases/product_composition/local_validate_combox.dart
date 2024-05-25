import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import '../../../ui/pages/pages.dart';

class LocalValidateCombox implements ValidateCombox {
  @override
  comboxIsValid(List<ProductCompositionViewModel> productsComposition) {
    for (var element in productsComposition) {
      if (element.IsOptionalItem == "false" &&
          element.indexOfSelectedChild == null) {
        throw DomainError.invalidCombox;
      }
    }
  }
}
