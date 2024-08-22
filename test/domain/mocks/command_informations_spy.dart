// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class CommandInformationsSpy extends Mock implements CommandInformations {
  CommandInformationsSpy() {
    this.mockTicketIsPermitted(null);
    this.mockOpenOrBlockade(true);
    this.mockIsValidDateTime(true);
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

  When mockOpenOrBlockadeCall() => when(() => this.openOrBlockade(
        commandNumber: any(named: "commandNumber"),
        block: any(named: "block"),
      ));

  void mockOpenOrBlockade(bool isBlockade) {
    this.mockOpenOrBlockadeCall().thenAnswer((_) async => isBlockade);
  }

  void mockErrorOpenOrBlockade(DomainError error) {
    this.mockOpenOrBlockadeCall().thenThrow(error);
  }

  When mockIsValidDateTimeCall() => when(() => this.isValidDatetime(
        commandNumber: any(named: "commandNumber"),
      ));

  void mockIsValidDateTime(bool isValid) {
    this.mockIsValidDateTimeCall().thenAnswer((_) async => isValid);
  }

  void mockErrorIsValidDateTime() {
    this.mockIsValidDateTimeCall().thenThrow(DomainError.blockedCommand);
  }
}
