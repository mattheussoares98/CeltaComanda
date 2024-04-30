// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class UpdateProductQuantitySpy extends Mock implements UpdateProductQuantity {
  UpdateProductQuantitySpy() {
    mockAddProductQuantity();
  }
  When mockAddProductQuantityCall() => when(() => this.add(
        url: any(named: "url"),
        saleRequestProductTempId: any(named: "saleRequestProductTempId"),
      ));

  void mockAddProductQuantity() {
    this.mockAddProductQuantityCall().thenAnswer((_) async => _);
  }

  void mockAddProductQuantityError() {
    this.mockAddProductQuantityCall().thenThrow(Exception());
  }

  When mockSubtractProductQuantityCall() => when(() => this.subtract(
        url: any(named: "url"),
        saleRequestProductTempId: any(named: "saleRequestProductTempId"),
      ));

  void mockSubtractProductQuantity() {
    this.mockSubtractProductQuantityCall().thenAnswer((_) async => _);
  }

  void mockSubtractProductQuantityError() {
    this.mockSubtractProductQuantityCall().thenThrow(Exception());
  }
}
