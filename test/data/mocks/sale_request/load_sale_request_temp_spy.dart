// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSaleRequestTempSpy extends Mock implements LoadSaleRequestTemp {
  When _mockLoadSaleRequestTempCall() => when(() => this.load(
        commandNumber: any(named: "commandNumber"),
      ));

  void mockLoadSaleRequestTemp(SaleRequestTempEntity entity) {
    this._mockLoadSaleRequestTempCall().thenAnswer((_) async => entity);
  }

  void mockError(DomainError error) {
    this._mockLoadSaleRequestTempCall().thenThrow(error);
  }
}
