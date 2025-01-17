// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class DeleteEnterpriseSpy extends Mock implements DeleteEnterprise {
  DeleteEnterpriseSpy() {
    this.mockDelete();
  }
  When _mockDeleteCall() => when(() => this.delete(any()));
  void mockDelete() => this._mockDeleteCall().thenAnswer((any) async => any);
  void mockDeleteError() => this._mockDeleteCall().thenThrow(Exception());
}
