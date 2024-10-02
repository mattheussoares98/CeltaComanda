// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSaleRequestSpy extends Mock implements LoadSaleRequest {
  When _mockLoadSaleRequestCall() => when(() => this.load(
        commandNumber: any(named: "commandNumber"),
      ));

  void mockLoadSaleRequest(SaleRequestModel entity) {
    this._mockLoadSaleRequestCall().thenAnswer((_) async => entity);
  }

  void mockError() {
    this._mockLoadSaleRequestCall().thenThrow(Exception());
  }
}
