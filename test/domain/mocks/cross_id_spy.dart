// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class CrossIdSpy extends Mock implements SaveCrossId, LoadCrossId {
  CrossIdSpy() {
    this.mockSave();
  }

  When mockSaveCall() => when(() => this.save(any()));
  void mockSave() => this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError(DomainError error) =>
      this.mockSaveCall().thenThrow(error);

  When mockLoadCall() => when(() => load());
  void mockLoad({required CrossIdEntity account}) =>
      mockLoadCall().thenAnswer((_) async => account);
  void mockLoadError() => mockLoadCall().thenThrow(Exception());
}
