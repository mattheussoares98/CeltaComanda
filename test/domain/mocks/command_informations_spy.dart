// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class CommandInformationsSpy extends Mock implements CommandInformations {
  CommandInformationsSpy() {
    this.mockTicketIsPermitted(null);
    this.mockOpenOrBlockade(true);
  }
  When mockTicketIsPermittedsCall() => when(() => this.ticketIsPermitted(
        url: any(named: "url"),
        commandNumber: any(named: "commandNumber"),
      ));

  void mockTicketIsPermitted(TicketIsPermittedEntity? entity) {
    this.mockTicketIsPermittedsCall().thenAnswer((_) async => entity);
  }

  void mockErrorTicketIsPermitted() {
    this
        .mockTicketIsPermittedsCall()
        .thenThrow(DomainError.commandNotAvailable);
  }

  When mockOpenOrBlockadeSpyCall() => when(() => this.openOrBlockade(
        commandNumber: any(named: "commandNumber"),
        block: any(named: "block"),
      ));

  void mockOpenOrBlockade(bool isBlockade) {
    this.mockOpenOrBlockadeSpyCall().thenAnswer((_) async => isBlockade);
  }

  void mockErrorOpenOrBlockade(DomainError error) {
    this.mockOpenOrBlockadeSpyCall().thenThrow(error);
  }
}
