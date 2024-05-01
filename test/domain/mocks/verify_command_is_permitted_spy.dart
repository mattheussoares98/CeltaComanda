// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class VerifyCommandIsPermittedSpy extends Mock
    implements VerifyCommandIsPermitted {
  VerifyCommandIsPermittedSpy() {
    mockVerifyCommandIsPermitted();
  }
  When mockVerifyCommandIsPermittedsCall() => when(() => this.verify(
        url: any(named: "url"),
        commandNumber: any(named: "commandNumber"),
      ));

  void mockVerifyCommandIsPermitted() {
    this.mockVerifyCommandIsPermittedsCall().thenAnswer((_) async => _);
  }

  void mockError() {
    this.mockVerifyCommandIsPermittedsCall().thenThrow(Exception());
  }
}
