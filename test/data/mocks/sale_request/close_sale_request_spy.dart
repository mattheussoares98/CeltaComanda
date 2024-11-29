// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class CloseSaleRequestSpy extends Mock implements CloseSaleRequest {
  CloseSaleRequestSpy() {
    this.mockClose();
  }

  When _mockCloseCall() => when(() => this.close(any()));

  void mockClose() {
    this._mockCloseCall().thenAnswer((any) async => any);
  }

  void mockError() {
    this._mockCloseCall().thenThrow(DomainError.unexpected);
  }
}
