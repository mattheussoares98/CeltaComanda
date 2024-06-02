// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class TicketIsPermittedSpy extends Mock
    implements TicketIsPermitted {
  TicketIsPermittedSpy() {
    mockTicketIsPermitted(null);
  }
  When mockTicketIsPermittedsCall() => when(() => this.verify(
        url: any(named: "url"),
        commandNumber: any(named: "commandNumber"),
      ));

  void mockTicketIsPermitted(TicketIsPermittedEntity? entity) {
    this.mockTicketIsPermittedsCall().thenAnswer((_) async => entity);
  }

  void mockError() {
    this.mockTicketIsPermittedsCall().thenThrow(DomainError.commandNotAvailable);
  }
}
