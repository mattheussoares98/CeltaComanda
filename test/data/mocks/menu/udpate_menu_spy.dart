// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class UpdateMenuSpy extends Mock implements UpdateMenu {
  UpdateMenuSpy() {
    _updateCall().thenAnswer((any) async => any);
  }

  void mockUpdateError() {
    _updateCall().thenThrow(DomainError.unexpected);
  }

  When _updateCall() => when(() => this.update(any()));
}
