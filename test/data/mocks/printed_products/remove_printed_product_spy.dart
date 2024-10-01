// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class RemovePrintedProductSpy extends Mock implements RemovePrintedProduct {
  RemovePrintedProductSpy() {
    mockRemovePrintedProduct();
  }
  When mockRemovePrintedProductsCall() => when(() => this.remove(
        productId: any(named: "productId"),
        url: any(named: "url"),
      ));

  void mockRemovePrintedProduct() {
    this.mockRemovePrintedProductsCall().thenAnswer((any) async => any);
  }

  void mockError(DomainError error) {
    this.mockRemovePrintedProductsCall().thenThrow(error);
  }
}
