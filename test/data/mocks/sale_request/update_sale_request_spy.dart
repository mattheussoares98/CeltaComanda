// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class UpdateSaleRequestSpy extends Mock implements UpdateSaleRequest {
  UpdateSaleRequestSpy() {
    this.mockUpdateSaleRequest();
  }
  When mocUpdateSaleRequestCall() => when(() => this.update(
        model: any(named: "model"),
        commandNumber:
            any(named: "commandNumber"),
        saleRequestId: any(named: "saleRequestId"),
      ));

  void mockUpdateSaleRequest() {
    this.mocUpdateSaleRequestCall().thenAnswer((any) async => any);
  }

  void mockUpdateSaleRequestError(DomainError error) {
    this.mocUpdateSaleRequestCall().thenThrow(error);
  }
}
