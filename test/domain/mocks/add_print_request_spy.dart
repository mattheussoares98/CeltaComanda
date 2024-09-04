// ignore_for_file: unnecessary_this
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class AddPrintRequestSpy extends Mock implements AddPrintRequest {
  AddPrintRequestSpy() {
    this.mockRemoteAdd();
  }

  When mockAddPrintRequestCall() => when(() => add(any()));
  void mockRemoteAdd() =>
      this.mockAddPrintRequestCall().thenAnswer((any) async => any);
  void mockRemoteAddError() =>
      this.mockAddPrintRequestCall().thenThrow(Exception());
}
