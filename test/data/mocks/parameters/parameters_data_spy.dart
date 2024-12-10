// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class ParametersDataSpy extends Mock implements ParametersData {
  ParametersDataSpy() {
    this.mockUpdate();
  }
  When _mockLoadCall() => when(() => this.load());

  void mockLoad(List<ParameterModel> value) {
    this._mockLoadCall().thenAnswer((_) async => value);
  }

  void mockLoadError() => _mockLoadCall().thenThrow(Exception());

  When _mockUpdateCall() => when(() => this.update(any()));

  void mockUpdate() {
    this._mockUpdateCall().thenAnswer((any) async => any);
  }

  void mockUpdateError() {
    this._mockUpdateCall().thenThrow(DomainError.unexpected);
  }
}
