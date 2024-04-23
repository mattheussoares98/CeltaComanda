// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSaleRequestTempSpy extends Mock implements LoadSaleRequestTemp {
  LoadSaleRequestTempSpy() {
    mockLoadCommandsAvailable(null);
  }
  When mockLoadCommandsAvailableCall() => when(() => this.load(
        enterpriseId: any(named: "enterpriseId"),
        url: any(named: "url"),
        commandNumber: any(named: "commandNumber"),
      ));

  void mockLoadCommandsAvailable(SaleRequestTempEntity? entity) {
    this.mockLoadCommandsAvailableCall().thenAnswer((_) async => entity);
  }

  void mockError(DomainError error) {
    this.mockLoadCommandsAvailableCall().thenThrow(error);
  }
}
