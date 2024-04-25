// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class ClearExpansibleGroupsSpy extends Mock implements ClearExpansibleGroups {
  ClearExpansibleGroupsSpy() {
    mockLoadPrintedProducts([]);
  }

  When mockLoadPrintedProductsCall() => when(() => this.clear());

  void mockLoadPrintedProducts(List<ExpansibleGroupsViewModel> value) {
    this.mockLoadPrintedProductsCall().thenAnswer((_) => value);
  }
}
