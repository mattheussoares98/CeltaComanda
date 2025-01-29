// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class DeleteDataSpy extends Mock implements DeleteData {
  DeleteDataSpy() {
    this.mockLaunch();
  }

  When _mockDeleteDataCall() => when(() => this.delete(any()));

  void mockLaunch() {
    this._mockDeleteDataCall().thenAnswer((any) async => any);
  }

  void mockLaunchError() {
    this._mockDeleteDataCall().thenThrow(Exception());
  }
}
