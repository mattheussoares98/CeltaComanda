// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSaleMovementConcentratorSpy extends Mock
    implements LoadSaleMovementConcentrator {
  LoadSaleMovementConcentratorSpy() {
    mockLoad(null);
  }
  When _mockLoadCall() => when(() => this.load(date: any(named: "date")));

  void mockLoad(String? date) {
    _mockLoadCall().thenAnswer((_) async => date);
  }

  void mockError() {
    _mockLoadCall().thenThrow(Exception());
  }
}
