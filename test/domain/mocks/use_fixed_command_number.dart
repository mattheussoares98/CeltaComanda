// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class LoadCommandDataSpy extends Mock implements LocalCommandData {
  When mockUpdateAll() => when(() => this.update(any()));
  void mockUpdate() => this.mockUpdateAll().thenAnswer((_) async => _);
  void mockUpdateError() =>
      this.mockUpdateAll().thenThrow(DomainError.unexpected);

  When mockLoadCall() => when(() => this.load());
  void mockLoad(CommandEntity? entity) => this.mockLoadCall().thenAnswer((_) async => entity);
  void mockLoadError() => this.mockLoadCall().thenThrow(Exception());
}
