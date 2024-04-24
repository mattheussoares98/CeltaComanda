// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadPrintedProductsSpy extends Mock
    implements LoadPrintedProducts {
  LoadPrintedProductsSpy() {
    mockLoadPrintedProducts(null);
  }
  When mockLoadPrintedProductsCall() => when(() => this.load(
        enterpriseId: any(named: "enterpriseId"),
        url: any(named: "url"),
        commandNumber: any(named: "commandNumber"),
      ));

  void mockLoadPrintedProducts(PrintedProductsEntity? entity) {
    this.mockLoadPrintedProductsCall().thenAnswer((_) async => entity);
  }

  void mockError(DomainError error) {
    this.mockLoadPrintedProductsCall().thenThrow(error);
  }
}
