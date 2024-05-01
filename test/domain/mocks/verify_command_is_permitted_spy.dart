// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class TicketIsPermittedSpy extends Mock
    implements TicketIsPermitted {
  ticketIsPermittedSpy() {
    mockticketIsPermitted();
  }
  When mockticketIsPermittedsCall() => when(() => this.verify(
        url: any(named: "url"),
        commandNumber: any(named: "commandNumber"),
      ));

  void mockticketIsPermitted() {
    this.mockticketIsPermittedsCall().thenAnswer((_) async => _);
  }

  void mockError() {
    this.mockticketIsPermittedsCall().thenThrow(DomainError.commandNotAvailable);
  }
}
