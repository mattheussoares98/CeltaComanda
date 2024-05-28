// ignore_for_file: unnecessary_this
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class AddPrintRequestSpy extends Mock implements AddPrintRequest {
  AddPrintRequestSpy() {
    this.mockRemoteLoad();
  }

  When mockAddPrintRequestCall() => when(() => add());
  void mockRemoteLoad() =>
      this.mockAddPrintRequestCall().thenAnswer((_) async => _);
  void mockRemoteLoadError() =>
      this.mockAddPrintRequestCall().thenThrow(Exception());
}
