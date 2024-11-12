// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class LocalCommandDataSpy extends Mock implements LocalCommandData {
  LocalCommandDataSpy() {
    this.mockUpdate();
  }

  When _mockUpdateCall() => when(() => this.update(any()));
  void mockUpdate() => this._mockUpdateCall().thenAnswer((any) async => any);
  void mockUpdateError() =>
      this._mockUpdateCall().thenThrow(DomainError.unexpected);

  When mockLoadCall() => when(() => this.load());
  void mockLoad(CommandEntity? entity) =>
      this.mockLoadCall().thenAnswer((_) async => entity);
  void mockLoadError() => this.mockLoadCall().thenThrow(Exception());
}
