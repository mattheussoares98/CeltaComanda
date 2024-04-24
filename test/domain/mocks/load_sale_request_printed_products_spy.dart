// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSaleRequestPrintedProductsSpy extends Mock
    implements LoadSaleRequestPrintedProducts {
  LoadSaleRequestPrintedProductsSpy() {
    mockLoadSaleRequestTemp(null);
  }
  When mockLoadSaleRequestTempCall() => when(() => this.load(
        enterpriseId: any(named: "enterpriseId"),
        url: any(named: "url"),
        commandNumber: any(named: "commandNumber"),
      ));

  void mockLoadSaleRequestTemp(SaleRequestTempEntity? entity) {
    this.mockLoadSaleRequestTempCall().thenAnswer((_) async => entity);
  }

  void mockError(DomainError error) {
    this.mockLoadSaleRequestTempCall().thenThrow(error);
  }
}
