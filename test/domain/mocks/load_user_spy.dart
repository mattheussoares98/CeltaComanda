// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class LoadUserNameSpy extends Mock implements LoadUserName {
  LoadUserNameSpy() {
    this.mockLoad(null);
  }

  When mockLoadCall() => when(() => this.load());
  void mockLoad(String? value) =>
      this.mockLoadCall().thenAnswer((_) async => value);
  void mockLoadError() => this.mockLoadCall().thenThrow(DomainError.unexpected);
}
