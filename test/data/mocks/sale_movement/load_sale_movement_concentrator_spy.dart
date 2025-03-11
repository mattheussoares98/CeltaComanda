// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSaleMovementConcentratorSpy extends Mock
    implements ConcLoadSaleMovement {
  LoadSaleMovementConcentratorSpy() {
    mockLoad(null);
  }
  When _mockLoadCall() => when(() => this.load(date: any(named: "date")));

  void mockLoad(List<SaleMovementConcentratorEntity>? sales) {
    _mockLoadCall().thenAnswer((_) async => sales);
  }

  void mockError(DomainError error) {
    _mockLoadCall().thenThrow(error);
  }
}
